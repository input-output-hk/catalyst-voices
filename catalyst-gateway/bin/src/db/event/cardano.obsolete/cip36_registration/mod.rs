//! Voter registration queries

use cardano_chain_follower::Network;
use pallas::ledger::traverse::MultiEraBlock;
use tokio_postgres::{binary_copy::BinaryCopyInWriter, types::Type};

use crate::{
    cardano::{
        cip36_registration::{Cip36Metadata, VotingInfo},
        util::valid_era,
    },
    db::event::{
        cardano::chain_state::SlotNumber, error::NotFoundError, Error, EventDB, EVENT_DB_POOL,
    },
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

/// `select_voter_registration.sql`
const SELECT_VOTER_REGISTRATION_SQL: &str = include_str!("select_cip36_registration.sql");

/// Data required to index voter registrations.
pub(crate) struct IndexedVoterRegistrationParams {
    /// Transaction id.
    pub tx_id: TxId,
    /// Stake credentials.
    pub stake_credential: Option<StakeCredential>,
    /// Public voting key.
    pub public_voting_key: Option<Vec<u8>>,
    /// Payment address.
    pub payment_address: Option<PaymentAddress>,
    /// Nonce.
    pub nonce: Option<Nonce>,
    /// CIP-36 metadata.
    pub cip36_metadata: Option<MetadataCip36>,
    /// Errors JSON.
    pub stats: serde_json::Value,
    /// Whether the registration is valid.
    pub valid: bool,
}

impl IndexedVoterRegistrationParams {
    /// Creates voter registration indexing data from block data.
    pub(crate) fn from_block_data(
        block: &MultiEraBlock, network: Network,
    ) -> Option<Vec<IndexedVoterRegistrationParams>> {
        if !valid_era(block.era()) {
            return None;
        }

        let registrations = block
            .txs()
            .into_iter()
            .filter_map(|tx| {
                if tx.metadata().is_empty() {
                    return None;
                }

                let cip36_metadata =
                    Cip36Metadata::generate_from_tx_metadata(&tx.metadata(), network)?;

                let (stake_credential, voting_info, rewards_address, nonce) =
                    if let Some(reg) = cip36_metadata.registration {
                        (
                            Some(reg.stake_key.get_credentials().to_vec()),
                            Some(reg.voting_info),
                            Some(reg.rewards_address.0),
                            Some(reg.nonce.0),
                        )
                    } else {
                        (None, None, None, None)
                    };
                let encoded_voting_key = if let Some(voting_info) = voting_info.as_ref() {
                    let Ok(enc) = serde_json::to_string(voting_info) else {
                        return None;
                    };

                    Some(enc.into_bytes())
                } else {
                    None
                };

                let multiple_delegations = voting_info.as_ref().is_some_and(|vi| {
                    if let VotingInfo::Delegated(delegations) = vi {
                        delegations.len() > 1
                    } else {
                        false
                    }
                });

                let is_valid = !multiple_delegations
                    && stake_credential.is_some()
                    && encoded_voting_key.is_some()
                    && rewards_address.is_some()
                    && nonce.is_some()
                    && cip36_metadata.errors_report.is_empty();

                Some(IndexedVoterRegistrationParams {
                    tx_id: tx.hash().to_vec(),
                    stake_credential,
                    public_voting_key: encoded_voting_key,
                    payment_address: rewards_address,
                    nonce,
                    cip36_metadata: None,
                    stats: serde_json::json!(cip36_metadata.errors_report),
                    valid: is_valid,
                })
            })
            .collect();

        Some(registrations)
    }
}

impl EventDB {
    /// Batch writes voter registration data.
    pub(crate) async fn index_many_voter_registration_data(
        values: &[IndexedVoterRegistrationParams],
    ) -> anyhow::Result<()> {
        if values.is_empty() {
            return Ok(());
        }

        let pool = EVENT_DB_POOL.get().ok_or(Error::DbPoolUninitialized)?;
        let mut conn = pool.get().await?;
        let tx = conn.transaction().await?;

        tx.execute(
            "CREATE TEMPORARY TABLE tmp_cardano_voter_registration (LIKE cardano_voter_registration) ON COMMIT DROP",
            &[],
        )
        .await?;

        {
            let sink = tx
            .copy_in("COPY  tmp_cardano_voter_registration (tx_id, stake_credential, public_voting_key, payment_address, nonce, metadata_cip36, stats, valid) FROM STDIN BINARY")
            .await?;
            let writer = BinaryCopyInWriter::new(
                sink,
                &[
                    Type::BYTEA,
                    Type::BYTEA,
                    Type::BYTEA,
                    Type::BYTEA,
                    Type::INT8,
                    Type::BYTEA,
                    Type::JSONB,
                    Type::BOOL,
                ],
            );
            tokio::pin!(writer);

            for params in values {
                #[allow(trivial_casts)]
                writer
                    .as_mut()
                    .write(&[
                        &params.tx_id as &(dyn tokio_postgres::types::ToSql + Sync),
                        &params.stake_credential,
                        &params.public_voting_key,
                        &params.payment_address,
                        &params.nonce,
                        &params.cip36_metadata,
                        &params.stats,
                        &params.valid,
                    ])
                    .await?;
            }

            writer.finish().await?;
        }

        tx.execute("INSERT INTO cardano_voter_registration (tx_id, stake_credential, public_voting_key, payment_address, nonce, metadata_cip36, stats, valid) 
                   SELECT tx_id, stake_credential, public_voting_key, payment_address, nonce, metadata_cip36, stats, valid FROM tmp_cardano_voter_registration
                   ON CONFLICT (tx_id) DO UPDATE SET stake_credential = EXCLUDED.stake_credential, public_voting_key = EXCLUDED.public_voting_key, payment_address = EXCLUDED.payment_address,
                   nonce = EXCLUDED.nonce, metadata_cip36 = EXCLUDED.metadata_cip36, stats = EXCLUDED.stats, valid = EXCLUDED.valid", &[]).await?;
        tx.commit().await?;

        Ok(())
    }

    /// Get registration info
    pub(crate) async fn get_registration_info(
        stake_credential: StakeCredential, network: Network, slot_num: SlotNumber,
    ) -> anyhow::Result<(TxId, PaymentAddress, PublicVotingInfo, Nonce)> {
        let rows = Self::query(
            SELECT_VOTER_REGISTRATION_SQL,
            &[&stake_credential, &network.to_string(), &slot_num],
        )
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

