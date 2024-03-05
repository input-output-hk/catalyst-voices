//! Utxo Queries

use crate::event_db::Error::SqlTypeConversionFailure;
use crate::event_db::{Error, EventDB};
use async_trait::async_trait;
use cardano_chain_follower::Network;
use pallas::ledger::traverse::MultiEraTx;

use super::follower::SlotNumber;

#[async_trait]
#[allow(clippy::module_name_repetitions)]
/// Utxo Queries Trait
pub(crate) trait UtxoQueries: Sync + Send + 'static {
    async fn index_utxo_data(
        &self, tx_id: Vec<MultiEraTx<'_>>, slot_no: SlotNumber, network: Network,
    ) -> Result<(), Error>;
    async fn index_txn_data(
        &self, tx_id: &[u8], slot_no: SlotNumber, network: Network,
    ) -> Result<(), Error>;
}

impl EventDB {
    /// The ID of the transaction containing the UTXO.
    const INDEX_UTXO_QUERY: &'static str =
        "INSERT INTO cardano_utxo(index, tx_id, value, stake_credential) VALUES($1, $2, $3, $4) ON CONFLICT (index, tx_id) DO NOTHING";
    /// Index of all transactions in the cardano network. It allows us to quickly find a transaction by its id, and its slot number.
    const INDEX_TX: &'static str =
        "INSERT INTO cardano_txn_index(id, slot_no, network) VALUES($1, $2, $3) ON CONFLICT(id) DO NOTHING";
}

#[async_trait]
impl UtxoQueries for EventDB {
    /// Index utxo data
    async fn index_utxo_data(
        &self, txs: Vec<MultiEraTx<'_>>, slot_no: SlotNumber, network: Network,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        for (index, tx) in txs.iter().enumerate() {
            self.index_txn_data(&tx.hash().as_slice(), slot_no, network)
                .await?;

            // index outputs
            for tx_out in tx.outputs() {
                let _rows = conn
                    .query(
                        Self::INDEX_UTXO_QUERY,
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
                            &tx.hash().as_slice(), // temporary until we have foreign key relationship in the context of registrations
                        ],
                    )
                    .await?;
            }
        }

        Ok(())
    }

    /// Index txn metadata
    async fn index_txn_data(
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
            .query(Self::INDEX_TX, &[&tx_id, &slot_no, &network])
            .await?;

        Ok(())
    }
}
