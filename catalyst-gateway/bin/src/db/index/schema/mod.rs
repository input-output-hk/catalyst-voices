//! Index Schema

use std::sync::Arc;

use anyhow::Context;
use handlebars::Handlebars;
use scylla::Session;
use serde_json::json;
use tracing::error;

use crate::{settings::cassandra_db, utils::blake2b_hash::generate_uuid_string_from_data};

/// Keyspace Create (Templated)
const CREATE_NAMESPACE_CQL: &str = include_str!("./cql/namespace.cql");

/// All Schema Creation Statements
const SCHEMAS: &[(&str, &str)] = &[
    (
        // Sync Status Table Schema
        include_str!("./cql/sync_status.cql"),
        "Create Sync Status Table",
    ),
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
    (
        // RBAC Registration Table Schema
        include_str!("./cql/rbac_registration.cql"),
        "Create Table RBAC Registration",
    ),
    (
        // Invalid RBAC Registration Table Schema
        include_str!("cql/rbac_invalid_registration.cql"),
        "Create Table Invalid RBAC Registration",
    ),
    (
        // RBAC Catalyst ID For TX ID Registration Table Schema
        include_str!("./cql/rbac_catalyst_id_for_txn_id.cql"),
        "Create Table RBAC Catalyst ID For TX ID",
    ),
    (
        // RBAC Catalyst ID For Stake Address Registration Table Schema
        include_str!("./cql/rbac_catalyst_id_for_stake_addr.cql"),
        "Create Table RBAC Catalyst ID For Stake Address",
    ),
];

/// Removes all comments from each line in the input query text and joins the remaining
/// lines into a single string, reducing consecutive whitespace characters to a single
/// space. Comments are defined as any text following `--` on a line.
///
/// # Arguments
///
/// * `text`: A string slice that holds the query to be cleaned.
///
/// # Returns
///
/// A new string with comments removed and whitespace reduced, where each remaining line
/// from the original text is separated by a newline character.
fn remove_comments_and_join_query_lines(text: &str) -> String {
    // Split the input text into lines, removing any trailing empty lines
    let raw_lines: Vec<&str> = text.lines().collect();
    let mut clean_lines: Vec<String> = Vec::new();

    // Filter out comments from each line
    for line in raw_lines {
        let mut clean_line = line.to_string();
        if let Some(no_comment) = line.split_once("--") {
            clean_line = no_comment.0.to_string();
        }
        clean_line = clean_line
            .split_whitespace()
            .collect::<Vec<&str>>()
            .join(" ")
            .trim()
            .to_string();
        if !clean_line.is_empty() {
            clean_lines.push(clean_line);
        }
    }
    clean_lines.join("\n")
}

/// Generates a unique schema version identifier based on the content of all CQL schemas.
///
/// This function processes each CQL schema, removes comments from its lines and joins
/// them into a single string. It then sorts these processed strings to ensure consistency
/// in schema versions regardless of their order in the list. Finally, it generates a UUID
/// from a 127 bit hash of this sorted collection of schema contents, which serves as a
/// unique identifier for the current version of all schemas.
///
/// # Returns
///
/// A string representing the UUID derived from the concatenated and cleaned CQL
/// schema contents.
fn generate_cql_schema_version() -> String {
    // Where we will actually store the bytes we derive the UUID from.
    let mut clean_schemas: Vec<String> = Vec::new();

    // Iterate through each CQL schema and add it to the list of clean schemas documents.
    for (schema, _) in SCHEMAS {
        let schema = remove_comments_and_join_query_lines(schema);
        if !schema.is_empty() {
            clean_schemas.push(schema);
        }
    }

    // make sure any re-ordering of the schemas in the list does not effect the generated
    // schema version
    clean_schemas.sort();

    // Generate a unique hash of the clean schemas,
    // and use it to form a UUID to identify the schema version.
    generate_uuid_string_from_data("Catalyst-Gateway Index Database Schema", &clean_schemas)
}

/// Get the namespace for a particular db configuration
pub(crate) fn namespace(cfg: &cassandra_db::EnvVars) -> String {
    // Build and set the Keyspace to use.
    format!(
        "{}_{}",
        cfg.namespace.as_str(),
        generate_cql_schema_version().replace('-', "_")
    )
}

