-- Catalyst Voices Database - Signed Documents Repository
-- sqlfluff:dialect:postgres

-- Title : Signed Documents Repository

-- Signed Documents Repository Tables

-- -------------------------------------------------------------------------------------------------

-- Category defintion.
CREATE TABLE IF NOT EXISTS signed_docs (
  id UUID NOT NULL, -- Actually a ULID
  ver UUID NOT NULL, -- Actually a ULID
  type UUID NOT NULL, -- Yes its a UUID this time
  author TEXT NOT NULL,
  metadata JSONB NOT NULL,
  payload JSONB NULL,
  raw BLOB NOT NULL,

  CONSTRAINT pk PRIMARY KEY (id, ver)
);

COMMENT ON TABLE signed_docs IS
'Storage for Signed Documents.';

COMMENT ON COLUMN signed_docs.id IS
'The Signed Documents Document ID (ULID).';
COMMENT ON COLUMN signed_docs.ver IS
'The Signed Documents Document Version Number (ULID).';
COMMENT ON COLUMN signed_docs.type IS
'The Signed Document type identifier.';
COMMENT ON COLUMN signed_docs.author IS
'The Primary Author of the Signed Document.';
COMMENT ON COLUMN category.metadata IS
'Extra metadata extracted from the Signed Document, and encoded as JSON.';
COMMENT ON COLUMN category.payload IS
'IF the document has a compressed json payload, the uncompressed json payload is stored here.';
COMMENT ON COLUMN category.raw IS
'The RAW unaltered signed document, including its signatures, and full COSE envelope.';

CREATE INDEX IF NOT EXISTS idx_signed_docs_type ON signed_docs (type);
COMMENT ON INDEX signed_docs_type IS
'Index to help finding documents by a known type faster.';

CREATE INDEX IF NOT EXISTS idx_signed_docs_author ON signed_docs (author);
COMMENT ON INDEX signed_docs_author IS
'Index to help finding documents by a known author faster.';

CREATE INDEX IF NOT EXISTS idx_signed_docs_type_author ON signed_docs (type, author);
COMMENT ON INDEX signed_docs_type_author IS
'Index to help finding documents by a known author for a specific document type faster.';


CREATE INDEX IF NOT EXISTS idx_signed_docs_metadata ON signed_docs USING gin (metadata);
COMMENT ON INDEX idx_signed_docs_metadata IS
'Index to help search metadata attached to the signed documents.';

CREATE INDEX IF NOT EXISTS idx_signed_docs_payload ON signed_docs USING gin (payload);
COMMENT ON INDEX idx_signed_docs_payload IS
'Index to help search payload data contained in a signed documents.';
