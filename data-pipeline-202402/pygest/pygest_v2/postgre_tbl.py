import psycopg2

# Database connection details
host = "localhost"  
database = "nome_do_db"
user = "seu_user"
password = "sua_senha"

# table creation
sql_tbl_create = """
CREATE TABLE IF NOT EXISTS pygest_v2 (
  id SERIAL PRIMARY KEY,
  kafka_data JSONB NOT NULL,
  kafka_producer_timestamp TIMESTAMP NOT NULL,
  kafka_consumer_timestamp TIMESTAMP NOT NULL,
  ingestion_timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

comment on column pygest_v2.kafka_producer_timestamp is 'Time when data got into Kafka topic';
comment on column pygest_v2.kafka_consumer_timestamp is 'Time when data was read by pygest consumer';
comment on column pygest_v2.ingestion_timestamp is 'Time UTC-3 when data was ingested by DB';
"""

try:
  conn = psycopg2.connect(host=host, database=database, user=user, password=password)
  cur = conn.cursor()
  cur.execute(sql_tbl_create)
  conn.commit()
  print("Table created successfully!")
except (Exception, psycopg2.Error) as error:
  print("Error while creating table:", error)
finally:
  if conn:
    conn.close()

print("End of quickstart.")
