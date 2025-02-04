//! Utxo Queries

use pallas::ledger::{addresses::Address, traverse::MultiEraTx};
use tokio_postgres::{binary_copy::BinaryCopyInWriter, types::Type};
use tracing::error;

use crate::{
    cardano::util::parse_policy_assets,
    db::event::{Error, EventDB, EVENT_DB_POOL},
};

/// Stake amount.
pub(crate) type StakeAmount = i64;

/// Data required to index transactions.
pub(crate) struct IndexedTxnParams<'a> {
    /// Transaction id
    pub id: Vec<u8>,
    /// Slot number of the block in which the transaction was included
    pub slot_no: i64,
    /// To which network this transaction belongs to
    pub network: &'a str,
}

/// Data required to index transaction outputs.
pub(crate) struct IndexedTxnOutputParams {
    /// Id.
    pub id: Vec<u8>,
    /// Index.
    pub index: i32,
    /// Assets data JSON.
    pub asset: serde_json::Value,
    /// Stake credential.
    pub stake_credential: Option<Vec<u8>>,
    /// Output value.
    pub value: i64,
}

impl IndexedTxnOutputParams {
    /// Creates transaction indexing data from transaction data.
    pub(crate) fn from_txn_data(tx: &MultiEraTx) -> Vec<IndexedTxnOutputParams> {
        tx.outputs()
            .into_iter()
            .zip(0..)
            .filter_map(|(tx_out, index)| {
                let asset =
                    match serde_json::to_value(parse_policy_assets(&tx_out.non_ada_assets())) {
                        Ok(assets) => assets,
                        Err(e) => {
                            error!(error = ?e, "Failed to parse tx output policy assets");
                            return None;
                        },
                    };

                let stake_address = match tx_out.address() {
                    Ok(Address::Shelley(address)) => address.try_into().ok(),
                    Ok(Address::Stake(stake_address)) => Some(stake_address),
                    Ok(Address::Byron(_)) => None,
                    Err(e) => {
                        error!(error = ?e, "Failed to parse tx output stake address");
                        return None;
                    },
                };
                let stake_credential = stake_address.map(|val| val.payload().as_hash().to_vec());

                let lovelace_amount = match tx_out.lovelace_amount().try_into() {
                    Ok(amount) => amount,
                    Err(e) => {
                        error!(error = ?e, "Failed to parse tx output lovelace amount");
                        return None;
                    },
                };

                Some(IndexedTxnOutputParams {
                    id: tx.hash().to_vec(),
                    index,
                    asset,
                    stake_credential,
                    value: lovelace_amount,
                })
            })
            .collect()
    }
}

/// Data required to index transaction inputs.
pub(crate) struct IndexedTxnInputParams {
    /// Id.
    pub id: Vec<u8>,
    /// Related output hash.
    pub output_hash: Vec<u8>,
    /// Related output index.
    pub output_index: i32,
}

impl IndexedTxnInputParams {
    /// Creates transaction indexing data from transaction data.
    pub(crate) fn from_txn_data(tx: &MultiEraTx) -> Vec<IndexedTxnInputParams> {
        tx.inputs()
            .into_iter()
            .filter_map(|tx_in| {
                let output_index = match tx_in.output_ref().index().try_into() {
                    Ok(index) => index,
                    Err(e) => {
                        error!(error = ?e, "Failed to parse transaction input output ref index");
                        return None;
                    },
                };

                Some(IndexedTxnInputParams {
                    id: tx.hash().to_vec(),
                    output_hash: tx_in.output_ref().hash().to_vec(),
                    output_index,
                })
            })
            .collect()
    }
}

