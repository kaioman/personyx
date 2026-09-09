# Personyx

Personyxは、ペルソナを切り替えながらAIと会話できるDiscord Botと、生成画像を閲覧するWebギャラリーを組み合わせたアプリケーションです。会話にはGeminiを使用し、画像生成にはComfyUIを使用します。ユーザー、ペルソナ、Botプロファイル、会話ログ、生成画像の情報はPostgreSQLで管理します。

このREADMEは、`personyx/bot`、`personyx/shared`、`personyx/web`の実装から確認できる、開発・運用に必要な概要と起動手順をまとめたものです。詳細な設計や仕様は別ドキュメントで管理します。

## 主な機能

- Discordのメッセージを受信し、ペルソナ設定を反映したGeminiの応答を返す
- チャンネルとユーザーごとに会話セッションを保持する
- Discordスラッシュコマンド`/dressup`で、レーティングを選択して画像を生成する
- ComfyUIのワークフローを実行し、生成画像とメタデータを保存する
- Discord OAuth2でWebサイトにログインする
- ログインユーザー自身の生成画像をギャラリーで閲覧・絞り込み・拡大・ダウンロードする
- ペルソナ、Botプロファイル、ワークフローをDBからユーザー単位で解決する

## システム構成

```text
Discordユーザー
	 |
	 v
Discord Bot ---- Gemini API
	 |
	 +----------- ComfyUI API ---- 生成画像
	 |
	 +----------- PostgreSQL
							  ^
							  |
Browser -- Nginx --> Flask Web -- Discord OAuth2
```

Docker Composeでは次のサービスを起動します。

| サービス | 役割 | デフォルト公開ポート |
| --- | --- | --- |
| `personyx_db` | PostgreSQL 12。アプリデータを保存 | `5211`（コンテナ内`5432`） |
| `personyx_bot` | Discord Bot、AI対話、画像生成要求 | なし |
| `personyx_web` | Flask Web、認証、ギャラリー | `5000` |
| `nginx` | HTTPS終端とWebへのリバースプロキシ | `80`、`443` |

BotとWebは同じPostgreSQLを利用します。Webコンテナの起動時には`alembic upgrade head`が実行されてからFlaskアプリが起動します。

## ディレクトリ

```text
personyx/
├─ bot/       Discord Bot、AI対話、画像生成、ペルソナ設定
├─ shared/    BotとWebで共有するアプリ初期化・設定
└─ web/       Flaskアプリ、DBモデル、認証、ギャラリー

personyx-service/
├─ docker-compose.yml          開発・運用用サービス定義
├─ docker-compose.override.yml 開発時の追加設定
├─ Dockerfile.bot
├─ Dockerfile.web
├─ postgres-init/              DB・スキーマの初期化SQL
└─ nginx/                      リバースプロキシ設定
```

### Bot

- `bot/main.py`が起動エントリポイントです。
- `MessageCog`が通常メッセージを受信し、ペルソナからシステム指示を構築してGeminiへ送信します。
- `PersonaService`は、ユーザーに割り当てられたDB上のペルソナを優先し、見つからない場合はJSONファイルへフォールバックします。
- `/dressup`はレーティング選択メニューを表示し、`ComfyUIService`でワークフローを実行します。
- 生成画像は`bot/gen_images`に保存され、画像メタデータはDBに登録されます。
- `/dressup_debug`はワークフローファイルを直接指定するデバッグ用コマンドです。

### Web

- `web/app.py`のFlaskアプリファクトリでDB、Blueprint、リバースプロキシ対応を初期化します。
- `/`はトップページ、`/images`は画像ギャラリーです。
- `/login`、`/callback`、`/logout`でDiscord OAuth2ログインを処理します。
- `/gen_images/<filename>`で生成画像を配信します。
- 未ログイン時は画像一覧を表示せず、ログインユーザーの画像だけを最大200件取得します。レーティングと`scene_id`で絞り込めます。

### Shared

`shared/configs/initialize_app.py`が、プロジェクトルートの解決、`personyx-service/.env`の読み込み、暗号化設定を含むアプリ設定の初期化を担当します。BotとWebはこの共有初期化処理を経由して設定を取得します。

## 前提条件

- Docker DesktopおよびDocker Compose
- DiscordアプリケーションとBotトークン
- Discord OAuth2のクライアント設定（Webログインを使う場合）
- Geminiを利用するためのGoogle Cloud / Vertex AI設定
- 画像生成に使うComfyUIサーバーとAPI接続設定
- 暗号化設定の復号に必要な鍵・認証情報

Pythonをホストで直接実行する場合は、BotとWebそれぞれの`requirements.txt`をインストールしてください。ただし、依存サービス・環境変数・パス設定が必要なため、通常はComposeでの起動を推奨します。

## 起動手順

1. `personyx-service/.env`と、必要に応じて`personyx-service/.env.dev`または`.env.prod`を用意します。値はリポジトリ内のCompose定義で参照される環境変数に合わせて設定してください。
2. Google Cloudの認証情報、秘密鍵、Discord設定、Gemini設定、ComfyUI設定を環境に配置します。秘密情報はコミットしないでください。
3. 開発環境では、`personyx-service`ディレクトリで次を実行します。

	```powershell
	docker-compose --env-file .\.env --env-file .\.env.dev up -d
	```

