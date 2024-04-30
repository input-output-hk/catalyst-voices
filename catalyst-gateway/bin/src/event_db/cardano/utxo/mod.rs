//! Utxo Queries

use cardano_chain_follower::Network;
use pallas::ledger::{addresses::Address, traverse::MultiEraTx};

use super::{chain_state::SlotNumber, cip36_registration::StakeCredential};
use crate::{
    cardano::util::parse_policy_assets,
    event_db::{error::NotFoundError, EventDB},
};

/// Stake amount.
pub(crate) type StakeAmount = i64;

/// `insert_txn_index.sql`
const INSERT_TXN_INDEX_SQL: &str = include_str!("insert_txn_index.sql");
/// `insert_utxo.sql`
const INSERT_UTXO_SQL: &str = include_str!("insert_utxo.sql");
/// `select_total_utxo_amount.sql`
const SELECT_TOTAL_UTXO_AMOUNT_SQL: &str = include_str!("select_total_utxo_amount.sql");
/// `update_utxo.sql`
const UPDATE_UTXO_SQL: &str = include_str!("update_utxo.sql");

impl EventDB {
    /// Index utxo data
    pub(crate) async fn index_utxo_data(&self, tx: &MultiEraTx<'_>) -> anyhow::Result<()> {
        let conn = self.pool.get().await?;

        let tx_hash = tx.hash();

        // index outputs
        for (index, tx_out) in tx.outputs().iter().enumerate() {
            // extract assets
            let assets = serde_json::to_value(parse_policy_assets(&tx_out.non_ada_assets()))
                .map_err(|e| anyhow::anyhow!(format!("Asset parsing issue {e}")))?;

            let stake_address = match tx_out.address()? {
                Address::Shelley(address) => address.try_into().ok(),
                Address::Stake(stake_address) => Some(stake_address),
                Address::Byron(_) => None,
            };
            let stake_credential = stake_address.map(|val| val.payload().as_hash().to_vec());

            let _rows = conn
                .query(INSERT_UTXO_SQL, &[
                    &i32::try_from(index)?,
                    &tx_hash.as_slice(),
                    &i64::try_from(tx_out.lovelace_amount())?,
                    &stake_credential,
                    &assets,
                ])
                .await?;
        }
        // update outputs with inputs
        for tx_in in tx.inputs() {
            let output = tx_in.output_ref();
            let output_tx_hash = output.hash();
            let out_index = output.index();

            let _rows = conn
                .query(UPDATE_UTXO_SQL, &[
                    &tx_hash.as_slice(),
                    &output_tx_hash.as_slice(),
                    &i32::try_from(out_index)?,
                ])
                .await?;
        }

        Ok(())
    }

    /// Index txn metadata
    pub(crate) async fn index_txn_data(
        &self, tx_id: &[u8], slot_no: SlotNumber, network: Network,
    ) -> anyhow::Result<()> {
        let conn = self.pool.get().await?;

        let _rows = conn
            .query(INSERT_TXN_INDEX_SQL, &[
                &tx_id,
                &slot_no,
                &network.to_string(),
            ])
            .await?;

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
