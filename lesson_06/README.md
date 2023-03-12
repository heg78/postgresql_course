# postgresql_course lesson 6
Домашнее задание

 
1. создайте виртуальную машину c Ubuntu 20.04 LTS (bionic) в GCE
2. поставьте на нее PostgreSQL 14 через sudo apt
3. проверьте что кластер запущен через sudo -u postgres pg_lsclusters
4. зайдите из под пользователя postgres в psql и сделайте произвольную таблицу с произвольным содержимым
postgres=# create table test(c1 text);
postgres=# insert into test values('1');
\q
```
postgres=# create table test(c1 text);
CREATE TABLE
postgres=# \d
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | test | table | postgres
(1 row)

postgres=# insert into test values('1');
INSERT 0 1
postgres=# 
```
5. остановите postgres например через sudo -u postgres pg_ctlcluster 14 main stop
```
postgres@8007eb63b219:/$ pg_ctl stop
waiting for server to shut down....user-vm01-yc@vm01-yc:~$ docker exec -it --user postgres pg-server bash
Error response from daemon: Container 8007eb63b21975f4ee6c987470cf0bfdd1303457f028209fe4a69646505a1763 is not running
```
6. создайте новый standard persistent диск GKE через Compute Engine -> Disks в том же регионе и зоне что GCE инстанс размером например 10GB
```

```
7. добавьте свеже-созданный диск к виртуальной машине - надо зайти в режим ее редактирования и дальше выбрать пункт attach existing disk
```
user-vm01-yc@vm01-yc:~$ sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
NAME   FSTYPE     SIZE MOUNTPOINT        LABEL
loop1  squashfs  63.3M /snap/core20/1822 
loop2  squashfs  79.9M /snap/lxd/22923   
loop3  squashfs 111.9M /snap/lxd/24322   
loop4  squashfs  49.8M /snap/snapd/17950 
loop5  squashfs  49.8M /snap/snapd/18357 
loop6  squashfs  63.3M /snap/core20/1828 
vda                15G                   
├─vda1              1M                   
└─vda2 ext4        15G /                 
vdb                20G      
```
8. проинициализируйте диск согласно инструкции и подмонтировать файловую систему, только не забывайте менять имя диска на актуальное, в вашем случае это скорее всего будет /dev/sdb - https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux
```

```
9. перезагрузите инстанс и убедитесь, что диск остается примонтированным (если не так смотрим в сторону fstab)
```
user-vm01-yc@vm01-yc:~$ sudo mkfs.ext4 -L datapartition /dev/vdb1
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 5242368 4k blocks and 1310720 inodes
Filesystem UUID: a16ce425-8919-408d-8a42-3c98506256f0
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done   

user-vm01-yc@vm01-yc:~$ sudo lsblk --fs
NAME   FSTYPE   FSVER LABEL         UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
loop1  squashfs 4.0                                                            0   100% /snap/core20/1822
loop2  squashfs 4.0                                                            0   100% /snap/lxd/22923
loop3  squashfs 4.0                                                            0   100% /snap/lxd/24322
loop4  squashfs 4.0                                                            0   100% /snap/snapd/17950
loop5  squashfs 4.0                                                            0   100% /snap/snapd/18357
loop6  squashfs 4.0                                                            0   100% /snap/core20/1828
vda                                                                                     
├─vda1                                                                                  
└─vda2 ext4     1.0                 82aeea96-6d42-49e6-85d5-9071d3c9b6aa    9.2G    32% /
vdb                                                                                     
└─vdb1 ext4     1.0   datapartition a16ce425-8919-408d-8a42-3c98506256f0     <-новый диск
```
10. сделайте пользователя postgres владельцем /mnt/data - chown -R postgres:postgres /mnt/data/
```
user-vm01-yc@vm01-yc:~$ df -h -x tmpfs
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda2        15G  4.8G  9.3G  35% /
/dev/vdb1        20G   24K   19G   1% /mnt/data

```
11. перенесите содержимое /var/lib/postgres/14 в /mnt/data - mv /var/lib/postgresql/14 /mnt/data
```
user-vm01-yc@vm01-yc:/var/lib$ sudo -u postgres pg_lsclusters
Ver Cluster Port Status Owner    Data directory              Log file
14  main    5432 down   postgres /var/lib/postgresql/14/main /var/log/postgresql/postgresql-14-main.log
user-vm01-yc@vm01-yc:/var/lib$ mv /var/lib/postgresql/14 /mnt/data
mv: cannot create directory '/mnt/data/14': Permission denied
user-vm01-yc@vm01-yc:/var/lib$ sudo mv /var/lib/postgresql/14 /mnt/data
user-vm01-yc@vm01-yc:/var/lib$ 
```
12. попытайтесь запустить кластер - sudo -u postgres pg_ctlcluster 14 main start
```
user-vm01-yc@vm01-yc:~$ sudo -u postgres pg_ctlcluster 14 main start
Error: /var/lib/postgresql/14/main is not accessible or does not exist
```
13. напишите получилось или нет и почему
```
нет файлов с данными
Error: /var/lib/postgresql/14/main is not accessible or does not exist
```
14. задание: найти конфигурационный параметр в файлах раположенных в /etc/postgresql/14/main который надо поменять и поменяйте его
15. напишите что и почему поменяли
```
#data_directory = '/var/lib/postgresql/14/main'         # use data in another directory
data_directory = '/mnt/data/14/main'

```
16. попытайтесь запустить кластер - sudo -u postgres pg_ctlcluster 14 main start
17. напишите получилось или нет и почему
18. зайдите через через psql и проверьте содержимое ранее созданной таблицы
```
user-vm01-yc@vm01-yc:~$ sudo -u postgres psql -p 5432
could not change directory to "/home/user-vm01-yc": Permission denied
psql (14.7 (Ubuntu 14.7-1.pgdg22.04+1))
Type "help" for help.

postgres=# select * from test;
 c1 
----
 1
(1 row)

postgres=# 

```
19. задание со звездочкой *: не удаляя существующий инстанс ВМ сделайте новый, поставьте на его PostgreSQL, удалите файлы с данными из /var/lib/postgres, перемонтируйте внешний диск который сделали ранее от первой виртуальной машины ко второй и запустите PostgreSQL на второй машине так чтобы он работал с данными на внешнем диске, расскажите как вы это сделали и что в итоге получилось.
```

```
