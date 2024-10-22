-- Catalyst Voices Database - Proposal Information
-- sqlfluff:dialect:postgres

-- Title : Proposal Data

-- Proposal Tables

-- -------------------------------------------------------------------------------------------------

-- Proposal Template defintion.
CREATE TABLE IF NOT EXISTS proposal_template (
  id UUID NOT NULL PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  name TEXT NOT NULL UNIQUE,
  template JSONB
);

COMMENT ON TABLE proposal_template IS
'Defintion of a Proposal Template.';

COMMENT ON COLUMN proposal_template.id IS
'Synthetic Unique ID for the proposal template (UUIDv4).';
COMMENT ON COLUMN proposal_template.name IS
'The UNIQUE name for the proposal template.';
COMMENT ON COLUMN proposal_template.template IS
'The JSON Schema which must match the data contained in the proposal.';

-- -------------------------------------------------------------------------------------------------

-- Proposal defintion.
CREATE TABLE IF NOT EXISTS proposal (
  id UUID NOT NULL PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  template_id UUID NOT NULL,

  CONSTRAINT fk_proposal_template FOREIGN KEY (template_id) REFERENCES proposal_template (id)
);

COMMENT ON TABLE proposal IS
'An individual Proposal.';

COMMENT ON COLUMN proposal.id IS
'The Synthetic Unique ID for the proposal (UUIDv4).';
COMMENT ON COLUMN proposal.template_id IS
'The Template this proposal conforms to.';
