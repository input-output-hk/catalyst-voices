SELECT problem_report,
       stake_address,
       vote_key,
       payment_address,
       is_payable,
       cip36
FROM   cip36_registration_invalid
WHERE  stake_address = :stake_address
       AND slot_no >= :slot_no