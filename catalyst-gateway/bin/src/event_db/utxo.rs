//! Utxo Queries

use cardano_chain_follower::Network;
use pallas::ledger::{addresses::Address, traverse::MultiEraTx};

use super::{follower::SlotNumber, voter_registration::StakeCredential};
use crate::{
    event_db::{Error, EventDB},
    util::parse_policy_assets,
};

/// Stake amount.
pub(crate) type StakeAmount = i64;

impl EventDB {
    /// Index utxo data
    pub(crate) async fn index_utxo_data(
        &self, txs: Vec<MultiEraTx<'_>>, slot_no: SlotNumber, network: Network,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        for tx in txs {
            let tx_hash = tx.hash();
            self.index_txn_data(tx_hash.as_slice(), slot_no, network)
                .await?;

            // index outputs
            for (index, tx_out) in tx.outputs().iter().enumerate() {
                // extract assets
                let assets = serde_json::to_value(parse_policy_assets(&tx_out.non_ada_assets()))
                    .map_err(|e| Error::AssetParsingIssue(format!("Asset parsing issue {e}")))?;

                let stake_address = match tx_out
                    .address()
                    .map_err(|e| Error::Unknown(format!("Address issue {e}")))?
                {
                    Address::Shelley(address) => address.try_into().ok(),
                    Address::Stake(stake_address) => Some(stake_address),
                    Address::Byron(_) => None,
                };
                let stake_credential = stake_address.map(|val| val.payload().as_hash().to_vec());

                let _rows = conn
                    .query(
                        include_str!("../../../event-db/queries/utxo/insert_utxo.sql"),
                        &[
                            &i32::try_from(index).map_err(|e| Error::Unknown(e.to_string()))?,
                            &tx_hash.as_slice(),
                            &i64::try_from(tx_out.lovelace_amount())
                                .map_err(|e| Error::Unknown(e.to_string()))?,
                            &stake_credential,
                            &assets,
                        ],
                    )
                    .await?;
            }
            // update outputs with inputs
            for tx_in in tx.inputs() {
                let output = tx_in.output_ref();
                let output_tx_hash = output.hash();
                let out_index = output.index();

                let _rows = conn
                    .query(
                        include_str!("../../../event-db/queries/utxo/update_utxo.sql"),
                        &[
                            &tx_hash.as_slice(),
                            &output_tx_hash.as_slice(),
                            &i32::try_from(out_index).map_err(|e| Error::Unknown(e.to_string()))?,
                        ],
                    )
                    .await?;
            }
        }

        Ok(())
    }

    /// Index txn metadata
    pub(crate) async fn index_txn_data(
        &self, tx_id: &[u8], slot_no: SlotNumber, network: Network,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        let network = match network {
            Network::Mainnet => "mainnet".to_string(),
            Network::Preview => "preview".to_string(),
            Network::Preprod => "preprod".to_string(),
            Network::Testnet => "testnet".to_string(),
        };

        let _rows = conn
            .query(
                include_str!("../../../event-db/queries/utxo/insert_txn_index.sql"),
                &[&tx_id, &slot_no, &network],
            )
            .await?;

        Ok(())
    }

    /// Get total utxo amount
    pub(crate) async fn total_utxo_amount(
        &self, stake_credential: StakeCredential<'_>, network: Network, slot_num: SlotNumber,
    ) -> Result<(StakeAmount, SlotNumber), Error> {
        let conn = self.pool.get().await?;

        let network = match network {
            Network::Mainnet => "mainnet".to_string(),
            Network::Preview => "preview".to_string(),
            Network::Preprod => "preprod".to_string(),
            Network::Testnet => "testnet".to_string(),
        };

        let row = conn
            .query_one(
                include_str!("../../../event-db/queries/utxo/select_total_utxo_amount.sql"),
                &[&stake_credential, &network, &slot_num],
            )
            .await?;

        // Aggregate functions as SUM and MAX return NULL if there are no rows, so we need to
        // check for it.
        // https://www.postgresql.org/docs/8.2/functions-aggregate.html
        if let Some(amount) = row.try_get("total_utxo_amount")? {
            let slot_number = row.try_get("slot_no")?;

            Ok((amount, slot_number))
        } else {
            Err(Error::NotFound)
        }
    }
}
