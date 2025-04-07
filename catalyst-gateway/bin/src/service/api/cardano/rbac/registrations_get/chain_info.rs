//! A RBAC registration chain information.

// cspell: words rposition

use anyhow::{bail, Context};
use cardano_blockchain_types::{Network, Point, Slot, TransactionId, TxnIndex};
use cardano_chain_follower::ChainFollower;
use catalyst_types::id_uri::IdUri;
use futures::{future::try_join, TryFutureExt, TryStreamExt};
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
        let registrations =
            last_registration_chain(persistent_session, volatile_session, catalyst_id).await?;
        if registrations.is_empty() {
            return Ok(None);
        }

        let network = Settings::cardano_network();

        let mut last_persistent_txn = None;
        let mut last_volatile_txn = None;
        let mut last_persistent_slot = 0.into();

        let mut iter = registrations.into_iter();
        let (is_persistent, reg) = iter.next().context("No root registration found")?;
        let cip509 = registration(network, reg.slot_no.into(), reg.txn_index.into()).await?;
        let mut chain = RegistrationChain::new(cip509).context("Invalid root registration")?;
        update_values(
            is_persistent,
            &reg,
            &mut last_persistent_txn,
            &mut last_volatile_txn,
            &mut last_persistent_slot,
        );

        for (is_persistent, reg) in iter {
            let cip509 = registration(network, reg.slot_no.into(), reg.txn_index.into()).await?;

            // This isn't a hard error because while the individual registration can be valid it can
            // be invalid in the context of the whole registration chain.
            if let Ok(new) = chain.update(cip509) {
                chain = new;
                update_values(
                    is_persistent,
                    &reg,
                    &mut last_persistent_txn,
                    &mut last_volatile_txn,
                    &mut last_persistent_slot,
                );
            }
        }

        Ok(Some(Self {
            chain,
            last_persistent_txn,
            last_volatile_txn,
            last_persistent_slot,
        }))
    }
}

/// Returns a last independent chain of both persistent and volatile registrations.
async fn last_registration_chain(
    persistent_session: &CassandraSession, volatile_session: &CassandraSession, catalyst_id: &IdUri,
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

/// Returns a sorted list of registrations for the given Catalyst ID from the database.
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

/// Returns a RBAC registration from the given block and slot.
async fn registration(network: Network, slot: Slot, txn_index: TxnIndex) -> anyhow::Result<Cip509> {
    let point = Point::fuzzy(slot);
    let block = ChainFollower::get_block(network, point)
        .await
        .with_context(|| format!("Unable to get {slot:?} block"))?
        .data;
    if block.point().slot_or_default() != slot {
        // The `ChainFollower::get_block` function can return the next consecutive block if it
        // cannot find the exact one. This shouldn't happen, but we need to check anyway.
        bail!("Unable to find exact {slot:?} block");
    }
    // We perform validation during indexing, so this normally should never fail.
    Cip509::new(&block, txn_index, &[])
        .with_context(|| {
            format!("Invalid RBAC registration, slot = {slot:?}, transaction index = {txn_index:?}")
        })?
        .with_context(|| {
            format!("No RBAC registration, slot = {slot:?}, transaction index = {txn_index:?}")
        })
}

/// Updates the values depending on if the given registration is persistent or not.
fn update_values(
    is_persistent: bool, reg: &Query, last_persistent_txn: &mut Option<TransactionId>,
    last_volatile_txn: &mut Option<TransactionId>, last_persistent_slot: &mut Slot,
) {
    if is_persistent {
        *last_persistent_txn = Some(reg.txn_id.into());
        *last_persistent_slot = reg.slot_no.into();
    } else {
        *last_volatile_txn = Some(reg.txn_id.into());
    }
}
