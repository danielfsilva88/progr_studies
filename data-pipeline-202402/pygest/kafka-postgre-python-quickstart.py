from kafka import KafkaConsumer
import psycopg2


def insert_into_postgres(data):
  """Inserts data into a PostgreSQL table."""

  try:
    # Connect to PostgreSQL database
    conn = psycopg2.connect(host="localhost", database="nome_do_db", user="seu_user", password="sua_senha")
    cur = conn.cursor()

    # Assuming data is a dictionary, extract relevant keys for your table columns
    # Modify this section based on your actual data structure and table schema
    message = data["msg"]  # Example: assuming "message" key exists in data
    created_at = data.get("created_at")  # Example: using get() for optional "created_at" key

    # Insert data into the table (replace table_name and column names)
    sql = """INSERT INTO pygest_v1 (kafka_data, kafka_timestamp) VALUES (%s, %s)"""
    cur.execute(sql, (message, created_at))

    # Commit the changes
    conn.commit()
    print("Data inserted successfully!")
  except (Exception, psycopg2.Error) as error:
    print("Error while inserting data:", error)
  finally:
    if conn:
      conn.close()


def consume_and_insert():
  """Consumes messages from Kafka and inserts them into PostgreSQL."""
  # Replace with your Kafka broker details
  consumer = KafkaConsumer("quickstart-topic", bootstrap_servers=["localhost:9092"])

  for msg in consumer:
    # Deserialize the message (if necessary)
    # data = msg.value.decode("utf-8")  # Assuming JSON messages
    # You might need to use a JSON decoder library for more complex data formats
    data = {"msg": msg.value, "timestp": msg.timestamp}
    # Insert the data into PostgreSQL
    insert_into_postgres(data)

  # Close the consumer
  consumer.close()


if __name__ == "__main__":
  consume_and_insert()
