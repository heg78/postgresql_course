# postgresql_course lesson 20
## Домашнее задание


1. Секционировать большую таблицу из демо базы flights

Указанной таблицы не оказалось под рукой...
```  
create table table1 (
id bigserial,
name text,
create_date date,
some_sum numeric
)
partition by range (create_date);

```

![Alt text](image.png)

```
create table big_partition partition of table1 for values from (minvalue) to (maxvalue);
```
![Alt text](image-3.png)

```
insert into table1 values (1,'some_text',null,100);
```
![Alt text](image-2.png)
```
explain
select * from table1;
```
![Alt text](image-4.png)
```
insert into table1 values (1,'some_text',date'2020-01-01',100);
create table default_partition partition of table1 default;
insert into table1 values (1,'some_text',null,100);
```
![Alt text](image-5.png)
```
select * from table1;
```
![Alt text](image-6.png)
```
select * from default_partition;
```
![Alt text](image-7.png)
```
SET enable_partition_pruning = on;
```
![Alt text](image-8.png)
```
explain
select *
from table1
where create_date is null;
```
![Alt text](image-10.png)