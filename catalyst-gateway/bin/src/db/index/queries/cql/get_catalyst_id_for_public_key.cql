SELECT
    catalyst_id,
    slot_no
FROM
    catalyst_id_for_public_key
WHERE
    public_key = :public_key
