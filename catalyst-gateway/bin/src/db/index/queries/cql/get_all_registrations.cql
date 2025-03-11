SELECT stake_public_key,
       nonce,
       slot_no,
       txn_index,
       raw_nonce,
       vote_key,
       payment_address,
       is_payable,
       cip36
FROM   cip36_registration
WHERE  slot_no <= :slot_no