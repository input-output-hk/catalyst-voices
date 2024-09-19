//! Index Schema

use std::sync::Arc;

use anyhow::Context;
use handlebars::Handlebars;
use scylla::Session;
use serde_json::json;
use tracing::error;

use crate::settings::CassandraEnvVars;

/// Keyspace Create (Templated)
const CREATE_NAMESPACE_CQL: &str = include_str!("./cql/namespace.cql");

/// The version of the Schema we are using.
/// Must be incremented if there is a breaking change in any schema tables below.
pub(crate) const SCHEMA_VERSION: u64 = 1;

/// All Schema Creation Statements
const SCHEMAS: &[(&str, &str)] = &[
    (
        // TXO by Stake Address Table Schema
        include_str!("./cql/txo_by_stake_table.cql"),
        "Create Table TXO By Stake Address",
    ),
    (
        // TXO Assets by Stake Address Table Schema
        include_str!("./cql/txo_assets_by_stake_table.cql"),
        "Create Table TXO Assets By Stake Address",
    ),
    (
        // TXO Unstaked Table Schema
        include_str!("./cql/unstaked_txo_by_txn_hash.cql"),
        "Create Table Unstaked TXO By Txn Hash",
    ),
    (
        // TXO Unstaked Assets Table Schema
        include_str!("./cql/unstaked_txo_assets_by_txn_hash.cql"),
        "Create Table Unstaked TXO Assets By Txn Hash",
    ),
    (
        // TXI by Stake Address Table Schema
        include_str!("./cql/txi_by_txn_hash_table.cql"),
        "Create Table TXI By Stake Address",
    ),
    (
        // Stake Address/Registration Table Schema
        include_str!("./cql/stake_registration.cql"),
        "Create Table Stake Registration",
    ),
    (
        // CIP-36 Registration Table Schema
        include_str!("./cql/cip36_registration.cql"),
        "Create Table CIP-36 Registration",
    ),
    (
        // CIP-36 Registration Table Schema
        include_str!("./cql/cip36_registration_invalid.cql"),
        "Create Table CIP-36 Registration Invalid",
    ),
    (
        // CIP-36 Registration Table Schema
        include_str!("./cql/cip36_registration_for_vote_key.cql"),
        "Create Table CIP-36 Registration For a stake address",
    ),
];

/// Get the namespace for a particular db configuration
pub(crate) fn namespace(cfg: &CassandraEnvVars) -> String {
    // Build and set the Keyspace to use.
    format!("{}_V{}", cfg.namespace.as_str(), SCHEMA_VERSION)
}

/// Create the namespace we will use for this session
/// Ok to run this if the namespace already exists.
async fn create_namespace(
    session: &mut Arc<Session>, cfg: &CassandraEnvVars,
) -> anyhow::Result<()> {
    let keyspace = namespace(cfg);

    let mut reg = Handlebars::new();
    // disable default `html_escape` function
    // which transforms `<`, `>` symbols to `&lt`, `&gt`
    reg.register_escape_fn(|s| s.into());
    let query = reg.render_template(CREATE_NAMESPACE_CQL, &json!({"keyspace": keyspace}))?;

    // Create the Keyspace if it doesn't exist already.
    let stmt = session.prepare(query).await?;
    session.execute_unpaged(&stmt, ()).await?;

    // Wait for the Schema to be ready.
    session.await_schema_agreement().await?;

    // Set the Keyspace to use for this session.
    if let Err(error) = session.use_keyspace(keyspace.clone(), false).await {
        error!(keyspace = keyspace, error = %error, "Failed to set keyspace");
    }

    Ok(())
}

/// Create the Schema on the connected Cassandra DB
pub(crate) async fn create_schema(
    session: &mut Arc<Session>, cfg: &CassandraEnvVars,
) -> anyhow::Result<()> {
    create_namespace(session, cfg).await?;

    for schema in SCHEMAS {
        let stmt = session
            .prepare(schema.0)
            .await
            .context(format!("{} : Prepared", schema.1))?;

        session
            .execute_unpaged(&stmt, ())
            .await
            .context(format!("{} : Executed", schema.1))?;
    }

    // Wait for the Schema to be ready.
    session.await_schema_agreement().await?;

    Ok(())
}
