from kafka import KafkaProducer
import time, json

# Kafka broker(s) address
bootstrap_servers = ['localhost:9092']

# Create a Kafka producer
producer = KafkaProducer(bootstrap_servers=bootstrap_servers,
                         value_serializer=lambda m: json.dumps(m).encode('utf-8')
                         )

# Produce messages to a topic
topic = 'volume-topic-v1'

for i in range(100):
  message = {"msg_id": i, "msg": f"Message {i}", "msg_timestamp": time.strftime("%Y-%m-%d %H:%M:%S")}
  producer.send(topic, message)
  if i % 10 == 0:
    print(f"{i} - Produced: {message}")

# Flush the producer to ensure all messages are sent
producer.flush()
producer.close()
