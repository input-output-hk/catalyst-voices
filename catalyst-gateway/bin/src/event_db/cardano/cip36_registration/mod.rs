//! Voter registration queries

use cardano_chain_follower::Network;
use pallas::ledger::traverse::MultiEraTx;
use serde_json::json;

use crate::{
    cardano::cip36_registration::{Cip36Metadata, ErrorReport, VotingInfo},
    event_db::{cardano::chain_state::SlotNumber, error::NotFoundError, EventDB},
};

/// Transaction id
pub(crate) type TxId = Vec<u8>;
/// Stake credential
pub(crate) type StakeCredential = Vec<u8>;
/// Public voting key
pub(crate) type PublicVotingInfo = VotingInfo;
/// Payment address
pub(crate) type PaymentAddress = Vec<u8>;
/// Nonce
pub(crate) type Nonce = i64;
/// Metadata 61284
pub(crate) type MetadataCip36 = Vec<u8>;
/// Stats
pub(crate) type _Stats = Option<serde_json::Value>;

/// `tx_id` column name
const TX_ID_COLUMN: &str = "tx_id";
/// `payment_address` column name
const PAYMENT_ADDRESS_COLUMN: &str = "payment_address";
/// `public_voting_key` column name
const PUBLIC_VOTING_KEY_COLUMN: &str = "public_voting_key";
/// `nonce` column name
const NONCE_COLUMN: &str = "nonce";

/// `insert_voter_registration.sql`
const INSERT_VOTER_REGISTRATION_SQL: &str = include_str!("insert_cip36_registration.sql");
/// `select_voter_registration.sql`
const SELECT_VOTER_REGISTRATION_SQL: &str = include_str!("select_cip36_registration.sql");

impl EventDB {
    /// Inserts voter registration data, replacing any existing data.
    #[allow(clippy::too_many_arguments)]
    async fn insert_voter_registration(
        &self, tx_id: TxId, stake_credential: Option<StakeCredential>,
        voting_info: Option<PublicVotingInfo>, payment_address: Option<PaymentAddress>,
        metadata_cip36: Option<MetadataCip36>, nonce: Option<Nonce>, errors_report: ErrorReport,
    ) -> anyhow::Result<()> {
        let conn = self.pool.get().await?;

        // for the catalyst we dont support multiple delegations
        let multiple_delegations = voting_info.as_ref().is_some_and(|voting_info| {
            if let PublicVotingInfo::Delegated(delegations) = voting_info {
                delegations.len() > 1
            } else {
                false
            }
        });

        let encoded_voting_info = if let Some(voting_info) = voting_info {
            Some(
                serde_json::to_string(&voting_info)
                    .map_err(|_| anyhow::anyhow!("Cannot encode voting key".to_string()))?
                    .as_bytes()
                    .to_vec(),
            )
        } else {
            None
        };

        let is_valid = !multiple_delegations
            && stake_credential.is_some()
            && encoded_voting_info.is_some()
            && payment_address.is_some()
            && metadata_cip36.is_some()
            && nonce.is_some()
            && errors_report.is_empty();

        let _rows = conn
            .query(INSERT_VOTER_REGISTRATION_SQL, &[
                &tx_id,
                &stake_credential,
                &encoded_voting_info,
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
    ) -> anyhow::Result<()> {
        let Some(cip36) = Cip36Metadata::generate_from_tx_metadata(&tx.metadata(), network) else {
            return Ok(());
        };

        let tx_hash = tx.hash().to_vec();
        let (stake_credential, voting_info, rewards_address, nonce) =
            if let Some(reg) = cip36.registration {
                (
                    Some(reg.stake_key.get_credentials().to_vec()),
                    Some(reg.voting_info),
                    Some(reg.rewards_address.0),
                    Some(reg.nonce.0),
                )
            } else {
                (None, None, None, None)
            };

        self.insert_voter_registration(
            tx_hash,
            stake_credential,
            voting_info,
            rewards_address,
            cip36.raw_metadata,
            nonce,
            cip36.errors_report,
        )
        .await?;

        Ok(())
    }

    /// Get registration info
    pub(crate) async fn get_registration_info(
        &self, stake_credential: StakeCredential, network: Network, slot_num: SlotNumber,
    ) -> anyhow::Result<(TxId, PaymentAddress, PublicVotingInfo, Nonce)> {
        let conn = self.pool.get().await?;

        let rows = conn
            .query(SELECT_VOTER_REGISTRATION_SQL, &[
                &stake_credential,
                &network.to_string(),
                &slot_num,
            ])
            .await?;

        let row = rows.first().ok_or(NotFoundError)?;

        let tx_id = row.try_get(TX_ID_COLUMN)?;
        let payment_address = row.try_get(PAYMENT_ADDRESS_COLUMN)?;
        let nonce = row.try_get(NONCE_COLUMN)?;
        let public_voting_info = serde_json::from_str(
            &String::from_utf8(row.try_get(PUBLIC_VOTING_KEY_COLUMN)?)
                .map_err(|_| anyhow::anyhow!("Cannot parse public voting key".to_string()))?,
        )
        .map_err(|_| anyhow::anyhow!("Cannot parse public voting key".to_string()))?;

        Ok((tx_id, payment_address, public_voting_info, nonce))
    }
}
