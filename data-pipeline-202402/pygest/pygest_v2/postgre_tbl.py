import psycopg2

def postgre_ddl_queries(query, root_stmt):
  
  # Database connection details
  host = "localhost"  
  database = "nome_do_db"
  user = "seu_user"
  password = "sua_senha"

  try:
    conn = psycopg2.connect(host=host, database=database, user=user, password=password)
    cur = conn.cursor()
    cur.execute(query)
    conn.commit()
    return_stmt = f"Table {root_stmt}ed successfully!"
  except (Exception, psycopg2.Error) as error:
    return_stmt = f"Error while {root_stmt}ing table: {error}"
  finally:
    if conn:
      conn.close()
  
  return return_stmt


queries_dict = {"drop": "DROP TABLE IF EXISTS pygest_v2;",
                "creat": """
CREATE TABLE IF NOT EXISTS pygest_v2 (
  id SERIAL PRIMARY KEY,
  kafka_data JSONB NOT NULL,
  kafka_producer_timestamp TIMESTAMP NOT NULL,
  kafka_consumer_timestamp TIMESTAMP NOT NULL,
  ingestion_timestamp TIMESTAMP NOT NULL DEFAULT NOW() - interval '3 hour'
);

comment on column pygest_v2.kafka_producer_timestamp is 'Time when data got into Kafka topic';
comment on column pygest_v2.kafka_consumer_timestamp is 'Time when data was read by pygest consumer';
comment on column pygest_v2.ingestion_timestamp is 'Time UTC-3 when data was ingested by DB';
"""
}

for k, v in queries_dict.items():
  return_stmt = postgre_ddl_queries(v, k)
  print(return_stmt)

print("End of postgre config.")
