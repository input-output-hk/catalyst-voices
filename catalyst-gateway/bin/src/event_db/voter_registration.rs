//! Voter registration queries

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
pub(crate) type Stats = Option<serde_json::Value>;

impl EventDB {
    /// Inserts voter registration data, replacing any existing data.
    #[allow(dead_code, clippy::too_many_arguments)]
    async fn insert_voter_registration(
        &self, tx_id: TxId, stake_credential: StakeCredential<'_>,
        public_voting_key: PublicVotingKey<'_>, payment_address: PaymentAddress<'_>, nonce: Nonce,
        metadata_61284: Metadata61284<'_>, metadata_61285: Metadata61285<'_>, valid: bool,
        stats: Stats,
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
                    &stats,
                ],
            )
            .await?;

        Ok(())
    }
}
