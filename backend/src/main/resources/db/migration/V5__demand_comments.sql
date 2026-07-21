CREATE TABLE demand_comment (
  id UUID PRIMARY KEY,
  demand_id UUID NOT NULL REFERENCES demand(id),
  message TEXT NOT NULL,
  author_name VARCHAR(150) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_demand_comment_timeline ON demand_comment(demand_id, created_at DESC);
