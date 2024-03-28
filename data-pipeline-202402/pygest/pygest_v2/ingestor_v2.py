from kafka import KafkaConsumer
import psycopg2, time

def format_kafka_time(long_timestamp):
  return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(long_timestamp/1000))

conn = psycopg2.connect(host="localhost", database="nome_do_db", user="seu_user", password="sua_senha")
cur = conn.cursor()
sql = """INSERT INTO pygest_v2 (kafka_data, kafka_producer_timestamp, kafka_consumer_timestamp) VALUES (%s, %s, %s)"""


# kafka consumer configs
topic_name = "volume-topic-v2"
batch_size = 500
poll_timeout = 500
consumer = KafkaConsumer(
  topic_name, 
  bootstrap_servers=["localhost:9092"], 
  auto_offset_reset='earliest',
  group_id='consumer_group_test'
  )

# try:
#   i = 0
#   for msg in consumer:
#     cur.execute( sql, ( msg.value.decode("utf-8"), format_kafka_time(msg.timestamp), time.strftime("%Y-%m-%d %H:%M:%S") ) )
#     conn.commit()
#     i+=1
#     if i % 50000 == 0:
#       print(f"{i} - Data inserted successfully!")
# except KeyboardInterrupt:
#   print("Consumer listener interrupted.")
#   pass
# except (Exception, psycopg2.Error) as error:
#   print("Error while inserting data:", error)
# finally:
#   consumer.close()
#   if conn:
#     conn.close()

# Continuously poll for messages
try:
  i=0
  while True:
    # Get a batch of messages
    messages = consumer.poll(timeout_ms=poll_timeout, max_records=batch_size)
    # Check if there are any messages
    if messages:
      # Process the batch of messages
      for msg in messages:
        cur.execute( sql, ( msg.value.decode("utf-8"), format_kafka_time(msg.timestamp), time.strftime("%Y-%m-%d %H:%M:%S") ) )
        conn.commit()
        i+=1
        if i % 50000 == 0:
          print(f"{i} - Data inserted successfully!")
    else:
      # No messages received in this poll
      print("No messages received in this batch.")

    # Commit offsets periodically (optional)
    consumer.commit()

except KeyboardInterrupt:
  # Exit cleanly on interrupt
  consumer.close()
  print("Consumer stopped!")
except (Exception, psycopg2.Error) as error:
  print("Error while inserting data:", error)
finally:
  consumer.close()
  if conn:
    conn.close()
