SELECT stake_public_key
FROM   stake_registration
WHERE  stake_key_hash = :stake_key_hash;