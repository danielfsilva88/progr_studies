from kafka import KafkaProducer, KafkaConsumer
import time

# Kafka broker(s) address
bootstrap_servers = 'localhost:9092'

# Create a Kafka producer
producer = KafkaProducer(bootstrap_servers=bootstrap_servers)

# Produce messages to a topic
topic = 'quickstart-topic'

for i in range(10):
    message = f'Message {i}'
    producer.send(topic, message.encode('utf-8'))
    print(f"Produced: {message}")
    time.sleep(1)

# Flush the producer to ensure all messages are sent
producer.flush()

# Create a Kafka consumer
consumer = KafkaConsumer(topic, bootstrap_servers=bootstrap_servers, auto_offset_reset='earliest')

# Consume messages from the topic
for message in consumer:
    print(f"Consumed: {message.value.decode('utf-8')}")

# Close the consumer and producer
consumer.close()
producer.close()

