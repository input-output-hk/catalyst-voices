//! Voter registration queries

use super::{Error, EventDB};

/// Transaction id
pub(crate) type TxId = String;
/// Stake credential
pub(crate) type StateCredential = String;
/// Public voting key
pub(crate) type PublicVotingKey = String;
/// Payment address
pub(crate) type PaymentAddress = String;
/// Nonce
pub(crate) type Nonce = i64;
/// Metadata 61284
pub(crate) type Metadata61284 = Box<[u8]>;
/// Metadata 61285
pub(crate) type Metadata61285 = Box<[u8]>;
/// Stats
pub(crate) type Stats = Option<serde_json::Value>;

impl EventDB {
    /// Inserts voter registration data, replacing any existing data.
    #[allow(dead_code, clippy::too_many_arguments)]
    async fn insert_voter_registration(
        &self, tx_id: TxId, stake_credential: StateCredential, public_voting_key: PublicVotingKey,
        payment_address: PaymentAddress, nonce: Nonce, metadata_61284: Metadata61284,
        metadata_61285: Metadata61285, valid: bool, stats: Stats,
    ) -> Result<(), Error> {
        let conn = self.pool.get().await?;

        let _rows = conn
            .query(include_str!("insert_voter_registration.sql"), &[
                &hex::decode(tx_id).map_err(|e| Error::DecodeHex(e.to_string()))?,
                &hex::decode(stake_credential).map_err(|e| Error::DecodeHex(e.to_string()))?,
                &hex::decode(public_voting_key).map_err(|e| Error::DecodeHex(e.to_string()))?,
                &hex::decode(payment_address).map_err(|e| Error::DecodeHex(e.to_string()))?,
                &nonce,
                &metadata_61284.as_ref(),
                &metadata_61285.as_ref(),
                &valid,
                &stats,
            ])
            .await?;

        Ok(())
    }
}