/// Create the namespace we will use for this session
/// Ok to run this if the namespace already exists.
async fn create_namespace(
    session: &mut Arc<Session>, cfg: &cassandra_db::EnvVars,
) -> anyhow::Result<()> {
    let keyspace = namespace(cfg);

    let mut reg = Handlebars::new();
    // disable default `html_escape` function
    // which transforms `<`, `>` symbols to `&lt`, `&gt`
    reg.register_escape_fn(|s| s.into());
    let query = reg
        .render_template(
            CREATE_NAMESPACE_CQL,
            &json!({"keyspace": keyspace,"options": cfg.deployment.clone().to_string()}),
        )
        .context(format!("Keyspace: {keyspace}"))?;

    // Create the Keyspace if it doesn't exist already.
    let stmt = session
        .prepare(query)
        .await
        .context(format!("Keyspace: {keyspace}"))?;
    session
        .execute_unpaged(&stmt, ())
        .await
        .context(format!("Keyspace: {keyspace}"))?;

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
    session: &mut Arc<Session>, cfg: &cassandra_db::EnvVars,
) -> anyhow::Result<()> {
    create_namespace(session, cfg)
        .await
        .context("Creating Namespace")?;

    let mut errors = Vec::with_capacity(SCHEMAS.len());

    for (schema, schema_name) in SCHEMAS {
        match session.prepare(*schema).await {
            Ok(stmt) => {
                if let Err(err) = session.execute_unpaged(&stmt, ()).await {
                    error!(schema=schema_name, error=%err, "Failed to Execute Create Schema Query");
                    errors.push(anyhow::anyhow!(
                        "Failed to Execute Create Schema Query: {err}\n--\nSchema: {schema_name}\n--\n{schema}"
                    ));
                };
            },
            Err(err) => {
                error!(schema=schema_name, error=%err, "Failed to Prepare Create Schema Query");
                errors.push(anyhow::anyhow!(
                    "Failed to Prepare Create Schema Query: {err}\n--\nSchema: {schema_name}\n--\n{schema}"
                ));
            },
        }
    }

    if !errors.is_empty() {
        let fmt_err: Vec<_> = errors.into_iter().map(|err| format!("{err}")).collect();
        return Err(anyhow::anyhow!(format!(
            "{} Error(s): {}",
            fmt_err.len(),
            fmt_err.join("\n")
        )));
    }

    // Wait for the Schema to be ready.
    session.await_schema_agreement().await?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    /// The version of the Index DB Schema we SHOULD BE using.
    /// DO NOT change this unless you are intentionally changing the Schema.
    ///
    /// This constant is ONLY used by Unit tests to identify when the schema version will
    /// change accidentally, and is NOT to be used directly to set the schema version of
    /// the table namespaces.
    const SCHEMA_VERSION: &str = "75ae6ac9-ddd8-8472-8a7a-8676d04f8679";

    #[test]
    /// This test is designed to fail if the schema version has changed.
    /// It is used to help detect inadvertent schema version changes.
    /// If you did NOT intend to change the index db schema and this test fails,
    /// then revert or fix your changes to the schema files.
    fn check_schema_version_has_not_changed() {
        let calculated_version = generate_cql_schema_version();
        assert_eq!(SCHEMA_VERSION, calculated_version);
    }

    #[test]
    fn test_no_comments() {
        let input = "SELECT * FROM table1;";
        let expected_output = "SELECT * FROM table1;";
        assert_eq!(remove_comments_and_join_query_lines(input), expected_output);
    }

    #[test]
    fn test_single_line_comment() {
        let input = "SELECT -- some comment * FROM table1;";
        let expected_output = "SELECT";
        assert_eq!(remove_comments_and_join_query_lines(input), expected_output);
    }

    #[test]
    fn test_multi_line_comment() {
        let input = "SELECT -- some comment\n* FROM table1;";
        let expected_output = "SELECT\n* FROM table1;";
        assert_eq!(remove_comments_and_join_query_lines(input), expected_output);
    }

    #[test]
    fn test_multiple_lines() {
        let input = "SELECT * FROM table1;\n-- another comment\nSELECT * FROM table2;";
        let expected_output = "SELECT * FROM table1;\nSELECT * FROM table2;";
        assert_eq!(remove_comments_and_join_query_lines(input), expected_output);
    }

    #[test]
    fn test_empty_lines() {
        let input = "\n\nSELECT * FROM table1;\n-- comment here\n\n";
        let expected_output = "SELECT * FROM table1;";
        assert_eq!(remove_comments_and_join_query_lines(input), expected_output);
    }

    #[test]
    fn test_whitespace_only() {
        let input = "   \n  -- comment here\n   ";
        let expected_output = "";
        assert_eq!(remove_comments_and_join_query_lines(input), expected_output);
    }
}
