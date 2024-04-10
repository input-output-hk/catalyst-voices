//! Voter registration queries

use cardano_chain_follower::Network;
use pallas::ledger::traverse::MultiEraTx;
use serde_json::{json, Value};

use super::{follower::SlotNumber, Error, EventDB};
use crate::registration::{
    parse_registrations_from_metadata, validate_reg_cddl, CddlConfig, Nonce as NonceReg,
};

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

/// `insert_voter_registration.sql`
const INSERT_VOTER_REGISTRATION_SQL: &str = include_str!("insert_voter_registration.sql");
/// `select_voter_registration.sql`
const SELECT_VOTER_REGISTRATION_SQL: &str = include_str!("select_voter_registration.sql");

impl EventDB {
    /// Inserts voter registration data, replacing any existing data.
    #[allow(clippy::too_many_arguments)]
    async fn insert_voter_registration(
        &self, tx_id: TxId, stake_credential: StakeCredential<'_>,
        public_voting_key: PublicVotingKey<'_>, payment_address: PaymentAddress<'_>,
        metadata_cip36: MetadataCip36<'_>, nonce: Nonce, report: Value, valid: bool,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        let _rows = conn
            .query(INSERT_VOTER_REGISTRATION_SQL, &[
                &hex::decode(tx_id).map_err(|e| Error::DecodeHex(e.to_string()))?,
                &stake_credential,
                &public_voting_key,
                &payment_address,
                &nonce,
                &metadata_cip36,
                &report,
                &valid,
            ])
            .await?;

        Ok(())
    }

    /// Index registration data
    pub(crate) async fn index_registration_data(
        &self, txs: Vec<MultiEraTx<'_>>, slot_no: SlotNumber, network: Network,
    ) -> Result<(), Error> {
        let cddl = CddlConfig::new();

        for tx in txs {
            let mut valid_registration = true;

            if !tx.metadata().is_empty() {
                let (registration, errors_report) =
                    match parse_registrations_from_metadata(&tx.metadata(), network) {
                        Ok(registration) => registration,
                        Err(_err) => {
                            // fatal error parsing registration tx, unable to extract meaningful
                            // errors assume corrupted tx
                            continue;
                        },
                    };

                // cddl verification
                if let Some(cip36) = registration.clone().raw_cbor_cip36 {
                    match validate_reg_cddl(&cip36, &cddl) {
                        Ok(()) => (),
                        Err(_err) => {
                            // did not pass cddl verification, not a valid registration
                            continue;
                        },
                    };
                } else {
                    // registration does not contain cip36 61284 or 61285 keys
                    // not a valid registration tx
                    continue;
                }

                self.index_txn_data(tx.hash().as_slice(), slot_no, network)
                    .await?;

                let report = json!(&errors_report);

                if errors_report.is_empty() {
                    // valid registration
                    self.insert_voter_registration(
                        tx.hash().to_string(),
                        &registration.stake_key.unwrap_or_default().0 .0,
                        serde_json::to_string(&registration.voting_key.unwrap_or_default())
                            .unwrap_or_default()
                            .as_bytes(),
                        &registration.rewards_address.unwrap_or_default().0,
                        &registration.raw_cbor_cip36.unwrap_or_default(),
                        registration
                            .nonce
                            .unwrap_or(NonceReg(1))
                            .0
                            .try_into()
                            .unwrap_or(0),
                        report,
                        valid_registration,
                    )
                    .await?;
                } else {
                    // invalid registration
                    // index with invalid registration flag and error report
                    valid_registration = false;

                    self.insert_voter_registration(
                        tx.hash().to_string(),
                        &registration.stake_key.unwrap_or_default().0 .0,
                        serde_json::to_string(&registration.voting_key.unwrap_or_default())
                            .unwrap_or_default()
                            .as_bytes(),
                        &registration.rewards_address.unwrap_or_default().0,
                        &registration.raw_cbor_cip36.unwrap_or_default(),
                        registration
                            .nonce
                            .unwrap_or(NonceReg(1))
                            .0
                            .try_into()
                            .unwrap_or(0),
                        report,
                        valid_registration,
                    )
                    .await?;
                }
            }
        }

        Ok(())
    }

    /// Get registration info
    pub(crate) async fn get_registration_info(
        &self, stake_credential: StakeCredential<'_>, network: Network, slot_num: SlotNumber,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        let _row = conn
            .query_one(SELECT_VOTER_REGISTRATION_SQL, &[
                &stake_credential,
                &network.to_string(),
                &slot_num,
            ])
            .await?;

        Ok(())
    }
}
