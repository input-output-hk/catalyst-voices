SELECT nonce,
       raw_nonce,
       slot_no,
       txn_index,
       problem_report,
       stake_public_key,
       vote_key,
       payment_address,
       is_payable,
       cip36
FROM   cip36_registration_invalid
WHERE  slot_no <= :slot_no