-- スキーマ作成
CREATE SCHEMA IF NOT EXISTS personyx AUTHORIZATION personyx;

-- pgcrypto拡張機能有効化
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- デフォルトスキーマ設定 
ALTER DATABASE personyx_pg12 SET search_path TO personyx, public;
