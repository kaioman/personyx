# ディレクトリルール

## 構成

| 場所 | 責務 |
| --- | --- |
| `personyx/bot/` | Discord Bot の起動、Cog、サービス、Bot 用設定 |
| `personyx/bot/cogs/` | Discord イベントとコマンドの受付・応答 |
| `personyx/bot/services/` | AI、ペルソナ、画像、ログ、外部 API 連携 |
| `personyx/bot/models/` | Bot 側で扱う外部サービス向けデータ表現 |
| `personyx/bot/configs/` | ペルソナ、指示、ワークフローなどの設定素材 |
| `personyx/shared/` | Bot と Web の共通初期化・設定 |
| `personyx/web/` | Flask アプリケーション |
| `personyx/web/routes/` | HTTP ルートと Blueprint |
| `personyx/web/service/` | 認証・ユーザーなど Web のユースケース |
| `personyx/web/models/` | SQLAlchemy の永続化モデル |
| `personyx/web/alembic/` | Alembic 設定とスキーマ変更履歴 |
| `personyx/web/templates/` | HTML テンプレート |
| `personyx/web/static/` | CSS、JavaScript など静的資産 |
| `docs/` | 設計文書と生成プロンプト |
| `personyx-service/` | Compose、Dockerfile、Nginx、DB 初期化資材 |

## 配置ルール

- 新しい Discord 入力は Cog、ユースケースはサービス、DB 構造は Web モデルへ配置します。
- HTTP の入口は Blueprint へ置き、複数ルートにまたがる処理は Web サービスへ移します。
- DB スキーマの変更は `web/alembic/versions/` に履歴として追加します。
- UI のテンプレートと静的資産は Web の対応するディレクトリに置きます。
- ペルソナやワークフローのデータはコードと分離した設定資材として管理します。
- 設計文書は `docs/reference/` に置き、入口の目次だけを `docs/index.md` に置きます。
- 一時生成物、秘密情報、ローカル DB データはリポジトリの管理対象ディレクトリへ追加しません。

## 文書との照合

現行のディレクトリ構成は README の説明と整合しています。既存のテストディレクトリは確認できなかったため、テスト追加時は対象責務の近くに配置するか、プロジェクト共通のテスト配置を先に決定してください。
