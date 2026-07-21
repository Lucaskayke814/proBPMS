CREATE TABLE contract (
  id UUID PRIMARY KEY,
  number VARCHAR(60) NOT NULL,
  year SMALLINT NOT NULL,
  object_description TEXT NOT NULL,
  supplier_name VARCHAR(200) NOT NULL,
  total_amount NUMERIC(19,2) NOT NULL CHECK (total_amount >= 0),
  starts_on DATE NOT NULL,
  ends_on DATE NOT NULL,
  status VARCHAR(30) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(number, year)
);
CREATE TABLE agency (
  id UUID PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  acronym VARCHAR(30) NOT NULL UNIQUE,
  contact_name VARCHAR(150),
  contact_email VARCHAR(254),
  phone VARCHAR(30),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE demand (
  id UUID PRIMARY KEY,
  code VARCHAR(30) NOT NULL UNIQUE,
  title VARCHAR(250) NOT NULL,
  description TEXT NOT NULL,
  demand_type VARCHAR(40) NOT NULL,
  priority VARCHAR(20) NOT NULL,
  status VARCHAR(40) NOT NULL,
  agency_id UUID NOT NULL REFERENCES agency(id),
  contract_id UUID NOT NULL REFERENCES contract(id),
  requester_name VARCHAR(150) NOT NULL,
  due_date DATE,
  estimated_hours NUMERIC(10,2),
  actual_hours NUMERIC(10,2) NOT NULL DEFAULT 0,
  amount_used NUMERIC(19,2) NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE audit_event (
  id UUID PRIMARY KEY,
  entity_type VARCHAR(80) NOT NULL,
  entity_id UUID NOT NULL,
  action VARCHAR(50) NOT NULL,
  actor_name VARCHAR(150) NOT NULL,
  details JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_demand_active_status ON demand(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_demand_agency ON demand(agency_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_audit_entity ON audit_event(entity_type, entity_id, created_at DESC);
