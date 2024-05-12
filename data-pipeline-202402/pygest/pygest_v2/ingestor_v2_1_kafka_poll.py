from kafka import KafkaConsumer
from kafka.structs import TopicPartition
import psycopg2, time

def format_kafka_time(long_timestamp):
  return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(long_timestamp/1000))


conn = psycopg2.connect(host="localhost", database="nome_do_db", user="seu_user", password="sua_senha")
cur = conn.cursor()

def write_msg_into_db(msg):
  sql = """INSERT INTO pygest_v2 (kafka_data, kafka_producer_timestamp, kafka_consumer_timestamp) VALUES (%s, %s, %s)"""
  cur.execute( sql, ( msg.value.decode("utf-8"), format_kafka_time(msg.timestamp), time.strftime("%Y-%m-%d %H:%M:%S") ) )
  conn.commit()
  return msg.offset

# def write_msg_into_db(msg):
#   db_conn = psycopg2.connect(host="localhost", database="nome_do_db", user="seu_user", password="sua_senha")
#   db_cursor = db_conn.cursor()
#   sql = """INSERT INTO pygest_v2 (kafka_data, kafka_producer_timestamp, kafka_consumer_timestamp) VALUES (%s, %s, %s)"""
#   db_cursor.execute( sql, ( msg.value.decode("utf-8"), format_kafka_time(msg.timestamp), time.strftime("%Y-%m-%d %H:%M:%S") ) )
#   db_conn.commit()
#   print(f"msg offset {msg.offset} ok")
#   db_cursor.close()
#   db_conn.close()
#   return None

# map(write_msg_into_db(msg), list(record.values())[0])



# kafka consumer configs
batch_size = 100000
poll_timeout = 1000
topic_name = "volume-topic-v2"
consumer = KafkaConsumer(
  topic_name,
  bootstrap_servers=["localhost:9092"], 
  auto_offset_reset='earliest',
  group_id='group_v2_1',
  consumer_timeout_ms=1000
)
mypartition=TopicPartition(topic_name, 0)
# consumer.assign([mypartition])
# consumer.seek_to_beginning(mypartition)
# print(consumer.position(mypartition))
# Continuously poll for messages
switch_state = True
i=0
idle_counter = 0
list_of_offsets = {}
try:
  while switch_state:
    # Get a batch of messages
    record = consumer.poll(timeout_ms=poll_timeout, max_records=batch_size)
    # Check if there are any messages
    if record:
      # Process the batch of messages straight from ConsumerRecord list
      # for msg in list(record.values())[0]:
      #   write_msg_into_db(conn, cur, msg)
      #   if i % 50000 == 0:
      #     print(msg.value.decode("utf-8"), format_kafka_time(msg.timestamp), time.strftime("%Y-%m-%d %H:%M:%S"))
      #     print(f"{i} - Data inserted successfully!")
      #   i+=1
      print("Find record!")
      list_of_offsets[i] = list(map(write_msg_into_db, list(record.values())[0]))
      i+=1
    else:
      # No messages received in this poll
      print("No messages received in this batch.")
      idle_counter += 1

    # Commit offsets periodically (optional)
    consumer.commit()
    if idle_counter == 23: 
      # break;
      switch_state = False

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

for n in list_of_offsets:
  print(n, len(list_of_offsets[n]))