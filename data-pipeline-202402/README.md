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
