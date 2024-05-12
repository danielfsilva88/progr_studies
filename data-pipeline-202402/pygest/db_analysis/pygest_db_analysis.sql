
-- understand timestamps
show timezone;
select * from pg_timezone_names where name like 'America/S%'
SELECT '2018-09-02 07:09:19'::timestamp AT TIME ZONE 'America/Sao_Paulo';
select current_timestamp, now();

-- check table
-- DROP TABLE public.pygest_v2;
TRUNCATE TABLE pygest_v2 RESTART IDENTITY;
select count(*) from pygest_v2;
select * from pygest_v2 limit 3;
select * from emp_table limit 3;

-- CREATE TABLE pygest_v2_bkp_kafka_poll_only_1k_batch AS SELECT * FROM pygest_v2; -- 8s to produce, 7m19s to consume
-- CREATE TABLE pygest_v2_bkp_kafka_poll_only_10k_batch AS SELECT * FROM pygest_v2; -- 7s to produce, 5m40s to consume
-- CREATE TABLE pygest_v2_bkp_kafka_poll_only_50k_batch AS SELECT * FROM pygest_v2; -- 7s to produce, 4m30s to consume
-- CREATE TABLE pygest_v2_bkp_kafka_poll_only_100k_batch AS SELECT * FROM pygest_v2; -- 8s to produce, 4m26s to consume

-- table analysis

select kafka_producer_timestamp, count(*), 
sum(count(*)) over () as total
from pygest_v2
group by kafka_producer_timestamp
order by kafka_producer_timestamp;

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