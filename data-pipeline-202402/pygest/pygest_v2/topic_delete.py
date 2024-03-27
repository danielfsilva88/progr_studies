import sys
from kafka.admin import KafkaAdminClient

topic_name = sys.argv[1]

admin_client = KafkaAdminClient(bootstrap_servers=["localhost:9092"])
admin_client.delete_topics(topics=[topic_name])
