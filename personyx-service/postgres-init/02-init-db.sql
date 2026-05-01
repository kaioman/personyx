-- personyx_pg12データベースに切り替え
\c personyx_pg12

-- pgcrypto拡張機能有効化
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- スキーマ作成
CREATE SCHEMA IF NOT EXISTS personyx AUTHORIZATION personyx;

-- デフォルトスキーマ設定 
ALTER DATABASE personyx_pg12 SET search_path TO personyx, public;

-- ユーザーにスキーマの使用権限を付与
GRANT ALL ON SCHEMA personyx TO personyx;
