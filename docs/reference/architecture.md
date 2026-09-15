# アーキテクチャ

## システム境界

Personyx は、Discord 連携を入口とする Bot 実行系、ブラウザーを入口とする Web 実行系、両者が共有する永続化・設定基盤で構成されます。外部依存は Discord API、Gemini / Vertex AI、ComfyUI、PostgreSQL、必要に応じて GCP の認証・シークレット基盤です。

```text
Discord -> Discord Bot -> Gemini
                    -> ComfyUI -> 画像ファイル
                    -> PostgreSQL <- Flask Web <- Browser
Browser -> Flask Web -> Discord OAuth2
```

## 実行コンポーネント

- **Bot**: `main.py` が `MyBot` を起動し、`setup_hook` でサービスと Cog を登録します。通常メッセージとスラッシュコマンドは Cog が受け付けます。
- **AI・生成サービス**: ペルソナ解決、Gemini 呼び出し、ComfyUI ワークフロー実行、ログと画像メタデータ保存を分担します。
- **Web**: Flask アプリファクトリが設定、DB セッション、ProxyFix、Blueprint を初期化します。認証とギャラリーはルートおよびサービスに分離されています。
- **永続化**: SQLAlchemy モデルが `personyx` スキーマのテーブルを表現し、Alembic が変更履歴を適用します。
- **配備**: Docker Compose が DB の起動待ち、Bot/Web のコンテナ、共有ネットワーク、画像ボリュームを管理します。

## 主要なデータフロー

1. Discord ユーザーの識別子をアプリ内ユーザーへ解決します。
2. `UserBotProfiles`、`BotProfiles`、`BotProfileGroups` の有効状態を確認し、有効ペルソナを取得します。
3. ペルソナ設定と共通指示を組み合わせ、Gemini へ渡すシステム指示を生成します。
4. 画像生成時はワークフローを実行し、画像ファイルを保存して `Images` にメタデータを登録します。
5. Web OAuth2 は `UserAccounts` を介して `Users` を取得または作成し、セッションのユーザー ID でギャラリーを絞り込みます。

## 依存方向

外部 API への接続と DB 操作はサービス層へ集約し、Cog と Web ルートは入力の受付・認可・応答整形を担当します。モデルは永続化の構造を表現し、外部 API の詳細を持ちません。共有設定は Bot と Web の初期化で利用します。

## 要設計変更

- `FLASK_SECRET_KEY` 未設定時のランダム生成は再起動でセッションを無効化するため、本番では必須設定にする方針が必要です。
- DB 接続初期化は Bot と Web が個別に行います。接続プール、タイムアウト、マイグレーション完了をアプリ起動条件にするかを運用設計で明確にする必要があります。
- 画像ファイルと DB メタデータの原子性は外部ファイルシステムに依存しています。失敗時の再試行・孤児ファイル削除方針が必要です。
