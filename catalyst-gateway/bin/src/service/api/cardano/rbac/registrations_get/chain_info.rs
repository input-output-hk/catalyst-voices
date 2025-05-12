//! A RBAC registration chain information.

// cspell: words rposition

use anyhow::Context;
use cardano_blockchain_types::{Slot, TransactionId};
use catalyst_types::catalyst_id::CatalystId;
use futures::future::try_join;
use rbac_registration::registration::cardano::RegistrationChain;

use crate::{
    db::index::{
        queries::rbac::get_rbac_registrations::{build_reg_chain, indexed_registrations, Query},
        session::CassandraSession,
    },
    settings::Settings,
};

/// A RBAC registration chain along with additional information.
pub struct ChainInfo {
    /// A RBAC registration chain.
    pub chain: RegistrationChain,
    /// The latest persistent transaction ID of the chain.
    pub last_persistent_txn: Option<TransactionId>,
    /// The latest volatile transaction ID of the chain.
    pub last_volatile_txn: Option<TransactionId>,
    /// A slot number of the latest persistent registration.
    pub last_persistent_slot: Slot,
}

impl ChainInfo {
    /// Creates a new `ChainInfo` instance.
    pub(crate) async fn new(
        persistent_session: &CassandraSession, volatile_session: &CassandraSession,
        catalyst_id: &CatalystId,
    ) -> anyhow::Result<Option<Self>> {
        let registrations =
            last_registration_chain(persistent_session, volatile_session, catalyst_id).await?;

        let network = Settings::cardano_network();

        let mut last_persistent_txn = None;
        let mut last_volatile_txn = None;
        let mut last_persistent_slot = 0.into();

        let res = build_reg_chain(
            registrations.into_iter(),
            network,
            |is_persistent: bool, slot_no: Slot, chain: &RegistrationChain| {
                if is_persistent {
                    last_persistent_txn = Some(chain.current_tx_id_hash());
                    last_persistent_slot = slot_no;
                } else {
                    last_volatile_txn = Some(chain.current_tx_id_hash());
                }
            },
        )
        .await?
        .map(|chain| {
            Self {
                chain,
                last_persistent_txn,
                last_volatile_txn,
                last_persistent_slot,
            }
        });
        Ok(res)
    }
}

/// Returns a last independent chain of both persistent and volatile registrations.
async fn last_registration_chain(
    persistent_session: &CassandraSession, volatile_session: &CassandraSession,
    catalyst_id: &CatalystId,
) -> anyhow::Result<Vec<(bool, Query)>> {
    let (persistent_registrations, volatile_registrations) = try_join(
        indexed_registrations(persistent_session, catalyst_id),
        indexed_registrations(volatile_session, catalyst_id),
    )
    .await?;

    // Combine persistent and volatile registrations.
    let registrations: Vec<_> = persistent_registrations
        .into_iter()
        .map(|r| (true, r))
        .chain(volatile_registrations.into_iter().map(|r| (false, r)))
        .collect();
    if registrations.is_empty() {
        return Ok(Vec::new());
    }

    // Find the last independent registration chain.
    let pos = registrations
        .iter()
        .rposition(|(_, r)| r.prv_txn_id.is_none())
        // This should never happen because we don't index registrations with unknown Catalyst
        // ID, and it can only be extracted from the root registration, so there must be at
        // least one.
        .context("Unable to find root registration")?;
    registrations
        .get(pos..)
        .map(<[_]>::to_vec)
        // This should never happen: the index is valid because of the check above.
        .context("Invalid root registration index")
}
