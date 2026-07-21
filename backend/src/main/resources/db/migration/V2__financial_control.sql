CREATE TABLE budget_appropriation (
  id UUID PRIMARY KEY,
  number VARCHAR(80) NOT NULL,
  year SMALLINT NOT NULL,
  agency_id UUID NOT NULL REFERENCES agency(id),
  contract_id UUID NOT NULL REFERENCES contract(id),
  initial_amount NUMERIC(19,2) NOT NULL CHECK (initial_amount >= 0),
  committed_amount NUMERIC(19,2) NOT NULL DEFAULT 0 CHECK (committed_amount >= 0),
  settled_amount NUMERIC(19,2) NOT NULL DEFAULT 0 CHECK (settled_amount >= 0),
  paid_amount NUMERIC(19,2) NOT NULL DEFAULT 0 CHECK (paid_amount >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(number, year, agency_id)
);
CREATE TYPE financial_movement_type AS ENUM ('ALLOCATION', 'REINFORCEMENT', 'COMMITMENT', 'SETTLEMENT', 'PAYMENT', 'REVERSAL');
CREATE TABLE financial_movement (
  id UUID PRIMARY KEY,
  appropriation_id UUID NOT NULL REFERENCES budget_appropriation(id),
  movement_type financial_movement_type NOT NULL,
  amount NUMERIC(19,2) NOT NULL CHECK (amount > 0),
  occurred_on DATE NOT NULL,
  reference_number VARCHAR(100),
  description TEXT NOT NULL,
  created_by VARCHAR(150) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_appropriation_agency ON budget_appropriation(agency_id, year);
CREATE INDEX idx_financial_movement_appropriation ON financial_movement(appropriation_id, occurred_on DESC);
