//! A RBAC registration chain information.

use anyhow::{bail, Context};
use cardano_blockchain_types::{Network, Point, Slot, TransactionId, TxnIndex};
use cardano_chain_follower::ChainFollower;
use catalyst_types::id_uri::IdUri;
use futures::{TryFutureExt, TryStreamExt};
use rbac_registration::{cardano::cip509::Cip509, registration::cardano::RegistrationChain};

use crate::{
    db::index::{
        queries::rbac::get_rbac_registrations::{Query, QueryParams},
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
        catalyst_id: &IdUri,
    ) -> anyhow::Result<Option<Self>> {
        let persistent_registrations =
            indexed_registrations(persistent_session, catalyst_id).await?;
        let volatile_registrations = indexed_registrations(volatile_session, catalyst_id).await?;
        let network = Settings::cardano_network();

        let (chain, last_persistent_slot) =
            apply_registrations(network, None, persistent_registrations).await?;
        let last_persistent_txn = chain.as_ref().map(RegistrationChain::current_tx_id_hash);

        let (chain, _) = apply_registrations(network, chain, volatile_registrations).await?;
        let last_volatile_txn = chain.as_ref().map(RegistrationChain::current_tx_id_hash);

        Ok(chain.map(|chain| {
            Self {
                chain,
                last_persistent_txn,
                last_volatile_txn,
                last_persistent_slot,
            }
        }))
    }
}

/// Returns a sorted list of all registrations for the given Catalyst ID from the
/// database.
async fn indexed_registrations(
    session: &CassandraSession, catalyst_id: &IdUri,
) -> anyhow::Result<Vec<Query>> {
    let mut result: Vec<_> = Query::execute(session, QueryParams {
        catalyst_id: catalyst_id.clone().into(),
    })
    .and_then(|r| r.try_collect().map_err(Into::into))
    .await?;

    result.sort_by_key(|r| r.slot_no);
    Ok(result)
}

/// Applies the given list of indexed registrations to the chain. If the given chain is
/// `None` - new root will be possibly created.
async fn apply_registrations(
    network: Network, mut chain: Option<RegistrationChain>, indexed_registrations: Vec<Query>,
) -> anyhow::Result<(Option<RegistrationChain>, Slot)> {
    let mut last_slot = 0.into();

    for reg in indexed_registrations {
        // We perform validation during indexing, so this normally should never fail.
        let cip509 = registration(network, reg.slot_no.into(), reg.txn_index.into())
            .await
            .with_context(|| {
                format!(
                    "Failed to get Cip509 registration from {:?} slot and {:?} txn index",
                    reg.slot_no, reg.txn_index
                )
            })?;

        match chain {
            None => {
                if let Ok(root) = RegistrationChain::new(cip509) {
                    chain = Some(root);
                    last_slot = reg.slot_no.into();
                }
            },
            Some(ref current) => {
                // This isn't a hard error because while the individual registration can
                // be valid it can be invalid in the context of the whole registration
                // chain.
                if let Ok(new) = current.update(cip509) {
                    chain = Some(new);
                    last_slot = reg.slot_no.into();
                }
            },
        }
    }

    Ok((chain, last_slot))
}

/// Returns a RBAC registration from the given block and slot.
async fn registration(network: Network, slot: Slot, txn_index: TxnIndex) -> anyhow::Result<Cip509> {
    let point = Point::fuzzy(slot);
    let block = ChainFollower::get_block(network, point)
        .await
        .context("Unable to get block")?
        .data;
    if block.point().slot_or_default() != slot {
        // The `ChainFollower::get_block` function can return the next consecutive block if it
        // cannot find the exact one. This shouldn't happen, but we need to check anyway.
        bail!("Unable to find exact block");
    }
    Cip509::new(&block, txn_index, &[])
        .context("Invalid RBAC registration")?
        .context("No RBAC registration at this block and txn index")
}
