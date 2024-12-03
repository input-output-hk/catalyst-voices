-- Catalyst Voices Database - Category Information
-- sqlfluff:dialect:postgres

-- Title : Category Data

-- Category Tables

-- -------------------------------------------------------------------------------------------------

-- Category defintion.
CREATE TABLE IF NOT EXISTS category (
  id UUID NOT NULL PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  event_id UUID NOT NULL,
  name TEXT NOT NULL,
  proposal_template UUID NOT NULL,

  CONSTRAINT fk_event FOREIGN KEY (event_id) REFERENCES event (id) ON DELETE CASCADE,
  CONSTRAINT fk_proposal_template FOREIGN KEY (proposal_template) REFERENCES proposal_template (id)
);

COMMENT ON TABLE category IS
'Defintion of a Category.';

COMMENT ON COLUMN category.id IS
'Synthetic Unique ID for the category (UUIDv4).';
COMMENT ON COLUMN category.event_id IS
'Synthetic ID for the event this category belongs to (UUIDv4).';
COMMENT ON COLUMN category.name IS
'The name for the category.';
COMMENT ON COLUMN category.proposal_template IS
'The template all proposals in this category must use.';

-- -------------------------------------------------------------------------------------------------

-- Proposals submitted to a Category.
CREATE TABLE IF NOT EXISTS category_proposals (
  id UUID NOT NULL PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
  category_id UUID NOT NULL,
  proposal_id UUID NOT NULL,

  CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category (id) ON DELETE CASCADE,
  CONSTRAINT fk_proposal_id FOREIGN KEY (proposal_id) REFERENCES proposal (id) ON DELETE CASCADE
);

COMMENT ON TABLE category_proposals IS
'Proposals that are submitted into the linked category.';

COMMENT ON COLUMN category.id IS
'Synthetic ID for the category (UUIDv4) the proposal is linked to.';
COMMENT ON COLUMN category.event_id IS
'Synthetic ID for the proposal (UUIDv4) being submitted to the category.';
