from kafka import KafkaConsumer
import psycopg2, time

def format_kafka_time(long_timestamp):
  return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(long_timestamp/1000))

conn = psycopg2.connect(host="localhost", database="nome_do_db", user="seu_user", password="sua_senha")
cur = conn.cursor()
sql = """INSERT INTO pygest_v1 (kafka_data, kafka_timestamp) VALUES (%s, %s)"""

consumer = KafkaConsumer("volume-topic-v1", bootstrap_servers=["localhost:9092"], auto_offset_reset='earliest')
try:
  i = 0
  for msg in consumer:
    cur.execute( sql, ( msg.value.decode("utf-8"), format_kafka_time(msg.timestamp) ) )
    conn.commit()
    i+=1
    if i % 10 == 0:
      print(f"{i} - Data inserted successfully!")
except KeyboardInterrupt:
  pass
except (Exception, psycopg2.Error) as error:
  print("Error while inserting data:", error)
finally:
  consumer.close()
  if conn:
    conn.close()

