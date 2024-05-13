from kafka import KafkaConsumer
import psycopg2, time, json, sqlalchemy, logging
import pandas as pd

logger = logging.getLogger("sqlalchemy.engine")
logger.setLevel(logging.DEBUG)
handler = logging.FileHandler("./pygest/log/log_pd_tosql_engine_DEBUG.txt")
logger.addHandler(handler)

host="localhost"; database="nome_do_db"; user="seu_user"; password="sua_senha"
engine = sqlalchemy.create_engine(f'postgresql://{user}:{password}@{host}:5432/{database}')

# kafka consumer configs

def format_kafka_time(long_timestamp):
  return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(long_timestamp/1000))

topic_name = "volume-topic-v4"
batch_size = 100000
poll_timeout = 1000
consumer = KafkaConsumer(topic_name, bootstrap_servers=["localhost:9092"], auto_offset_reset='earliest',
  group_id='group_volume-topic-v4', value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

switch_state = True; i=0; idle_counter = 0; list_of_offsets = {}
# Continuously poll for messages
try:
  while switch_state:
    # Get a batch of messages
    messages = consumer.poll(timeout_ms=poll_timeout, max_records=batch_size)
    # Check if there are any messages
    if messages:
      print(f"Find msg_batch! Batch size: {len(list(messages.values())[0])}")
      # Process the batch of messages
      df = pd.DataFrame(data=list(messages.values())[0])
      df = df[['value', 'timestamp']]
      df['timestamp'] = df['timestamp'].apply(lambda r: format_kafka_time(r))
      df.rename(columns={'value': 'kafka_data', 'timestamp': 'kafka_producer_timestamp'}, inplace=True)
      df['kafka_consumer_timestamp'] = time.strftime("%Y-%m-%d %H:%M:%S")
      df.to_sql('pygest_v2', engine, if_exists="append", 
                dtype={"kafka_data": sqlalchemy.types.JSON, "kafka_producer_timestamp": sqlalchemy.types.TIMESTAMP, 
                       "kafka_consumer_timestamp": sqlalchemy.types.TIMESTAMP}, index=False)
      
    else:
      # No messages received in this poll
      print("No messages received in this batch.")
      idle_counter += 1
    # Commit offsets periodically (optional)
    consumer.commit()
    if idle_counter == 12: switch_state = False
except KeyboardInterrupt:
  # Exit cleanly on interrupt
  consumer.close()
  print("Consumer stopped!")
except (Exception, psycopg2.Error) as error:
  print("Error while inserting data:", error)
finally:
  consumer.close()

