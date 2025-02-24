SELECT problem_report,
       stake_public_key,
       vote_key,
       payment_address,
       is_payable,
       cip36
FROM   cip36_registration_invalid
WHERE  stake_public_key = :stake_public_key
       AND slot_no >= :slot_no