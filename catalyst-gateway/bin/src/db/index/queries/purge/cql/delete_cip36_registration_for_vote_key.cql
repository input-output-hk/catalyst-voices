-- Delete CIP-36 registration by Stake Address.
DELETE FROM cip36_registration_for_vote_key
WHERE vote_key = :vote_key
    AND stake_public_key = :stake_public_key
    AND slot_no = :slot_no
    AND txn_index = :txn_index
    AND valid = :valid
