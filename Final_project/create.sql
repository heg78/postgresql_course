CREATE USER otus WITH PASSWORD 'otus';
CREATE DATABASE db_otus;
GRANT ALL PRIVILEGES ON DATABASE db_otus TO otus;
\c db_otus otus
CREATE SCHEMA otus;
DROP SCHEMA public;
GRANT ALL ON SCHEMA otus TO otus;
