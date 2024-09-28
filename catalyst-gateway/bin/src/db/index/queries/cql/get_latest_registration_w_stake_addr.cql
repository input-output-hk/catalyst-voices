SELECT *
FROM   cip36_registration
WHERE  stake_address = :stake_address
ORDER  BY nonce DESC
LIMIT  1;  