SELECT error_report,
       stake_address,
       vote_key
FROM   cip36_registration_invalid
WHERE  stake_address = :stake_address
       AND slot_no >= :slot_no  