SELECT nonce,
       slot_no,
       txn_index,
       vote_key,
       payment_address,
       is_payable,
       cip36
FROM   cip36_registration
WHERE  stake_public_key = :stake_public_key