//! Voter registration queries

use cardano_chain_follower::Network;
use pallas::ledger::traverse::MultiEraTx;
use serde_json::json;

use super::{follower::SlotNumber, Error, EventDB};
use crate::registration::{
    parse_registrations_from_metadata, validate_reg_cddl, CddlConfig, ErrorReport,
    Nonce as NonceReg,
};

/// Transaction id
pub(crate) type TxId = Vec<u8>;
/// Stake credential
pub(crate) type StakeCredential = Vec<u8>;
/// Public voting key
pub(crate) type PublicVotingKey<'a> = &'a [u8];
/// Payment address
pub(crate) type PaymentAddress = Vec<u8>;
/// Nonce
pub(crate) type Nonce = i64;
/// Metadata 61284
pub(crate) type MetadataCip36 = Vec<u8>;
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
        &self, tx_id: TxId, stake_credential: Option<StakeCredential>,
        public_voting_key: PublicVotingKey<'_>, payment_address: Option<PaymentAddress>,
        metadata_cip36: Option<MetadataCip36>, nonce: Nonce, errors_report: ErrorReport,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        let is_valid = stake_credential.is_some()
            && payment_address.is_some()
            && metadata_cip36.is_some()
            && errors_report.is_empty();

        let _rows = conn
            .query(INSERT_VOTER_REGISTRATION_SQL, &[
                &tx_id,
                &stake_credential,
                &public_voting_key,
                &payment_address,
                &nonce,
                &metadata_cip36,
                &json!(&errors_report),
                &is_valid,
            ])
            .await?;

        Ok(())
    }

    /// Index registration data
    pub(crate) async fn index_registration_data(
        &self, tx: &MultiEraTx<'_>, network: Network,
    ) -> Result<(), Error> {
        let cddl = CddlConfig::new();

        if !tx.metadata().is_empty() {
            let (registration, errors_report) =
                match parse_registrations_from_metadata(&tx.metadata(), network) {
                    Ok(registration) => registration,
                    Err(_err) => {
                        // fatal error parsing registration tx, unable to extract meaningful
                        // errors assume corrupted tx
                        return Ok(());
                    },
                };

            // cddl verification
            if let Some(cip36) = registration.clone().raw_cbor_cip36 {
                match validate_reg_cddl(&cip36, &cddl) {
                    Ok(()) => (),
                    Err(_err) => {
                        // did not pass cddl verification, not a valid registration
                        return Ok(());
                    },
                };
            } else {
                // registration does not contain cip36 61284 or 61285 keys
                // not a valid registration tx
                return Ok(());
            }

            self.insert_voter_registration(
                tx.hash().to_vec(),
                registration.stake_key.map(|val| val.0 .0),
                serde_json::to_string(&registration.voting_key.unwrap_or_default())
                    .unwrap_or_default()
                    .as_bytes(),
                registration.rewards_address.map(|val| val.0),
                registration.raw_cbor_cip36,
                registration
                    .nonce
                    .unwrap_or(NonceReg(1))
                    .0
                    .try_into()
                    .unwrap_or(0),
                errors_report,
            )
            .await?;
        }

        Ok(())
    }

    /// Get registration info
    pub(crate) async fn get_registration_info(
        &self, stake_credential: StakeCredential, network: Network, slot_num: SlotNumber,
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
