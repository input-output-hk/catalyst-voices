//! Utxo Queries

use cardano_chain_follower::Network;
use pallas::ledger::traverse::MultiEraTx;

use super::follower::SlotNumber;
use crate::{
    event_db::{Error, Error::SqlTypeConversionFailure, EventDB},
    util::parse_policy_assets,
};

impl EventDB {
    /// Index utxo data
    pub async fn index_utxo_data(
        &self, txs: Vec<MultiEraTx<'_>>, slot_no: SlotNumber, network: Network,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        for (index, tx) in txs.iter().enumerate() {
            self.index_txn_data(tx.hash().as_slice(), slot_no, network)
                .await?;

            // index outputs
            for tx_out in tx.outputs() {
                // extract assets
                let assets = serde_json::to_value(parse_policy_assets(&tx_out.non_ada_assets()))
                    .map_err(|e| Error::AssetParsingIssue(format!("Asset parsing issue {e}")))?;

                let _rows = conn
                    .query(
                        include_str!(
                            "../../../event-db/queries/follower/utxo_index_utxo_query.sql"
                        ),
                        &[
                            &i32::try_from(index).map_err(|e| {
                                Error::NotFound(
                                    SqlTypeConversionFailure(format!("Issue converting type {e}"))
                                        .to_string(),
                                )
                            })?,
                            &tx.hash().as_slice(),
                            &i64::try_from(tx_out.lovelace_amount()).map_err(|e| {
                                Error::NotFound(
                                    SqlTypeConversionFailure(format!("Issue converting type {e}"))
                                        .to_string(),
                                )
                            })?,
                            &tx.hash().as_slice(), /* temporary until we have foreign key
                                                    * relationship in the context of
                                                    * registrations */
                            &assets,
                        ],
                    )
                    .await?;
            }
        }

        Ok(())
    }

    /// Index txn metadata
    pub async fn index_txn_data(
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
                include_str!("../../../event-db/queries/follower/utxo_txn_index.sql"),
                &[&tx_id, &slot_no, &network],
            )
            .await?;

        Ok(())
    }
}
