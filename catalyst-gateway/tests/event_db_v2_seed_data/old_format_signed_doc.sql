INSERT INTO signed_docs (
  id,
  ver,
  type,
  authors,
  metadata,
  payload,
  raw
)
VALUES (
  gen_random_uuid(),  -- UUID v7 preferred, substitute if needed
  gen_random_uuid(),  -- UUID v7 preferred, substitute if needed
  uuid_generate_v4(), -- UUID v4 for 'type'
  ARRAY['Alice', 'Bob', 'Charlie'],
  '{"title": "Sample Document", "created_at": "2025-07-25T12:34:56Z"}',
  '{"content": "This is the content of the document.", "signed": true}',
  decode('DEADBEEFCAFEBABE', 'hex')  -- raw binary data
);