-- Delete CIP-36 registration by Stake Address.
DELETE FROM cip36_registration_for_vote_key
WHERE vote_key = :vote_key
    AND stake_address = :stake_address
    AND slot_no = :slot_no
    AND txn = :txn
    AND valid = :valid
