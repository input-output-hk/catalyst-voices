//! Utxo Queries

use cardano_chain_follower::Network;
use pallas::ledger::{addresses::Address, traverse::MultiEraTx};
use tracing::error;

use super::{chain_state::SlotNumber, cip36_registration::StakeCredential};
use crate::{
    cardano::util::parse_policy_assets,
    event_db::{error::NotFoundError, utils::prepare_sql_params_list, EventDB},
};

/// Stake amount.
pub(crate) type StakeAmount = i64;

/// `select_total_utxo_amount.sql`
const SELECT_TOTAL_UTXO_AMOUNT_SQL: &str = include_str!("select_total_utxo_amount.sql");

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
        &self, values: &[IndexedTxnOutputParams],
    ) -> anyhow::Result<()> {
        if values.is_empty() {
            return Ok(());
        }

        let conn = self.pool.get().await?;

        // Queries are divided into chunks because
        // Postgres has a limit of i16::MAX parameters a query can have.
        let chunk_size = (i16::MAX / 5) as usize;
        for chunk in values.chunks(chunk_size) {
            let values_strings = prepare_sql_params_list(5, chunk.len());

            let query = format!(
                "INSERT INTO cardano_utxo (tx_id, index, asset, stake_credential, value) VALUES {} ON CONFLICT (index, tx_id) DO NOTHING",
                values_strings.join(",")
            );

            #[allow(trivial_casts)]
            let params: Vec<_> = chunk
                .iter()
                .flat_map(|vs| {
                    [
                        &vs.id as &(dyn tokio_postgres::types::ToSql + Sync),
                        &vs.index,
                        &vs.asset,
                        &vs.stake_credential,
                        &vs.value,
                    ]
                })
                .collect();

            conn.execute(&query, &params).await?;
        }

        Ok(())
    }

    /// Batch writes transaction input indexing data.
    pub(crate) async fn index_many_txn_input_data(
        &self, values: &[IndexedTxnInputParams],
    ) -> anyhow::Result<()> {
        if values.is_empty() {
            return Ok(());
        }

        let conn = self.pool.get().await?;

        // Queries are divided into chunks because
        // Postgres has a limit of i16::MAX parameters a query can have.
        let chunk_size = (i16::MAX / 3) as usize;
        for chunk in values.chunks(chunk_size) {
            let values_strings = prepare_sql_params_list(3, chunk.len());

            let query = format!(
                "UPDATE cardano_utxo AS c SET spent_tx_id = v.tx_id FROM (VALUES {}) AS v(tx_id, output_hash, index) WHERE v.index = c.index AND v.output_hash = c.tx_id",
                values_strings.join(",")
            );

            #[allow(trivial_casts)]
            let params: Vec<_> = chunk
                .iter()
                .flat_map(|vs| {
                    [
                        &vs.id as &(dyn tokio_postgres::types::ToSql + Sync),
                        &vs.output_hash,
                        &vs.output_index,
                    ]
                })
                .collect();

            conn.execute(&query, &params).await?;
        }

        Ok(())
    }

    /// Batch writes transaction indexing data.
    pub(crate) async fn index_many_txn_data(
        &self, values: &[IndexedTxnParams<'_>],
    ) -> anyhow::Result<()> {
        if values.is_empty() {
            return Ok(());
        }

        let conn = self.pool.get().await?;

        // Queries are divided into chunks because
        // Postgres has a limit of i16::MAX parameters a query can have.
        let chunk_size = (i16::MAX / 3) as usize;
        for chunk in values.chunks(chunk_size) {
            // Build query VALUES statements
            let values_strings = prepare_sql_params_list(3, chunk.len());

            let query = format!(
                "INSERT INTO cardano_txn_index (id, slot_no, network) VALUES {} ON CONFLICT (id) DO NOTHING",
                values_strings.join(",")
            );

            #[allow(trivial_casts)]
            let params: Vec<_> = chunk
                .iter()
                .flat_map(|vs| {
                    [
                        &vs.id as &(dyn tokio_postgres::types::ToSql + Sync),
                        &vs.slot_no,
                        &vs.network,
                    ]
                })
                .collect();

            conn.execute(&query, &params).await?;
        }

        Ok(())
    }

    /// Get total utxo amount
    pub(crate) async fn total_utxo_amount(
        &self, stake_credential: StakeCredential, network: Network, slot_num: SlotNumber,
    ) -> anyhow::Result<(StakeAmount, SlotNumber)> {
        let conn = self.pool.get().await?;

        let row = conn
            .query_one(SELECT_TOTAL_UTXO_AMOUNT_SQL, &[
                &stake_credential,
                &network.to_string(),
                &slot_num,
            ])
            .await?;

        // Aggregate functions as SUM and MAX return NULL if there are no rows, so we need to
        // check for it.
        // https://www.postgresql.org/docs/8.2/functions-aggregate.html
        if let Some(amount) = row.try_get("total_utxo_amount")? {
            let slot_number = row.try_get("slot_no")?;

            Ok((amount, slot_number))
        } else {
            Err(NotFoundError.into())
        }
    }
}
