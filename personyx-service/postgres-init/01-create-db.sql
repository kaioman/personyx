-- ユーザー作成
CREATE USER personyx WITH PASSWORD 'personyx';

-- personyxデータベース作成
CREATE DATABASE personyx_pg12 OWNER personyx;

-- 権限付与
GRANT ALL PRIVILEGES ON DATABASE personyx_pg12 TO personyx;
