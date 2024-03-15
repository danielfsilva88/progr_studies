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
producer.close()

# Create a Kafka consumer
consumer = KafkaConsumer(topic, bootstrap_servers=bootstrap_servers, auto_offset_reset='earliest')

# Read in a dummy way but being able to exit without error messages
try:
  for msg in consumer:
    if msg:
      print(msg)
    else:
      print("No new messages available.")
except KeyboardInterrupt:
  # Handle user interrupt (Ctrl+C) gracefully
  pass
finally:
  # Close the consumer
  consumer.close()
