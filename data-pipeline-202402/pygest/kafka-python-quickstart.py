from kafka import KafkaProducer, KafkaConsumer
import time, json

# Kafka broker(s) address
bootstrap_servers = 'localhost:9092'

# Create a Kafka producer
#producer = KafkaProducer(bootstrap_servers=bootstrap_servers)
producer = KafkaProducer(bootstrap_servers=bootstrap_servers,
                         value_serializer=lambda m: json.dumps(m).encode('utf-8')
                         )

# Produce messages to a topic
topic = 'quickstart-topic'

for i in range(2):
  #message = f'Message {i}'
  #producer.send(topic, message.encode('utf-8'))
  message = {"msg_id": i, "msg": f"Message {i}", "msg_timestamp": time.strftime("%Y-%m-%d %H:%M:%S")}
  producer.send(topic, message)
  print(f"Produced: {message}")

# Flush the producer to ensure all messages are sent
producer.flush()

# Create a Kafka consumer
consumer = KafkaConsumer(topic, bootstrap_servers=bootstrap_servers, auto_offset_reset='earliest')

# Consume messages from the topic
for message in consumer:
  if message.value:
    print(f"Consumed: {message.value.decode('utf-8')}")
    break
  else:
    print("No new messages available.")

# Close the consumer and producer
consumer.close()
producer.close()

