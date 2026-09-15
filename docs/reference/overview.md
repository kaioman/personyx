# 概要

Personyx は、ペルソナを反映した AI 会話を提供する Discord Bot と、生成画像を閲覧する Web ギャラリーを組み合わせたアプリケーションです。会話には Gemini、画像生成には ComfyUI を利用し、ユーザー、認証アカウント、Bot プロファイル、ペルソナ、ワークフロー、生成画像、ログを PostgreSQL で管理します。

## 主要な責務

- Discord Bot がメッセージとスラッシュコマンドを受け付け、AI 応答と画像生成を実行します。
- ペルソナ管理が、ユーザーに有効な Bot プロファイルとペルソナを解決し、システム指示や定型文を生成します。
- 画像生成連携が ComfyUI のワークフローを実行し、生成ファイルを保存するとともにメタデータを永続化します。
- Web アプリケーションが Discord OAuth2 認証、セッション管理、生成画像の検索・表示を提供します。
- 共有設定が、環境変数、外部シークレット、共通アプリ初期化を Bot と Web に提供します。
- データモデルと Alembic が、ユーザーと生成物の関係およびスキーマ変更を管理します。

## 構成の概要

Discord とブラウザーが入口となり、Bot と Flask Web が共通の PostgreSQL を参照します。Bot は Gemini と ComfyUI に接続し、Web は Discord OAuth2 とリバースプロキシを介して認証・画像配信を行います。Docker Compose では DB、Bot、Web、Nginx を分離して起動します。

## 代表的な実装単位

| ファイル / モジュール | 主な責務 | 代表的な機能または備考 |
| --- | --- | --- |
| `personyx/bot/main.py` | Bot の非同期起動 | Discord Gateway への接続を開始します。 |
| `personyx/bot/core.py` | Bot の構成と依存関係の組み立て | DB セッション、AI クライアント、各サービス、Cog を初期化します。 |
| `personyx/bot/cogs/message_cog.py` | Discord メッセージ・コマンド処理 | 会話応答と画像生成要求をサービスへ委譲します。 |
| `personyx/bot/services/persona_service.py` | ペルソナと指示の解決 | DB のユーザー割り当てを優先し、ファイルへフォールバックします。 |
| `personyx/bot/services/comfyui_service.py` | 画像生成連携 | ComfyUI ワークフローの実行と生成結果の処理を担います。 |
| `personyx/bot/services/image_service.py` | 画像メタデータ永続化 | Discord ユーザーとアプリ内ユーザーを対応付けて画像情報を保存します。 |
| `personyx/shared/configs/initialize_app.py` | 共通アプリ初期化 | プロジェクトパス、環境、設定、シークレットの初期化を担います。 |
| `personyx/web/app.py` | Flask アプリケーションファクトリ | DB 初期化、ProxyFix、Blueprint 登録を行います。 |
| `personyx/web/routes/auth.py` | OAuth2 認証ルート | ログイン、コールバック、ログアウトを提供します。 |
| `personyx/web/routes/images.py` | ギャラリーと画像配信 | ログインユーザーの画像を条件付きで取得・表示します。 |
| `personyx/web/service/auth_service.py` | OAuth2 とユーザー登録 | Discord の認証情報を検証し、ユーザー・アカウントを登録します。 |
| `personyx/web/models/` | 永続化モデル | ユーザー、認証、プロファイル、ペルソナ、画像などを表現します。 |
| `personyx/web/alembic/versions/` | スキーマ変更履歴 | テーブル、制約、リレーションの変更を段階的に適用します。 |
| `personyx-service/docker-compose.yml` | 実行環境の構成 | PostgreSQL、Bot、Web、ネットワーク、ボリュームを定義します。 |

## 文書と実装の照合

README と主要実装の構成説明は概ね一致しています。一方、設計書は今回新規作成であり、既存の正式な設計基準はありません。Compose が `PERSONA_CHAT_DIR` を渡すのに対し、Bot の実装は `PERSONA_CAHT_DIR` を参照する点、Web の `FLASK_SECRET_KEY` 未設定時にランダム値を使う点は、運用方針を確定するための要設計変更事項です。テストファイルは確認できないため、テスト方針も新たに定義する必要があります。
