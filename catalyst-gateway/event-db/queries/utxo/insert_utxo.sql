INSERT INTO cardano_utxo
(
  index,
  tx_id,
  value,
  stake_credential,
  asset
)

VALUES ($1, $2, $3, $4, $5)

ON CONFLICT (index, tx_id) DO NOTHING;
