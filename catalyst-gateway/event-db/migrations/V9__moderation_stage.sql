-- Catalyst Event Database

-- ModerationAllocation - Defines the relationship between users and proposals_reviews
-- to describe the allocation of moderations that needs to be done.

CREATE TABLE moderation_allocation (
  row_id SERIAL PRIMARY KEY,
  review_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (review_id) REFERENCES proposal_review(row_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES config(row_id) ON DELETE CASCADE
);


COMMENT ON TABLE moderation_allocation IS 'The relationship between users and proposals_reviews.';
COMMENT ON COLUMN moderation_allocation.row_id IS 'Synthetic ID of this relationship.';
COMMENT ON COLUMN moderation_allocation.review_id IS 'The review the relationship is related to.';
COMMENT ON COLUMN moderation_allocation.user_id IS 'The user the relationship is related to.';


-- Moderation - Defines the moderation submitted by users for each proposal_review.

CREATE TABLE moderation (
  row_id SERIAL PRIMARY KEY,
  review_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  classification INTEGER NOT NULL,
  rationale VARCHAR,
  UNIQUE (review_id, user_id),

  FOREIGN KEY (review_id) REFERENCES proposal_review(row_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES config(row_id) ON DELETE CASCADE
);


COMMENT ON TABLE moderation IS 'An individual moderation for a proposal review.';
COMMENT ON COLUMN moderation.row_id IS 'Synthetic ID of this moderation.';
COMMENT ON COLUMN moderation.review_id IS 'The review the moderation is related to.';
COMMENT ON COLUMN moderation.user_id IS 'The user the moderation is submitted from.';
COMMENT ON COLUMN moderation.classification IS 'The value used to describe the moderation (e.g. 0: excluded, 1: included).';
COMMENT ON COLUMN moderation.rationale IS 'The rationale for the given classification.';