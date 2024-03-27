import sys
from kafka.admin import KafkaAdminClient

topic_name = 'volume-topic-v2'

admin_client = KafkaAdminClient(bootstrap_servers=["localhost:9092"])
admin_client.delete_topics(topics=[topic_name])