impl EventDB {
    /// Batch writes transaction output indexing data.
    pub(crate) async fn index_many_txn_output_data(
        values: &[IndexedTxnOutputParams],
    ) -> anyhow::Result<()> {
        if values.is_empty() {
            return Ok(());
        }

        let pool = EVENT_DB_POOL.get().ok_or(Error::DbPoolUninitialized)?;
        let mut conn = pool.get().await?;
        let tx = conn.transaction().await?;

        tx.execute(
            "CREATE TEMPORARY TABLE tmp_cardano_utxo (LIKE cardano_utxo) ON COMMIT DROP",
            &[],
        )
        .await?;

        {
            let sink = tx
            .copy_in("COPY tmp_cardano_utxo (tx_id, index, asset, stake_credential, value) FROM STDIN BINARY")
            .await?;
            let writer = BinaryCopyInWriter::new(sink, &[
                Type::BYTEA,
                Type::INT4,
                Type::JSONB,
                Type::BYTEA,
                Type::INT8,
            ]);
            tokio::pin!(writer);

            for params in values {
                #[allow(trivial_casts)]
                writer
                    .as_mut()
                    .write(&[
                        &params.id as &(dyn tokio_postgres::types::ToSql + Sync),
                        &params.index,
                        &params.asset,
                        &params.stake_credential,
                        &params.value,
                    ])
                    .await?;
            }

            writer.finish().await?;
        }

        tx.execute("INSERT INTO cardano_utxo (tx_id, index, asset, stake_credential, value) SELECT tx_id, index, asset, stake_credential, value FROM tmp_cardano_utxo ON CONFLICT (tx_id, index) DO NOTHING", &[]).await?;
        tx.commit().await?;

        Ok(())
    }

    /// Batch writes transaction input indexing data.
    pub(crate) async fn index_many_txn_input_data(
        values: &[IndexedTxnInputParams],
    ) -> anyhow::Result<()> {
        if values.is_empty() {
            return Ok(());
        }

        let pool = EVENT_DB_POOL.get().ok_or(Error::DbPoolUninitialized)?;
        let mut conn = pool.get().await?;
        let tx = conn.transaction().await?;

        tx.execute(
            "CREATE TEMPORARY TABLE tmp_cardano_utxo_update (tx_id BYTEA, output_hash BYTEA, index INTEGER) ON COMMIT DROP",
            &[],
        )
        .await?;

        {
            let sink = tx
                .copy_in(
                    "COPY tmp_cardano_utxo_update (tx_id, output_hash, index) FROM STDIN BINARY",
                )
                .await?;
            let writer = BinaryCopyInWriter::new(sink, &[Type::BYTEA, Type::BYTEA, Type::INT4]);
            tokio::pin!(writer);

            for params in values {
                #[allow(trivial_casts)]
                writer
                    .as_mut()
                    .write(&[
                        &params.id as &(dyn tokio_postgres::types::ToSql + Sync),
                        &params.output_hash,
                        &params.output_index,
                    ])
                    .await?;
            }

            writer.finish().await?;
        }

        tx.execute("UPDATE cardano_utxo AS c SET spent_tx_id = v.tx_id FROM (SELECT * FROM tmp_cardano_utxo_update) AS v WHERE v.index = c.index AND v.output_hash = c.tx_id", &[]).await?;
        tx.commit().await?;

        Ok(())
    }

    /// Batch writes transaction indexing data.
    pub(crate) async fn index_many_txn_data(values: &[IndexedTxnParams<'_>]) -> anyhow::Result<()> {
        if values.is_empty() {
            return Ok(());
        }

        let pool = EVENT_DB_POOL.get().ok_or(Error::DbPoolUninitialized)?;
        let mut conn = pool.get().await?;
        let tx = conn.transaction().await?;

        tx.execute(
            "CREATE TEMPORARY TABLE tmp_cardano_txn_index (LIKE cardano_txn_index) ON COMMIT DROP",
            &[],
        )
        .await?;

        {
            let sink = tx
                .copy_in("COPY tmp_cardano_txn_index (id, slot_no, network) FROM STDIN BINARY")
                .await?;
            let writer = BinaryCopyInWriter::new(sink, &[Type::BYTEA, Type::INT8, Type::TEXT]);
            tokio::pin!(writer);

            for params in values {
                #[allow(trivial_casts)]
                writer
                    .as_mut()
                    .write(&[
                        &params.id as &(dyn tokio_postgres::types::ToSql + Sync),
                        &params.slot_no,
                        &params.network,
                    ])
                    .await?;
            }

            writer.finish().await?;
        }

        tx.execute("INSERT INTO cardano_txn_index (id, slot_no, network) SELECT id, slot_no, network FROM tmp_cardano_txn_index ON CONFLICT (id) DO NOTHING", &[]).await?;
        tx.commit().await?;

        Ok(())
    }
}

