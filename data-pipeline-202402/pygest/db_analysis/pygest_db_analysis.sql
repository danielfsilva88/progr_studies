
-- understand timestamps
show timezone;
select * from pg_timezone_names where name like 'America/S%'
SELECT '2018-09-02 07:09:19'::timestamp AT TIME ZONE 'America/Sao_Paulo';
select current_timestamp, now();
SELECT * FROM pg_stat_activity;


-- check table
-- DROP TABLE public.pygest_v2;
TRUNCATE TABLE pygest_v2 RESTART IDENTITY;
select count(*) from pygest_v2;
select * from pygest_v2 limit 3;
select * from emp_table limit 3;

-- with thread went to 526.3157894736842105

-- CREATE TABLE pygest_v2_bkp_kafka_poll_only_1k_batch AS SELECT * FROM pygest_v2; -- 8s to produce, 7m19s to consume
-- CREATE TABLE pygest_v2_bkp_kafka_poll_only_10k_batch AS SELECT * FROM pygest_v2; -- 7s to produce, 5m40s to consume
-- CREATE TABLE pygest_v2_bkp_kafka_poll_only_50k_batch AS SELECT * FROM pygest_v2; -- 7s to produce, 4m30s to consume
-- CREATE TABLE pygest_v2_bkp_kafka_poll_only_100k_batch AS SELECT * FROM pygest_v2; -- 8s to produce, 4m26s to consume
-- CREATE TABLE pygest_v2_bkp_kafkapoll_dbpool_4pythread_100k_batch AS SELECT * FROM pygest_v2; -- 8s to produce, 3m05s to consume
-- CREATE TABLE pygest_v2_bkp_kafkapoll_dbpool_8pythread_100k_batch AS SELECT * FROM pygest_v2; -- 8s to produce, 3m16s to consume
-- CREATE TABLE pygest_v2_bkp_kafkapoll_pandas_100k_batch AS SELECT * FROM pygest_v2; -- 8s to produce, 8s to consume - 00:00:08     11111.111111111111 - pandas insert
-- 1 Mi records using pandas - 1m18s to produce, 1m18s to consume - CPU reached 100% after 3s until the end

-- table analysis

select kafka_producer_timestamp, count(*), 
sum(count(*)) over () as total
from pygest_v2
group by kafka_producer_timestamp
order by kafka_producer_timestamp;

select kafka_consumer_timestamp, count(*),
sum(count(*)) over () as total
from pygest_v2
group by kafka_consumer_timestamp
order by kafka_consumer_timestamp;

select kafka_consumer_timestamp, count(*)
from pygest_v2
group by kafka_consumer_timestamp
order by kafka_consumer_timestamp;


select to_char(ingestion_timestamp,'YYYY-MM-DD HH24:MI:SS') as ingestion_timestamp, count(*)
from pygest_v2
group by to_char(ingestion_timestamp,'YYYY-MM-DD HH24:MI:SS')
order by to_char(ingestion_timestamp,'YYYY-MM-DD HH24:MI:SS');

select kafka_consumer_timestamp, to_char(ingestion_timestamp,'YYYY-MM-DD HH24:MI:SS') ingestion_timestamp, count(*)
from pygest_v2
group by kafka_consumer_timestamp, to_char(ingestion_timestamp,'YYYY-MM-DD HH24:MI:SS')
order by kafka_consumer_timestamp, to_char(ingestion_timestamp,'YYYY-MM-DD HH24:MI:SS');

select 
to_char(kafka_producer_timestamp,'YYYY-MM-DD HH24:MI') kafka_producer_timestamp,
to_char(kafka_consumer_timestamp,'YYYY-MM-DD HH24:MI') kafka_consumer_timestamp,
to_char(ingestion_timestamp,'YYYY-MM-DD HH24:MI') ingestion_timestamp, count(*),
sum(count(*)) over () as total
from pygest_v2
group by to_char(kafka_producer_timestamp,'YYYY-MM-DD HH24:MI'),
to_char(kafka_consumer_timestamp,'YYYY-MM-DD HH24:MI'), 
to_char(ingestion_timestamp,'YYYY-MM-DD HH24:MI')
order by 1, 2, 3;

-- 00:04:20     383.1417624521072797 - for loop single thread
-- 00:04:31     367.6470588235294118 - map single thread

-- 537.6344086021505376 - 4 threads 
-- 507.6142131979695431 - 8 threads

-- 00:00:08     11111.111111111111 - pandas insert
-- 1 Mi records - 00:01:18      12658.227848101266 - pandas insert
-- 1 Mi records - 00:01:14      13333.333333333333 - pandas insert
select min(kct), max(kct), MAX(kct)-MIN(kct) timediff,
avg(n) avg_n_pool from (
select kafka_consumer_timestamp as kct, count(*) n
from pygest_v2
group by kafka_consumer_timestamp
order by kafka_consumer_timestamp);

-- 293.2551319648093842
select avg(n) avg_n_10k from (
select kafka_consumer_timestamp, count(*) n
from pygest_v2_bkp_kafka_poll_only_10k_batch
group by kafka_consumer_timestamp
order by kafka_consumer_timestamp);

-- 369.0036900369003690
select avg(n) avg_n_50k from (
select kafka_consumer_timestamp, count(*) n
from pygest_v2_bkp_kafka_poll_only_50k_batch
group by kafka_consumer_timestamp
order by kafka_consumer_timestamp);

-- 374.5318352059925094
select avg(n) avg_n_100k from (
select kafka_consumer_timestamp, count(*) n
from pygest_v2_bkp_kafka_poll_only_100k_batch
group by kafka_consumer_timestamp
order by kafka_consumer_timestamp); 