-- personyxデータベース作成
CREATE DATABASE personyx_pg12;

-- ユーザー作成
CREATE USER personyx WITH PASSWORD 'personyx';
GRANT ALL PRIVILEGES ON DATABASE personyx_pg12 TO personyx;
