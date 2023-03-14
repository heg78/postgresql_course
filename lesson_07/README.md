# postgresql_course lesson 7
## Домашнее задание

1. создайте новый кластер PostgresSQL 14
2. зайдите в созданный кластер под пользователем postgres
3. создайте новую базу данных testdb
4. зайдите в созданную базу данных под пользователем postgres
```
postgres=# create database testdb
postgres-# ;
CREATE DATABASE
postgres=# \c testdb
You are now connected to database "testdb" as user "postgres".
testdb=# 
```
5. создайте новую схему testnm
```
testdb=# CREATE SCHEMA testnm;
CREATE SCHEMA
testdb=# 
```
6. создайте новую таблицу t1 с одной колонкой c1 типа integer
```
testdb=# CREATE TABLE t1(c1 integer);
CREATE TABLE
```
7. вставьте строку со значением c1=1
```
testdb=# INSERT INTO t1 values(1);
INSERT 0 1
```
8. создайте новую роль readonly
```
testdb=# CREATE role readonly;
CREATE ROLE
```
9. дайте новой роли право на подключение к базе данных testdb
```
testdb=# grant connect on DATABASE testdb TO readonly;
GRANT
```
10. дайте новой роли право на использование схемы testnm
```
testdb=# grant usage on SCHEMA testnm to readonly;
GRANT
```
11. дайте новой роли право на select для всех таблиц схемы testnm
```
testdb=# grant SELECT on all TABLEs in SCHEMA testnm TO readonly;
GRANT
```
12. создайте пользователя testread с паролем test123
```
testdb=# CREATE USER testread with password 'test123';
CREATE ROLE
```
13. дайте роль readonly пользователю testread
```
testdb=# grant readonly TO testread;
GRANT ROLE
```
14. зайдите под пользователем testread в базу данных testdb
```
testdb=# \c testdb testread
connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL:  Peer authentication failed for user "testread"
Previous connection kept
testdb=# 
```
15. сделайте select * from t1;
```
testdb=# SELECT * FROM t1;
 c1 
----
  1
(1 row)
```
16. получилось? (могло если вы делали сами не по шпаргалке и не упустили один существенный момент про который позже)
```
да
```
17. напишите что именно произошло в тексте домашнего задания
18. у вас есть идеи почему? ведь права то дали?
19. посмотрите на список таблиц
```
testdb=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | t1   | table | postgres
(1 row)
```
20. подсказка в шпаргалке под пунктом 20
21. а почему так получилось с таблицей (если делали сами и без шпаргалкито может у вас все нормально)
```
делал по шпаргалке, но таблицу видно т.к. в search_path =  "$user", public

testdb=# show search_path
testdb-# ;
   search_path   
-----------------
 "$user", public


```
22. вернитесь в базу данных testdb под пользователем postgres
23. удалите таблицу t1
```
testdb=# drop TABLE t1;
DROP TABLE
```
24. создайте ее заново но уже с явным указанием имени схемы testnm
```
testdb=# CREATE TABLE testnm.t1(c1 integer);
CREATE TABLE
```
25. вставьте строку со значением c1=1
```
testdb=# INSERT INTO testnm.t1 values(1);
INSERT 0 1
```
26. зайдите под пользователем testread в базу данных testdb
```
testdb=> \conninfo
You are connected to database "testdb" as user "testread" on host "127.0.0.1" at port "5432".
```
27. сделайте select * from testnm.t1;
```
testdb=> select * from testnm.t1;
ERROR:  permission denied for table t1

```
28. получилось?
```
нет
```
29. есть идеи почему? если нет - смотрите шпаргалку
30. как сделать так чтобы такое больше не повторялось? если нет идей - смотрите шпаргалку
31. сделайте select * from testnm.t1;
32. получилось?
```
нет
```
33. есть идеи почему? если нет - смотрите шпаргалку
31. сделайте select * from testnm.t1;
```
psql -h 127.0.0.1 -U testread -d testdb -W
Password: 
psql (14.7 (Ubuntu 14.7-1.pgdg22.04+1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

testdb=> select * from testnm.t1;
 c1 
----
  1
(1 row)

testdb=> 

```
32. получилось?
33. ура!
34. теперь попробуйте выполнить команду create table t2(c1 integer); insert into t2 values (2);
```
да
```
35. а как так? нам же никто прав на создание таблиц и insert в них под ролью readonly?
36. есть идеи как убрать эти права? если нет - смотрите шпаргалку
37. если вы справились сами то расскажите что сделали и почему, если смотрели шпаргалку - объясните что сделали и почему выполнив указанные в ней команды
38. теперь попробуйте выполнить команду create table t3(c1 integer); insert into t2 values (2);
```
create table t3(c1 integer);
ERROR:  permission denied for schema public
LINE 1: create table t3(c1 integer);

```
39. расскажите что получилось и почему 
```
по-умолчанию у каждого пользователя есть права на public, поскольку в search_path прописан public именно там и создавалась таблица t2. после того, как права убрали t3 не согли создать
```