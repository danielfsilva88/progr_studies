from kafka import KafkaProducer
import time, json, sys

# get from terminal num of messages to produce
# without compression took 1m30s to produce 1 Mi msgs
# num_of_messages = int(sys.argv[1])
num_of_messages = 10

# Kafka broker(s) address
bootstrap_servers = ['localhost:9092']

# Create a Kafka producer
producer = KafkaProducer(bootstrap_servers=bootstrap_servers,
                         value_serializer=lambda m: json.dumps(m).encode('utf-8'),
                         compression_type='gzip'
                         )

# Produce messages to a topic
topic = 'volume-topic-v2'

for i in range(num_of_messages):
  message = {"msg_id": i, "msg": f"Message {i}", "msg_timestamp": time.strftime("%Y-%m-%d %H:%M:%S")}
  producer.send(topic, message)
  if i % 100000 == 0:
    print(f"{i} - Produced: {message}")

# Flush the producer to ensure all messages are sent
producer.flush()
producer.close()
