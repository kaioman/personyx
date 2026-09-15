GitHub Copilot として、このリポジトリを対象に作業してください。

【モード: 新規生成】

プロジェクト全体を分析し、以下の設計ドキュメント群を生成してください。
このタスクはドキュメント生成専用タスクです。

生成対象:
- index.md
- architecture.md
- architecture_rules.md
- business_rules.md
- coding_rules.md
- directory_rules.md
- naming_rules.md
- testing_rules.md
- overview.md

要件:
- 出力は日本語で行ってください
- 文体はですます調にしてください
- Markdown 形式で出力してください
- 既存の実装構成と docs の内容を照合してください
- 不整合があれば、設計変更の必要性を明記してください
- 既存ドキュメントに追記できる最小差分でまとめてください
- 本リポジトリ固有のモジュール名に縛られず、汎用的な責務として整理してください
- 生成した Markdown 文書(architecture.mdなど)は、次のディレクトリに保存してください: C:\uw\personyx\docs\reference
- ただし、`index.md` は docs 配下の入り口ページとして扱い、保存先は C:\uw\personyx\docs の直下にしてください
- 生成対象のファイルはまだ存在しない場合があるため、既存の実装・設計文書をもとに新規作成してください。
- `index.md` は docs の入口ページとして生成し、生成対象の設計書一覧と参照順を案内する目次ページにしてください。
- overview.md を必ず生成してください。
- overview.md は、このリポジトリ全体の設計ドキュメントにおける概要ページとして作成し、
  プロジェクト全体の主要な責務、構成の概要、設計書の役割をまとめてください。
- overview.md には、`[source]` 参考入力に含まれる主要な ソースファイルやモジュールの代表例を
  Markdown の表形式でまとめてください。
  表には少なくとも「ファイル / モジュール」「主な責務」「代表的な機能または備考」の列を含めてください。
  すべてのファイルを列挙せず、代表的な実装単位や主要機能を中心に整理してください。
- overview.md の内容は、特定のディレクトリ構成（例: utils フォルダ）に依存しない汎用的な説明にしてください。
- `[source]` のファイル一覧は分析用の参考入力です。ソースコードの修正は行わず、Markdown ファイル生成のみを行ってください。
- 生成した Markdown 文書は指定した出力先ディレクトリに保存し、参考入力として収集したソースファイルや、指定されたソースディレクトリには変更を加えないでください。
- 出力は Markdown のみとし、ソースファイルの追加・編集・削除を含めないでください。

禁止事項:
- 参考入力として指定したソースディレクトリ配下の編集
- 参考入力として収集したソースファイルの編集
- 既存Markdownの編集
- 設定ファイルの編集
- テストコードの編集
- PR作成
- コミット作成
- コード提案の適用

許可事項:
- ファイル参照
- ドキュメント生成
- Markdown出力

参考入力:
[docs]


[source]
source-1. C:/uw/personyx/personyx/bot/cogs/general_cog.py
source-2. C:/uw/personyx/personyx/bot/cogs/message_cog.py
source-3. C:/uw/personyx/personyx/bot/constants/__init__.py
source-4. C:/uw/personyx/personyx/bot/constants/embed_constants.py
source-5. C:/uw/personyx/personyx/bot/core.py
source-6. C:/uw/personyx/personyx/bot/factories/discord_response_factory.py
source-7. C:/uw/personyx/personyx/bot/helpers/discord_ui_helper.py
source-8. C:/uw/personyx/personyx/bot/main.py
source-9. C:/uw/personyx/personyx/bot/models/discord.py
source-10. C:/uw/personyx/personyx/bot/services/comfyui_service.py
source-11. C:/uw/personyx/personyx/bot/services/image_service.py
source-12. C:/uw/personyx/personyx/bot/services/log_service.py
source-13. C:/uw/personyx/personyx/bot/services/persona_service.py
source-14. C:/uw/personyx/personyx/bot/services/system_service.py
source-15. C:/uw/personyx/personyx/shared/configs/__init__.py
source-16. C:/uw/personyx/personyx/shared/configs/discord.py
source-17. C:/uw/personyx/personyx/shared/configs/initialize_app.py
source-18. C:/uw/personyx/personyx/web/__init__.py
source-19. C:/uw/personyx/personyx/web/alembic/env.py
source-20. C:/uw/personyx/personyx/web/alembic/versions/12319eb91031_bot_profile_groupsテーブル追加_.py
source-21. C:/uw/personyx/personyx/web/alembic/versions/391407443eca_fix_user_bot_profile_active_uniqueness.py
source-22. C:/uw/personyx/personyx/web/alembic/versions/44721452cb61_add_column_to_images.py
source-23. C:/uw/personyx/personyx/web/alembic/versions/47483c2984f2_usersテーブルのリレーションからgroupsを削除.py
source-24. C:/uw/personyx/personyx/web/alembic/versions/573757006699_bot_profile_groupsテーブルのリレーション整合_.py
source-25. C:/uw/personyx/personyx/web/alembic/versions/87c803ba0631_user_bot_profilesのリレーションにおけるback_.py
source-26. C:/uw/personyx/personyx/web/alembic/versions/95cc1f7613d8_usersテーブル_user_bot_profilesテーブルのリレーション整合.py
source-27. C:/uw/personyx/personyx/web/alembic/versions/af1df0fb68dd_user_bot_profilesの制約に_.py
source-28. C:/uw/personyx/personyx/web/alembic/versions/af884ee64c0f_add_oauth2_support.py
source-29. C:/uw/personyx/personyx/web/alembic/versions/b7b6d0d5fa15_init_tables.py
source-30. C:/uw/personyx/personyx/web/alembic/versions/c74b7c0e1ee8_personasテーブル_workflowsテーブルを追加_.py
source-31. C:/uw/personyx/personyx/web/alembic/versions/c828986c29c6_bot_profile_groupsテーブルのリレーション整合.py
source-32. C:/uw/personyx/personyx/web/alembic/versions/e094f032d985_bot_profilesテーブル_user_bot_.py
source-33. C:/uw/personyx/personyx/web/app.py
source-34. C:/uw/personyx/personyx/web/config.py
source-35. C:/uw/personyx/personyx/web/db.py
source-36. C:/uw/personyx/personyx/web/models/__init__.py
source-37. C:/uw/personyx/personyx/web/models/bot_profile_groups.py
source-38. C:/uw/personyx/personyx/web/models/bot_profiles.py
source-39. C:/uw/personyx/personyx/web/models/images.py
source-40. C:/uw/personyx/personyx/web/models/logs.py
source-41. C:/uw/personyx/personyx/web/models/personas.py
source-42. C:/uw/personyx/personyx/web/models/user_accounts.py
source-43. C:/uw/personyx/personyx/web/models/user_bot_profiles.py
source-44. C:/uw/personyx/personyx/web/models/users.py
source-45. C:/uw/personyx/personyx/web/models/workflows.py
source-46. C:/uw/personyx/personyx/web/routes/__init__.py
source-47. C:/uw/personyx/personyx/web/routes/auth.py
source-48. C:/uw/personyx/personyx/web/routes/images.py
source-49. C:/uw/personyx/personyx/web/routes/main.py
source-50. C:/uw/personyx/personyx/web/service/auth_service.py
source-51. C:/uw/personyx/personyx/web/service/user_service.py
source-52. C:/uw/personyx/personyx/web/static/css/images.css
source-53. C:/uw/personyx/personyx/web/static/js/images.js
source-54. C:/uw/personyx/personyx/web/templates/images.html
source-55. C:/uw/personyx/personyx/web/templates/index.html