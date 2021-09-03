--- CONECTORES KAFKA
---=================================================
    
---=================================================
CREATE SOURCE CONNECTOR psl_ct WITH(
    'connector.class'='io.confluent.connect.jdbc.JdbcSourceConnector',
    'connection.url'='jdbc:postgresql://postgres:5432/db_kafka_test',
    'connection.user' = 'admin',
    'connection.password' = 'admin',
    'mode'='incrementing',
    'incrementing.column.name' = 'id',
    'topic.prefix'='full_',
    'poll.interval.ms' = '1000',
    'table.whitelist'='finance_info',
    'validate.non.null'= 'false');

---=================================================
CREATE SOURCE CONNECTOR psl_ct_query WITH(
    'connector.class'='io.confluent.connect.jdbc.JdbcSourceConnector',
    'connection.url'='jdbc:postgresql://postgres:5432/db_kafka_test',
    'connection.user' = 'admin',
    'connection.password' = 'admin',
    'mode'='incrementing',
    'incrementing.column.name' = 'id',
    'topic.prefix'='filtered_',
    'poll.interval.ms' = '1000',
    'query' = 'SELECT id, first_name, amount, transaction_date FROM public.finance_info', 
    'validate.non.null'= 'false');
---=================================================

CREATE SINK CONNECTOR SINK_ELASTIC WITH (
  'connector.class'                          = 'io.confluent.connect.elasticsearch.ElasticsearchSinkConnector',
  'connection.url'                           = 'http://elasticsearch:9200',
  'key.converter'                            = 'org.apache.kafka.connect.storage.StringConverter',
  'value.converter'                          = 'io.confluent.connect.avro.AvroConverter',
  'value.converter.schema.registry.url'      = 'http://schema-registry:8081',
  'type.name'                                = '_doc',
  'topics'                                   = 'full_finance_info',
  'key.ignore'                               = 'true',
  'schema.ignore'                            = 'false',
  'transforms'                               = 'setTimestampType0',
  'transforms.setTimestampType0.type'        = 'org.apache.kafka.connect.transforms.TimestampConverter$Value',
  'transforms.setTimestampType0.field'       = 'transaction_date',
  'transforms.setTimestampType0.target.type' = 'Timestamp'
);

---=================================================
CREATE SINK CONNECTOR SINK_S3_PARQUET WITH(
    'connector.class'= 'io.confluent.connect.s3.S3SinkConnector',
		'key.converter'='org.apache.kafka.connect.storage.StringConverter',
		'tasks.max'= '1',
		'topics'= 'full_finance_info',
		's3.region'= 'us-east-1',
		's3.bucket.name'= 'stream-test-kafka-s3-parquet',
		'flush.size'= '100',
		'storage.class'= 'io.confluent.connect.s3.storage.S3Storage',
		'format.class'= 'io.confluent.connect.s3.format.parquet.ParquetFormat',
		'schema.generator.class'= 'io.confluent.connect.storage.hive.schema.DefaultSchemaGenerator',
		'schema.compatibility'= 'NONE',
    'partitioner.class'= 'io.confluent.connect.storage.partitioner.DefaultPartitioner',
    'transforms'= 'AddMetadata',
    'transforms.AddMetadata.type'= 'org.apache.kafka.connect.transforms.InsertField$Value',
    'transforms.AddMetadata.offset.field'= '_offset',
    'transforms.AddMetadata.partition.field'= '_partition'
);
---=================================================
CREATE SINK CONNECTOR SINK_S3_JSON WITH(
  'connector.class'= 'io.confluent.connect.s3.S3SinkConnector',
		'key.converter'='org.apache.kafka.connect.storage.StringConverter',
		'tasks.max'= '1',
		'topics'= 'full_finance_info',
		's3.region'= 'us-east-1',
		's3.bucket.name'= 'stream-test-kafka-s3-json',
		'flush.size'= '100',
		'storage.class'= 'io.confluent.connect.s3.storage.S3Storage',
		'format.class'= 'io.confluent.connect.s3.format.json.JsonFormat',
		'schema.generator.class'= 'io.confluent.connect.storage.hive.schema.DefaultSchemaGenerator',
		'schema.compatibility'= 'NONE',
    'partitioner.class'= 'io.confluent.connect.storage.partitioner.DefaultPartitioner',
    'transforms'= 'AddMetadata',
    'transforms.AddMetadata.type'= 'org.apache.kafka.connect.transforms.InsertField$Value',
    'transforms.AddMetadata.offset.field'= '_offset',
    'transforms.AddMetadata.partition.field'= '_partition'
);
---=================================================