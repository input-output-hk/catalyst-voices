-- DATA MIGRATION for `signed_docs` from v0.03 to v0.04,
-- Restructure `metadata` by removing legacy keys and rebuilding them into normalized arrays,
-- filtering out entries with null `id` and `ver` to exclude invalid references.

UPDATE public.signed_docs
SET metadata = (
    metadata
    - 'brand_id'
    - 'category_id'
    - 'campaign_id'
    - 'template'
    - 'ref'
    - 'reply'
) || jsonb_build_object(
    'parameters', jsonb_path_query_array(
        jsonb_build_array(
            jsonb_build_object(
                'id', metadata->'brand_id'->>'id',
                'ver', metadata->'brand_id'->>'ver',
                'cid', '0x'
            ),
            jsonb_build_object(
                'id', metadata->'category_id'->>'id',
                'ver', metadata->'category_id'->>'ver',
                'cid', '0x'
            ),
            jsonb_build_object(
                'id', metadata->'campaign_id'->>'id',
                'ver', metadata->'campaign_id'->>'ver',
                'cid', '0x'
            )
        ),
        '$[*] ? (@.id != null || @.ver != null)'
    ),
    'template', jsonb_path_query_array(
        jsonb_build_array(
            jsonb_build_object(
                'id', metadata->'template'->>'id',
                'ver', metadata->'template'->>'ver',
                'cid', '0x'
            )
        ),
        '$[*] ? (@.id != null || @.ver != null)'
    ),
    'ref', jsonb_path_query_array(
        jsonb_build_array(
            jsonb_build_object(
                'id', metadata->'ref'->>'id',
                'ver', metadata->'ref'->>'ver',
                'cid', '0x'
            )
        ),
        '$[*] ? (@.id != null || @.ver != null)'
    ),
    'reply', jsonb_path_query_array(
        jsonb_build_array(
            jsonb_build_object(
                'id', metadata->'reply'->>'id',
                'ver', metadata->'reply'->>'ver',
                'cid', '0x'
            )
        ),
        '$[*] ? (@.id != null || @.ver != null)'
    )
)
WHERE metadata IS NOT NULL;