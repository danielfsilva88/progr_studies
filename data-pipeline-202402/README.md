# Data pipeline studies

## First project - data ingestor

1. Using a docker Kafka image, test Kafka functionalities
  a. Kafka parameters: lag, offset
  b. Kafka volume: how many messages can read at once
  c. Anything else that worth to take notes
2. Create a Python structure to Produce and Consume messages from Kafka
  a. Create an isolate environment
  b. Test kafka-python lib
  c. Consume messages and do not persist them
3. Ingest consumed data into a Postgree DB
  a. Create all the necessary structure in DB: db, schema, table(s)
  b. Connect Python to DB
  c. Connect data ingested by Consumer (2.c) into DB

### Configuring environment

#### Docker  

1. Use docker compose file in this folder (compose-zoo-kafka-postg.yaml) to set a zoo-keeper, a kafka, and a Postgree DB  
2. To enable this environment, use the command: $ docker compose -f compose-zoo-kafka-postg.yaml up -d  
3. To access the "kafka terminal", use the command: $ docker exec -it kafka bash  
4. To disable this environment, use the command: $ docker compose -f compose-zoo-kafka-postg.yaml down  

#### Local environment  

5. To have one of the simplest python virtual environment managers (venv), one should execute in local Linux: $ sudo apt-get install python3-venv -y   
6. To have the Python database connector library to PostgreSQL (psycopg2) installed, without install Postgre itself locally, one can execute in local Linux: $ sudo apt-get install libpq-dev gcc -y  

### External references

1. Kafka quickstart: https://kafka.apache.org/quickstart
  a. Find kafka executable files in Linux system:  
    i. $ find / -name "kafka*.sh"  
  b. Topic:   
    i. Create topic: kafka-topics.sh --create --topic "<topic-name>" --bootstrap-server \<server:port\>  
    ii. Describe topic: kafka-topics.sh --describe --topic "<topic-name>" --bootstrap-server \<server:port\>  
  c. Events:  
    i. Write events: kafka-console-producer.sh --topic "<topic-name>" --bootstrap-server \<server:port\>  
      1. A terminal will be open  
      2. You can write any text, the message will be sent when hit "Enter"  
      3. You can exit from the screen hitting Ctrl+c  
    ii. Read events: kafka-console-consumer.sh --topic "<topic-name>" --from-beginning --bootstrap-server \<server:port\>  
2. Kafka-python library page: https://pypi.org/project/kafka-python/  
3. Postgre-python connector library page: https://pypi.org/project/psycopg2/  
  a. Psycopg2 documentation page: https://www.psycopg.org/docs/  

