//! Voter registration queries

use cardano_chain_follower::Network;
use ciborium::Value;
use pallas::ledger::{
    primitives::Fragment,
    traverse::{MultiEraMeta, MultiEraTx},
};

use tracing::info;

use crate::cddl::{
    inspect_metamap_reg, inspect_nonce, inspect_rewards_addr, inspect_stake_key,
    inspect_voting_key, inspect_voting_purpose, raw_sig_conversion, validate_reg_cddl, CddlConfig,
    Registration,
};

use super::{Error, EventDB};
use std::{error::Error as Error2, io::Cursor};

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
    pub async fn index_registration_data(
        &self, txs: &[MultiEraTx<'_>], network: Network,
    ) -> Result<(), Error> {
        for tx in txs {
            if !tx.metadata().is_empty() {
                let registration = filter_registrations(tx.metadata(), network).unwrap();
                info!("registration {:?}", registration);
            }
        }

        Ok(())
    }
}

pub fn filter_registrations(
    meta: MultiEraMeta, network: Network,
) -> Result<Registration, Box<dyn Error2>> {
    let cddl = CddlConfig::new();

    let rr = match meta {
        pallas::ledger::traverse::MultiEraMeta::AlonzoCompatible(meta) => {
            let mut reg_61284 = Registration::default();
            for (key, cip36_registration) in meta.iter() {
                if *key == u64::try_from(61284)? {
                    // Potential cip36 registration - validate with cip36 cddl before continuing
                    let raw_cbor_61284 = meta.encode_fragment()?;

                    validate_reg_cddl(&raw_cbor_61284, &cddl)?;

                    let decoded: ciborium::value::Value =
                        ciborium::de::from_reader(Cursor::new(&raw_cbor_61284))?;

                    let meta_61284 = match decoded {
                        Value::Map(m) => m.iter().map(|entry| entry.1.clone()).collect::<Vec<_>>(),
                        _ => return Err(format!("Invalid signature {:?}", decoded).into()),
                    };

                    // 4 entries inside metadata map with one optional entry for the voting purpose
                    let metamap = match inspect_metamap_reg(&meta_61284) {
                        Ok(value) => value,
                        Err(_value) => return Err(format!("Invalid signature").into()),
                    };

                    // voting key: simply an ED25519 public key. This is the spending credential in the sidechain that will receive voting power
                    // from this delegation. For direct voting it's necessary to have the corresponding private key to cast votes in the sidechain
                    let voting_key = match inspect_voting_key(metamap) {
                        Ok(value) => value,
                        Err(_value) => return Err(format!("Invalid signature").into()),
                    };

                    // A stake address for the network that this transaction is submitted to (to point to the Ada that is being delegated);
                    let stake_key = match inspect_stake_key(metamap) {
                        Ok(value) => value,
                        Err(_value) => return Err(format!("Invalid signature").into()),
                    };

                    // A Shelley payment address (see CIP-0019) discriminated for the same network
                    // this transaction is submitted to, to receive rewards.
                    let rewards_address = match inspect_rewards_addr(metamap, network) {
                        Ok(value) => value,
                        Err(_value) => return Err(format!("Invalid signature").into()),
                    };

                    // A nonce that identifies that most recent delegation
                    let nonce = match inspect_nonce(metamap) {
                        Ok(value) => value,
                        Err(_value) => return Err(format!("Invalid signature").into()),
                    };

                    // A non-negative integer that indicates the purpose of the vote.
                    // This is an optional field to allow for compatibility with CIP-15
                    // 4 entries inside metadata map with one optional entry for the voting purpose
                    let voting_purpose = inspect_voting_purpose(metamap);

                    reg_61284 = Registration {
                        voting_key,
                        stake_key,
                        rewards_address: rewards_address.to_vec(),
                        nonce,
                        voting_purpose,
                        raw_cbor_61284,
                    };
                } else if *key == u64::try_from(61285)? {
                    // Validate 61285 signature
                    let signature = raw_sig_conversion(cip36_registration.encode_fragment()?)?;
                    info!("sig ok {:?}", signature);
                }
            }

            reg_61284
        },
        _ => todo!(),
    };

    Ok(rr)
}
