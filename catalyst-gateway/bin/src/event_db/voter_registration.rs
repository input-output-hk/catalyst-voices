//! Voter registration queries

use cardano_chain_follower::Network;

use pallas::ledger::traverse::MultiEraTx;
use tracing::info;

use crate::registration::{parse_registrations_from_metadata, validate_reg_cddl, CddlConfig};

use super::{follower::SlotNumber, Error, EventDB};

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
pub(crate) type MetadataCip36<'a> = &'a [u8];
/// Stats
pub(crate) type _Stats = Option<serde_json::Value>;

impl EventDB {
    /// Inserts voter registration data, replacing any existing data.
    #[allow(dead_code, clippy::too_many_arguments)]
    async fn insert_voter_registration(
        &self, tx_id: TxId, stake_credential: StakeCredential<'_>,
        public_voting_key: PublicVotingKey<'_>, payment_address: PaymentAddress<'_>, nonce: Nonce,
        metadata_cip36: MetadataCip36<'_>, valid: bool,
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
                    &metadata_cip36,
                    &valid,
                ],
            )
            .await?;

        Ok(())
    }

    /// Index registration data
    pub async fn index_registration_data(
        &self, txs: Vec<MultiEraTx<'_>>, _slot_no: SlotNumber, network: Network,
    ) -> Result<(), Error> {
        let cddl = CddlConfig::new();

        for tx in txs {
            let mut _valid_registration = true;

            if !tx.metadata().is_empty() {
                let registration = match parse_registrations_from_metadata(tx.metadata(), network) {
                    Ok(registration) => registration,
                    Err(err) => {
                        info!("err {:?}", err);
                        continue;
                    },
                };

                let reg = registration.clone();
                if let Some(cip36) = registration.0.raw_cbor_cip36 {
                    match validate_reg_cddl(&cip36, &cddl) {
                        Ok(()) => info!("cddl ok reg {:?}", reg.0),
                        Err(_err) => continue,
                    };
                } else {
                    // not a valid registration
                    continue;
                }

                // cddl is valid continue parsing
                /*
                    if let Some(voting_key) = registration.0.voting_key {
                        match voting_key{
                            crate::registration::VotingKey::Direct(direct) => direct,
                            crate::registration::VotingKey::Delegated(delegated) => {
                                delegated.into_iter().find_map(|(a, _b)| Some(a)).unwrap()
                            },
                    }



                    self.insert_voter_registration(
                        tx.hash().to_string(),
                        &registration.stake_key.unwrap().0,
                        &voting_key.0,
                        &registration.rewards_address.unwrap(),
                        registration.nonce.unwrap().try_into().unwrap(),
                        &raw_cbor_cip36,
                        valid_registration,
                    )
                    .await?;
                }*/
            }
        }

        Ok(())
    }
}
