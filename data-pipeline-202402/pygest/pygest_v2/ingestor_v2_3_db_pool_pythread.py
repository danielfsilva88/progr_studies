from kafka import KafkaConsumer
import psycopg2, time
from psycopg2 import pool
from multiprocessing.dummy import Pool as ThreadPool

def format_kafka_time(long_timestamp):
  return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(long_timestamp/1000))

# kafka consumer configs
batch_size = 100000
poll_timeout = 1000
topic_name = "volume-topic-v2"
consumer = KafkaConsumer(topic_name, bootstrap_servers=["localhost:9092"], auto_offset_reset='earliest',
  group_id='group_v2_2', consumer_timeout_ms=1000
)

host = "localhost"; db = "nome_do_db"; usr = "seu_user"; pw = "sua_senha"
db_pool = psycopg2.pool.ThreadedConnectionPool(1, 10, user=usr, password=pw, host='localhost', port='5432', database=db)
conn_pool = db_pool.getconn() 
cursor = conn_pool.cursor() 
py_pool = ThreadPool(8)

# Use pool connection to execute a query 
def write_msg_into_db(msg):
  sql = """INSERT INTO pygest_v2 (kafka_data, kafka_producer_timestamp, kafka_consumer_timestamp) VALUES (%s, %s, %s)"""
  cursor.execute( sql, ( msg.value.decode("utf-8"), format_kafka_time(msg.timestamp), time.strftime("%Y-%m-%d %H:%M:%S") ) )
  conn_pool.commit()
  return msg.offset
  
# parameters used in consumption loop
def consume_msgs():
  switch_state = True; i=0; idle_counter = 0; list_of_offsets = {}
  try:
    while switch_state:
      # Get a batch of messages
      msg_batch = consumer.poll(timeout_ms=poll_timeout, max_records=batch_size)
      # Check if there are any messages
      if msg_batch:
        print("Find record!")
        list_of_offsets[i] = list(py_pool.map(write_msg_into_db, list(msg_batch.values())[0]))
        i+=1
      else:
        # No messages received in this poll
        print("No messages received in this batch.")
        idle_counter += 1
      # Commit offsets periodically (optional)
      consumer.commit()
      if idle_counter == 12: 
        switch_state = False
  except KeyboardInterrupt:
    # Exit cleanly on interrupt
    consumer.close()
    print("Consumer stopped!")
  except (Exception, psycopg2.Error) as error:
    print("Error while inserting data:", error)
  finally:
    consumer.close()
    py_pool.close()
    py_pool.join()
    db_pool.closeall()
  for n in list_of_offsets:
    print(n, len(list_of_offsets[n]))


consume_msgs()