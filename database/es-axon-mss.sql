-- Events
CREATE TABLE IF NOT EXISTS ms_schema.domain_event_entry (
  global_index       BIGSERIAL PRIMARY KEY,
  event_identifier   VARCHAR(255)   NOT NULL,
  aggregate_identifier VARCHAR(255) NOT NULL,
  sequence_number    BIGINT         NOT NULL,
  type               VARCHAR(255)   NOT NULL,
  time_stamp         VARCHAR(255)   NOT NULL,  -- ISO-8601 text
  payload_type       VARCHAR(255)   NOT NULL,
  payload_revision   VARCHAR(255),
  payload            BYTEA          NOT NULL,
  meta_data          BYTEA,
  CONSTRAINT uq_aggregate_seq UNIQUE (aggregate_identifier, sequence_number)
);
CREATE INDEX IF NOT EXISTS idx_event_identifier ON domain_event_entry(event_identifier);
CREATE INDEX IF NOT EXISTS idx_agg_seq ON domain_event_entry(aggregate_identifier, sequence_number);


ALTER TABLE ms_schema.domain_event_entry OWNER TO msadm;

-- Snapshots
CREATE TABLE IF NOT EXISTS ms_schema.snapshot_event_entry (
  sequence_number      BIGINT         NOT NULL,
  aggregate_identifier VARCHAR(255)   NOT NULL,
  type                 VARCHAR(255)   NOT NULL,
  event_identifier     VARCHAR(255)   NOT NULL,
  time_stamp           VARCHAR(255)   NOT NULL,
  payload_type         VARCHAR(255)   NOT NULL,
  payload_revision     VARCHAR(255),
  payload              BYTEA          NOT NULL,
  meta_data            BYTEA,
  PRIMARY KEY (aggregate_identifier, sequence_number)
);

ALTER TABLE ms_schema.snapshot_event_entry OWNER TO msadm;

-- Tracking tokens for projections/sagas
CREATE TABLE IF NOT EXISTS ms_schema.token_entry (
  processor_name VARCHAR(255) NOT NULL,
  segment        INT          NOT NULL,
  token          BYTEA,
  token_type     VARCHAR(255),
  timestamp      VARCHAR(255),
  owner          VARCHAR(255),
  PRIMARY KEY (processor_name, segment)
);

ALTER TABLE ms_schema.token_entry OWNER TO msadm;

-- Optional if you use Sagas
CREATE TABLE IF NOT EXISTS ms_schema.saga_entry (
  saga_id            VARCHAR(255) PRIMARY KEY,
  revision           VARCHAR(255),
  saga_type          VARCHAR(255),
  serialized_saga    BYTEA
);

ALTER TABLE ms_schema.saga_entry OWNER TO msadm;

CREATE TABLE IF NOT EXISTS ms_schema.association_value_entry (
  id                 BIGSERIAL PRIMARY KEY,
  saga_id            VARCHAR(255) NOT NULL,
  association_key    VARCHAR(255) NOT NULL,
  association_value  VARCHAR(255) NOT NULL,
  saga_type          VARCHAR(255)
);

ALTER TABLE ms_schema.association_value_entry OWNER TO msadm;
