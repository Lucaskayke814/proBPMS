ALTER TABLE contract ADD COLUMN IF NOT EXISTS manager_name VARCHAR(150);
ALTER TABLE contract ADD COLUMN IF NOT EXISTS fiscal_name VARCHAR(150);
ALTER TABLE contract ADD COLUMN IF NOT EXISTS executed_amount NUMERIC(19,2) NOT NULL DEFAULT 0;
ALTER TABLE contract ADD COLUMN IF NOT EXISTS committed_amount NUMERIC(19,2) NOT NULL DEFAULT 0;
ALTER TABLE contract ADD COLUMN IF NOT EXISTS settled_amount NUMERIC(19,2) NOT NULL DEFAULT 0;
ALTER TABLE contract ADD COLUMN IF NOT EXISTS paid_amount NUMERIC(19,2) NOT NULL DEFAULT 0;
ALTER TABLE contract ADD COLUMN IF NOT EXISTS remaining_days INTEGER;
ALTER TABLE contract ADD COLUMN IF NOT EXISTS notes TEXT;

ALTER TABLE agency ADD COLUMN IF NOT EXISTS responsible_name VARCHAR(150);
ALTER TABLE agency ADD COLUMN IF NOT EXISTS responsible_email VARCHAR(254);
ALTER TABLE agency ADD COLUMN IF NOT EXISTS available_amount NUMERIC(19,2) NOT NULL DEFAULT 0;
ALTER TABLE agency ADD COLUMN IF NOT EXISTS consumed_amount NUMERIC(19,2) NOT NULL DEFAULT 0;
ALTER TABLE agency ADD COLUMN IF NOT EXISTS balance_amount NUMERIC(19,2) NOT NULL DEFAULT 0;
ALTER TABLE agency ADD COLUMN IF NOT EXISTS notes TEXT;

CREATE TABLE feature_request (
  id UUID PRIMARY KEY,
  title VARCHAR(250) NOT NULL,
  system_name VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  requester_name VARCHAR(150) NOT NULL,
  agency_id UUID NOT NULL REFERENCES agency(id),
  contract_id UUID NOT NULL REFERENCES contract(id),
  sprint VARCHAR(80),
  version VARCHAR(50),
  status VARCHAR(40) NOT NULL DEFAULT 'NEW',
  estimated_hours NUMERIC(10,2),
  complexity VARCHAR(30),
  documentation TEXT,
  mockups TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE error_report (
  id UUID PRIMARY KEY,
  system_name VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  severity VARCHAR(30) NOT NULL,
  environment VARCHAR(80),
  steps_to_reproduce TEXT,
  print_path VARCHAR(500),
  video_url VARCHAR(500),
  responsible_name VARCHAR(150),
  version VARCHAR(50),
  correction_notes TEXT,
  status VARCHAR(40) NOT NULL DEFAULT 'OPEN',
  resolution_time_hours NUMERIC(10,2),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE api_definition (
  id UUID PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  consumer_system VARCHAR(150),
  provider_system VARCHAR(150),
  endpoint VARCHAR(500) NOT NULL,
  http_method VARCHAR(20) NOT NULL,
  authentication VARCHAR(80),
  environment VARCHAR(40),
  documentation_url VARCHAR(500),
  swagger_url VARCHAR(500),
  status VARCHAR(40) NOT NULL DEFAULT 'ACTIVE',
  version VARCHAR(50),
  responsible_name VARCHAR(150),
  observations TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE publication (
  id UUID PRIMARY KEY,
  system_name VARCHAR(150) NOT NULL,
  version VARCHAR(50) NOT NULL,
  sprint VARCHAR(80),
  description TEXT NOT NULL,
  homologation_date DATE,
  production_date DATE,
  responsible_name VARCHAR(150),
  approver_name VARCHAR(150),
  rollback_plan TEXT,
  checklist TEXT,
  status VARCHAR(40) NOT NULL DEFAULT 'PLANNED',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE new_module (
  id UUID PRIMARY KEY,
  name VARCHAR(250) NOT NULL,
  description TEXT NOT NULL,
  agency_id UUID NOT NULL REFERENCES agency(id),
  objective TEXT,
  scope TEXT,
  expected_value NUMERIC(19,2) NOT NULL DEFAULT 0,
  estimated_hours NUMERIC(10,2),
  schedule_text TEXT,
  status VARCHAR(40) NOT NULL DEFAULT 'PLANNED',
  documents TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE document_record (
  id UUID PRIMARY KEY,
  title VARCHAR(250) NOT NULL,
  document_type VARCHAR(80) NOT NULL,
  source_system VARCHAR(120),
  related_entity_type VARCHAR(80),
  related_entity_id UUID,
  file_name VARCHAR(250),
  storage_key VARCHAR(500),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
