import psycopg2

# Database connection details
host = "localhost"  
database = "nome_do_db"
user = "seu_user"
password = "sua_senha"

# table creation
sql_tbl_create = """
CREATE TABLE IF NOT EXISTS pygest_v1 (
  id SERIAL PRIMARY KEY,
  data JSONB NOT NULL,
  ingestion_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);"""

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
