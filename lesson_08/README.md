# postgresql_course lesson 8
## Домашнее задание


1. создать GCE инстанс типа e2-medium и диском 10GB
2. установить на него PostgreSQL 14 с дефолтными настройками
3. применить параметры настройки PostgreSQL из прикрепленного к материалам занятия файла
```  
postgres=# alter system set max_connections = 40;
ALTER SYSTEM
postgres=# alter system set shared_buffers = '1GB';
ALTER SYSTEM
postgres=# alter system set effective_cache_size = '3GB';
ALTER SYSTEM
postgres=# alter system set maintenance_work_mem = '512MB';
ALTER SYSTEM
postgres=# alter system set checkpoint_completion_target = 0.9;
ALTER SYSTEM
postgres=# alter system set wal_buffers = '16MB';
ALTER SYSTEM
postgres=# alter system set default_statistics_target = 500;
ALTER SYSTEM
postgres=# alter system set random_page_cost = 4;
ALTER SYSTEM
postgres=# alter system set effective_io_concurrency = 2;
ALTER SYSTEM
postgres=# alter system set work_mem = '6553kB';
ALTER SYSTEM
postgres=# alter system set min_wal_size = '4GB';
ALTER SYSTEM
postgres=# alter system set max_wal_size = '16GB';
ALTER SYSTEM
postgres=# 

user-vm01-yc@vm01-yc:~$ sudo systemctl restart postgresql@14-main
user-vm01-yc@vm01-yc:~$ 

```
4. выполнить pgbench -i postgres
```
user-vm01-yc@vm01-yc:~$ sudo -u postgres pgbench -i postgres 
dropping old tables...
NOTICE:  table "pgbench_accounts" does not exist, skipping
NOTICE:  table "pgbench_branches" does not exist, skipping
NOTICE:  table "pgbench_history" does not exist, skipping
NOTICE:  table "pgbench_tellers" does not exist, skipping
creating tables...
generating data (client-side)...
100000 of 100000 tuples (100%) done (elapsed 0.07 s, remaining 0.00 s)
vacuuming...
creating primary keys...
done in 0.97 s (drop tables 0.00 s, create tables 0.17 s, client-side generate 0.40 s, vacuum 0.18 s, primary keys 0.22 s).
user-vm01-yc@vm01-yc:~$ 
```
5. запустить pgbench -c8 -P 60 -T 600 -U postgres postgres
6. дать отработать до конца
```
user-vm01-yc@vm01-yc:~$ sudo -u postgres pgbench -c8 -P 60 -T 600 postgres
pgbench (14.7 (Ubuntu 14.7-1.pgdg22.04+1))
starting vacuum...end.
progress: 60.0 s, 563.7 tps, lat 14.186 ms stddev 12.477
progress: 120.0 s, 551.0 tps, lat 14.520 ms stddev 13.712
progress: 180.0 s, 592.2 tps, lat 13.508 ms stddev 11.212
progress: 240.0 s, 612.1 tps, lat 13.068 ms stddev 10.473
progress: 300.0 s, 608.1 tps, lat 13.155 ms stddev 11.045
progress: 360.0 s, 628.7 tps, lat 12.723 ms stddev 10.519
progress: 420.0 s, 630.9 tps, lat 12.677 ms stddev 9.930
progress: 480.0 s, 569.4 tps, lat 14.051 ms stddev 11.868
progress: 540.0 s, 569.9 tps, lat 14.036 ms stddev 14.015
progress: 600.0 s, 599.4 tps, lat 13.346 ms stddev 10.470
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 355541
latency average = 13.500 ms
latency stddev = 11.612 ms
initial connection time = 15.166 ms
tps = 592.566248 (without initial connection time)
user-vm01-yc@vm01-yc:~$ 
```
7. дальше настроить autovacuum максимально эффективно
```
настроил максимально агрессивно, похоже на ненагруженной БД это синоним максимально эффективно

log_autovacuum_min_duration = 0
autovacuum_max_workers = 10
autovacuum_naptime = 15s
autovacuum_vacuum_threshold = 25
autovacuum_vacuum_scale_factor = 0.05
autovacuum_vacuum_cost_delay = 10
autovacuum_vacuum_cost_limit = 1000
```
8. построить график по получившимся значениям так чтобы получить максимально ровное значение tps
```
sudo -u postgres pgbench -c8 -P 60 -T 600 postgres
pgbench (14.7 (Ubuntu 14.7-1.pgdg22.04+1))
starting vacuum...end.
progress: 60.0 s, 389.7 tps, lat 20.519 ms stddev 22.288
progress: 120.0 s, 413.9 tps, lat 19.329 ms stddev 23.423
progress: 180.0 s, 395.6 tps, lat 20.216 ms stddev 21.169
progress: 240.0 s, 394.1 tps, lat 20.298 ms stddev 19.075
progress: 300.0 s, 376.9 tps, lat 21.229 ms stddev 24.310
progress: 360.0 s, 408.4 tps, lat 19.587 ms stddev 19.650
progress: 420.0 s, 360.1 tps, lat 22.220 ms stddev 28.696
progress: 480.0 s, 382.5 tps, lat 20.914 ms stddev 19.554
progress: 540.0 s, 447.3 tps, lat 17.886 ms stddev 17.519
progress: 600.0 s, 369.4 tps, lat 21.652 ms stddev 24.168
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 236281
latency average = 20.314 ms
latency stddev = 22.100 ms
initial connection time = 15.245 ms
tps = 393.780945 (without initial connection time)

```

