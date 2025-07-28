-- DATA MIGRATION for `signed_docs` from v0.03 to v0.04,
-- Restructure `metadata` by removing legacy keys and rebuilding them into normalized arrays,
-- filtering out entries with null `id` and `ver` to exclude invalid references.

UPDATE public.signed_docs
SET
  metadata = (
    metadata
    - 'brand_id'
    - 'category_id'
    - 'campaign_id'
    - 'parameters'
    - 'template'
    - 'ref'
    - 'reply'
  ) || JSONB_BUILD_OBJECT(
    'parameters', JSONB_PATH_QUERY_ARRAY(
      JSONB_BUILD_ARRAY(
        JSONB_BUILD_OBJECT(
          'id', metadata -> 'brand_id' ->> 'id',
          'ver', metadata -> 'brand_id' ->> 'ver',
          'cid', '0x'
        ),
        JSONB_BUILD_OBJECT(
          'id', metadata -> 'category_id' ->> 'id',
          'ver', metadata -> 'category_id' ->> 'ver',
          'cid', '0x'
        ),
        JSONB_BUILD_OBJECT(
          'id', metadata -> 'campaign_id' ->> 'id',
          'ver', metadata -> 'campaign_id' ->> 'ver',
          'cid', '0x'
        ),
        JSONB_BUILD_OBJECT(
          'id', metadata -> 'parameters' ->> 'id',
          'ver', metadata -> 'parameters' ->> 'ver',
          'cid', '0x'
        )
      ),
      '$[*] ? (@.id != null || @.ver != null)'
    ),
    'template', JSONB_PATH_QUERY_ARRAY(
      JSONB_BUILD_ARRAY(
        JSONB_BUILD_OBJECT(
          'id', metadata -> 'template' ->> 'id',
          'ver', metadata -> 'template' ->> 'ver',
          'cid', '0x'
        )
      ),
      '$[*] ? (@.id != null || @.ver != null)'
    ),
    'ref', JSONB_PATH_QUERY_ARRAY(
      JSONB_BUILD_ARRAY(
        JSONB_BUILD_OBJECT(
          'id', metadata -> 'ref' ->> 'id',
          'ver', metadata -> 'ref' ->> 'ver',
          'cid', '0x'
        )
      ),
      '$[*] ? (@.id != null || @.ver != null)'
    ),
    'reply', JSONB_PATH_QUERY_ARRAY(
      JSONB_BUILD_ARRAY(
        JSONB_BUILD_OBJECT(
          'id', metadata -> 'reply' ->> 'id',
          'ver', metadata -> 'reply' ->> 'ver',
          'cid', '0x'
        )
      ),
      '$[*] ? (@.id != null || @.ver != null)'
    )
  )
WHERE metadata IS NOT NULL;
