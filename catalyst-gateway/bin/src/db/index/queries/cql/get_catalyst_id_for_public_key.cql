SELECT
    catalyst_id
FROM
    catalyst_id_for_public_key
WHERE
    public_key = :public_key
