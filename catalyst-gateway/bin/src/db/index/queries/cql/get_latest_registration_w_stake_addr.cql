SELECT stake_address,
       nonce,
       slot_no,
       txn,
       vote_key,
       payment_address,
       is_payable,
       raw_nonce,
       cip36
FROM   cip36_registration
WHERE  stake_address = :stake_address
ORDER  BY nonce DESC
LIMIT  1;  