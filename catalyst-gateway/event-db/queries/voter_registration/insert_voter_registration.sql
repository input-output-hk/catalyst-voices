INSERT INTO cardano_voter_registration
(
  tx_id,
  stake_credential,
  public_voting_key,
  payment_address,
  nonce,
  metadata_61284,
  metadata_61285,
  valid
)

VALUES ($1, $2, $3, $4, $5, $6, $7, $8)

ON CONFLICT (tx_id) DO UPDATE SET
stake_credential = $2,
public_voting_key = $3,
payment_address = $4,
nonce = $5,
metadata_61284 = $6,
metadata_61285 = $7,
valid = $8
