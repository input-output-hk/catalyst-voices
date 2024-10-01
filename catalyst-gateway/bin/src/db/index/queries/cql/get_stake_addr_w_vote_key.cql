SELECT stake_address
FROM   cip36_registration_for_vote_key
WHERE  vote_key = :vote_key
ALLOW FILTERING;
