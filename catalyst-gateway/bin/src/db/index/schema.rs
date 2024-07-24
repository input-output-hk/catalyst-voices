//! Index Schema

use anyhow::Context;
use handlebars::Handlebars;
use serde_json::json;
use tracing::error;

use super::session::CassandraSession;
use crate::settings::CassandraEnvVars;

/// Keyspace Create (Templated)
const CREATE_NAMESPACE_CQL: &str = include_str!("./schema/namespace.cql");

/// TXO by Stake Address Table Schema
const CREATE_TABLE_TXO_BY_STAKE_ADDRESS_CQL: &str = include_str!("./schema/txo_by_stake_table.cql");
/// TXO Assets by Stake Address Table Schema
const CREATE_TABLE_TXO_ASSETS_BY_STAKE_ADDRESS_CQL: &str =
    include_str!("./schema/txo_assets_by_stake_table.cql");
/// TXI by Stake Address Table Schema
const CREATE_TABLE_TXI_BY_STAKE_ADDRESS_CQL: &str = include_str!("./schema/txi_by_stake_table.cql");

/// The version of the Schema we are using.
/// Must be incremented if there is a breaking change in any schema tables below.
pub(crate) const SCHEMA_VERSION: u64 = 1;

/// Get the namespace for a particular db configuration
pub(crate) fn namespace(cfg: &CassandraEnvVars) -> String {
    // Build and set the Keyspace to use.
    format!("{}_V{}", cfg.namespace.as_str(), SCHEMA_VERSION)
}

/// Create the namespace we will use for this session
/// Ok to run this if the namespace already exists.
async fn create_namespace(
    session: &mut CassandraSession, cfg: &CassandraEnvVars,
) -> anyhow::Result<()> {
    let keyspace = namespace(cfg);

    let mut reg = Handlebars::new();
    // disable default `html_escape` function
    // which transforms `<`, `>` symbols to `&lt`, `&gt`
    reg.register_escape_fn(|s| s.into());
    let query = reg.render_template(CREATE_NAMESPACE_CQL, &json!({"keyspace": keyspace}))?;

    // Create the Keyspace if it doesn't exist already.
    let stmt = session.prepare(query).await?;
    session.execute(&stmt, ()).await?;

    // Wait for the Schema to be ready.
    session.await_schema_agreement().await?;

    // Set the Keyspace to use for this session.
    if let Err(error) = session.use_keyspace(keyspace.clone(), false).await {
        error!(keyspace = keyspace, error = %error, "Failed to set keyspace");
    }

    Ok(())
}

/// Create tables for holding TXO data.
async fn create_txo_tables(session: &mut CassandraSession) -> anyhow::Result<()> {
    let stmt = session
        .prepare(CREATE_TABLE_TXO_BY_STAKE_ADDRESS_CQL)
        .await
        .context("Create Table TXO By Stake Address: Prepared")?;
    session
        .execute(&stmt, ())
        .await
        .context("Create Table TXO By Stake Address: Executed")?;

    let stmt = session
        .prepare(CREATE_TABLE_TXO_ASSETS_BY_STAKE_ADDRESS_CQL)
        .await
        .context("Create Table TXO Assets By Stake Address: Prepared")?;
    session
        .execute(&stmt, ())
        .await
        .context("Create Table TXO Assets By Stake Address: Executed")?;

    Ok(())
}

/// Create tables for holding volatile TXI data
async fn create_txi_tables(session: &mut CassandraSession) -> anyhow::Result<()> {
    let stmt = session
        .prepare(CREATE_TABLE_TXI_BY_STAKE_ADDRESS_CQL)
        .await
        .context("Create Table TXI By Stake Address: Prepared")?;

    session
        .execute(&stmt, ())
        .await
        .context("Create Table TXI By Stake Address: Executed")?;

    Ok(())
}

/// Create the Schema on the connected Cassandra DB
pub(crate) async fn create_schema(
    session: &mut CassandraSession, cfg: &CassandraEnvVars, persistent: bool,
) -> anyhow::Result<()> {
    create_namespace(session, cfg).await?;

    create_txo_tables(session).await?;

    if !persistent {
        create_txi_tables(session).await?;
    }

    // Wait for the Schema to be ready.
    session.await_schema_agreement().await?;

    Ok(())
}