4. Webを確認します。

	- Composeへ直接アクセスする場合: `http://localhost:5000/`
	- Nginxを使用する場合: `http://local.personyx/`または設定済みのHTTPS URL

5. DiscordサーバーへBotを追加し、Botがオンラインになったことを確認します。メッセージ応答にはDiscord Developer PortalでMessage Content Intentを有効にする必要があります。

停止する場合は、同じディレクトリで次を実行します。

```powershell
docker-compose --env-file .\.env --env-file .\.env.dev down
```

## Discordでの利用

### AI対話

Botが参加しているチャンネルにメッセージを送ると、ペルソナ設定を反映したAI応答がDiscord Embedで返ります。Bot自身のメッセージは処理されません。会話セッションはチャンネルとアプリ内ユーザーの組み合わせで管理され、起動中は履歴を保持します。

### 画像生成

1. `/dressup`を実行します。
2. 表示されたメニューからレーティングを選択します。
3. ペルソナの設定とComfyUIワークフローに基づいて画像が生成されます。
4. 生成画像はDiscordへ送信され、DBと`bot/gen_images`に保存されます。

画像を保存するには、対象DiscordアカウントがWebサイトで一度ログインして、アプリ内ユーザーとして登録されている必要があります。未登録ユーザーの場合、生成画像のDB保存は失敗します。

## 設定

Composeで主に利用する設定項目は次のとおりです。実際の値や秘密情報は環境に合わせて設定してください。

| 設定 | 用途 |
| --- | --- |
| `DATABASE_URL` | PostgreSQL接続先。未指定時のコンテナ内既定値は`personyx_pg12` |
| `DISCORD_REDIRECT_URI` | Discord OAuth2コールバックURL |
| `DISCORD_AUTH_BASE`、`DISCORD_TOKEN_URL`、`DISCORD_USER_API` | Discord OAuth2のエンドポイント |
| `DISCORD_SCOPE` | OAuth2で要求するスコープ |
| `PERSONA_NAME` | 起動時の既定ペルソナ名。既定値は`Aoi` |
| `PERSONA_CONF_DIR` | ペルソナ設定ディレクトリ |
| `PERSONA_CAHT_DIR` | Botが実際に参照するチャット用ペルソナディレクトリ。コード上の綴りに合わせた名前 |
| `INSTRUCTION_PATH` | システム指示JSONのパス |
| `GEN_IMAGES_DIR` | Webから配信する生成画像ディレクトリ |
| `ITEMS_PER_PAGE` | ギャラリーの1ページ表示件数。既定値は`24` |
| `TEMPERATURE` | Geminiチャットの温度。既定値は`0.9` |
| `VIEW_TIMEOUT` | 画像生成メニューのタイムアウト秒数。既定値は`60` |
| `GCP_*`、`GOOGLE_APPLICATION_CREDENTIALS` | Google Cloud / Vertex AI認証・プロジェクト設定 |

Botのペルソナ設定は、主に`bot/configs/personas/<名前>/`に配置します。ここには`persona.json`、`character_spec.json`、プロンプト素材、ComfyUIワークフローが含まれます。DBに有効なユーザー割り当てがある場合は、DBのペルソナ・ワークフロー設定が優先されます。なお、Composeの変数名は`PERSONA_CHAT_DIR`ですが、現行のBotコードは`PERSONA_CAHT_DIR`を参照するため、未指定時は既定パスが使われます。

## データベースとマイグレーション

初回起動時に`postgres-init/`のSQLで、`personyx_pg12`データベース、`personyx`スキーマ、`pgcrypto`拡張を作成します。テーブル構造の変更は`personyx/web/alembic/versions/`で管理します。

Webコンテナ起動時に自動適用されます。手動で適用する場合は、`personyx/web`を作業ディレクトリにして次を実行します。

```powershell
alembic upgrade head
```

主なモデルは、ユーザー、外部認証アカウント、Botプロファイルグループ、Botプロファイル、ユーザーへのプロファイル割り当て、ペルソナ、ワークフロー、生成画像、会話ログです。

## ログとトラブルシューティング

コンテナの状態とログは次で確認できます。

```powershell
docker-compose ps
docker-compose logs -f personyx_web
docker-compose logs -f personyx_bot
```

コンテナが再起動ループに入る場合、以下のコマンドでエントリーポイントを上書きしてコンテナを起動可能です。

```powershell
docker-compose --env-file .env --env-file .env.dev run --rm --no-deps --entrypoint sh personyx_bot
docker-compose --env-file .env --env-file .env.dev run --rm --no-deps --entrypoint sh personyx_web
```

確認ポイント:

- Webに接続できない場合は、`personyx_web`の起動状態、`DATABASE_URL`、マイグレーション結果を確認する
- Discordログインが失敗する場合は、リダイレクトURLとOAuth2エンドポイント、Webのセッションキーを確認する
- Botが応答しない場合は、Botトークン、Message Content Intent、Gemini認証、`PYTHONPATH`を確認する
- 画像生成に失敗する場合は、ComfyUIの接続先、ワークフローJSON、ペルソナの設定パス、`gen_images`の書き込み権限を確認する
- ギャラリーに画像が出ない場合は、Webログイン済みのユーザーとDiscordアカウントの紐付け、およびDBの画像レコードを確認する

## ライセンス

ライセンス情報は[LICENSE](LICENSE)を参照してください。
