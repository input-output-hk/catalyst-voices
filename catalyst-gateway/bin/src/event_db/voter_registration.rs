//! Voter registration queries

use pallas::ledger::{primitives::Fragment, traverse::MultiEraTx};
use tracing::info;

use crate::cddl::{validate_reg_cddl, CddlConfig};

use super::{Error, EventDB};

/// Transaction id
pub(crate) type TxId = String;
/// Stake credential
pub(crate) type StakeCredential<'a> = &'a [u8];
/// Public voting key
pub(crate) type PublicVotingKey<'a> = &'a [u8];
/// Payment address
pub(crate) type PaymentAddress<'a> = &'a [u8];
/// Nonce
pub(crate) type Nonce = i64;
/// Metadata 61284
pub(crate) type Metadata61284<'a> = &'a [u8];
/// Metadata 61285
pub(crate) type Metadata61285<'a> = &'a [u8];
/// Stats
pub(crate) type _Stats = Option<serde_json::Value>;

impl EventDB {
    /// Inserts voter registration data, replacing any existing data.
    #[allow(dead_code, clippy::too_many_arguments)]
    async fn insert_voter_registration(
        &self, tx_id: TxId, stake_credential: StakeCredential<'_>,
        public_voting_key: PublicVotingKey<'_>, payment_address: PaymentAddress<'_>, nonce: Nonce,
        metadata_61284: Metadata61284<'_>, metadata_61285: Metadata61285<'_>, valid: bool,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        let _rows = conn
            .query(
                include_str!(
                    "../../../event-db/queries/voter_registration/insert_voter_registration.sql"
                ),
                &[
                    &hex::decode(tx_id).map_err(|e| Error::DecodeHex(e.to_string()))?,
                    &stake_credential,
                    &public_voting_key,
                    &payment_address,
                    &nonce,
                    &metadata_61284,
                    &metadata_61285,
                    &valid,
                ],
            )
            .await?;

        Ok(())
    }

    /// Index registration data
    pub async fn index_registration_data(&self, txs: &[MultiEraTx<'_>]) -> Result<(), Error> {
        let cddl = CddlConfig::new();

        for tx in txs {
            if !tx.metadata().is_empty() {
                match tx.metadata() {
                    pallas::ledger::traverse::MultiEraMeta::AlonzoCompatible(meta) => {
                        let cip36 = meta.iter().find_map(|(key, _cip36_registration)| {
                            if *key == u64::try_from(61284).unwrap()
                                || *key == u64::try_from(61285).unwrap()
                            {
                                info!(
                                    "raw tx {:?}",
                                    hex::encode(
                                        &tx.metadata()
                                            .as_alonzo()
                                            .unwrap()
                                            .encode_fragment()
                                            .unwrap()
                                    )
                                );
                                let cip36_raw_cbor =
                                    match tx.metadata().as_alonzo().unwrap().encode_fragment() {
                                        Ok(alonzo) => alonzo,
                                        Err(_) => return None,
                                    };

                                Some(cip36_raw_cbor)
                            } else {
                                None
                            }
                        });

                        if let Some(cip36) = cip36 {
                            match validate_reg_cddl(&cip36, &cddl) {
                                Ok(()) => info!("Registration is good"),
                                Err(err) => info!("err {:?}", err),
                            }
                        }
                    },
                    _ => todo!(),
                }
            }
        }

        Ok(())
    }
}
