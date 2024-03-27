
-- understand timestamps
show timezone;
select * from pg_timezone_names where name like 'America/S%'
SELECT '2018-09-02 07:09:19'::timestamp AT TIME ZONE 'America/Sao_Paulo';
select current_timestamp, now();

-- check table
-- DROP TABLE public.pygest_v2;
select * from pygest_v2 limit 3;


-- table analysis

select kafka_producer_timestamp, count(*), sum(count(*)) over () as total
from pygest_v2
group by kafka_producer_timestamp
order by kafka_producer_timestamp;

select kafka_consumer_timestamp, count(*)
from pygest_v2
group by kafka_consumer_timestamp
order by kafka_consumer_timestamp;

select to_char(ingestion_timestamp,'YYYY-MM-DD HH:MM:SS') as ingestion_timestamp, count(*)
from pygest_v2
group by to_char(ingestion_timestamp,'YYYY-MM-DD HH:MM:SS')
order by to_char(ingestion_timestamp,'YYYY-MM-DD HH:MM:SS');

select kafka_consumer_timestamp, to_char(ingestion_timestamp,'YYYY-MM-DD HH:MM:SS') ingestion_timestamp, count(*)
from pygest_v2
group by kafka_consumer_timestamp, to_char(ingestion_timestamp,'YYYY-MM-DD HH:MM:SS')
order by kafka_consumer_timestamp, to_char(ingestion_timestamp,'YYYY-MM-DD HH:MM:SS');

select kafka_producer_timestamp, kafka_consumer_timestamp, 
to_char(ingestion_timestamp,'YYYY-MM-DD HH:MM:SS') ingestion_timestamp, count(*),
sum(count(*)) over () as total
from pygest_v2
group by kafka_producer_timestamp, kafka_consumer_timestamp, to_char(ingestion_timestamp,'YYYY-MM-DD HH:MM:SS')
order by kafka_producer_timestamp, kafka_consumer_timestamp, to_char(ingestion_timestamp,'YYYY-MM-DD HH:MM:SS');