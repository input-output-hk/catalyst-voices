SELECT
    SUM(cardano_txo.value)
FROM cardano_txo
INNER JOIN cardano_transactions
ON cardano_transactions.hash = cardano_txo.transaction_hash
INNER JOIN cardano_blocks
ON cardano_blocks.block_no = cardano_transactions.block_no
LEFT JOIN cardano_spent_txo
ON cardano_txo.transaction_hash = cardano_spent_txo.from_transaction_hash
AND cardano_txo.index = cardano_spent_txo.index
LEFT JOIN cardano_transactions spent_txo_txs
ON spent_txo_txs.hash = cardano_spent_txo.to_transaction_hash
LEFT JOIN cardano_blocks spent_txo_txs_blocks
ON spent_txo_txs_blocks.block_no = spent_txo_txs.block_no
WHERE
    cardano_txo.stake_credential = '\x59938af7640bd602f5b5ed6da219f63d48a39b6f55fda093ea0df062' AND
    (cardano_spent_txo.to_transaction_hash IS NULL OR spent_txo_txs_blocks.slot_no > 56364174) AND
    cardano_transactions.network_id = 1 AND
    cardano_blocks.slot_no <= 56364174
