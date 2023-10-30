//! Operations on the config table

// NOT Currently Implemented
//
// use chrono::{serde::ts_seconds, DateTime, Utc};
// use serde::{Deserialize, Serialize};
// use std::error::Error;
//
// use crate::ElectionDB;
//
// The configuration key into the `config` table.
// #[allow(unused)]
// #[derive(Default)]
// struct ConfigKey<'a> {
// Primary `id` into the table
// id: &'a str,
// Optional `id2` set to None to match all on lookup.
// id2: Option<&'a str>,
// Optional `id3` set to None to match all on lookup.
// id3: Option<&'a str>,
// }
//
// impl ConfigKey<'_> {
// const API_TOKEN_ID: &str = "api_token";
//
// Create an api_token key for the Config table.
// fn api_token(token: &str) -> ConfigKey {
// ConfigKey {
// id: ConfigKey::API_TOKEN_ID, // Config Key space.
// id2: Some(token),            // Encrypted Token.
// id3: Some(""),               // Not used.
// }
// }
// }
//
// Internal operations which perform general config table operations on the
// database.
//
// Get all config records matching a key.
//
// # Parameters
//
// * `key` - the key to lookup in the config table.  any parts of the key that are `None`
//   are wildcard and will match anything.
//
// # Returns
//
// Will return an iterator over all the found raw config models of the
// database.  Returning the raw config row lets the caller check the `id`
// fields as well as the body.
//
// # Errors
//   * if at least 1 is not found,
//   * Or there is a DB error of some kind.
// fn get_config_records(
// _key: &ConfigKey,
// ) -> Result<impl Iterator<Item = ()>, Box<dyn Error + Send + Sync + 'static>> {
// Query the `config` table for all records matching the key.
//
// If no records are found, return an error.
//
// Return the iterator over the found records.
// Ok(Vec::new().into_iter())
// }
//
// Get a single config record by its key.
//
// # Parameters
//
// * `key` - the key to lookup in the config table.  any parts of the key that are `None`
//   are wildcard and will match anything.
//
// # Returns
//
// Returns the found json record as a `serde_json::Value` type. This needs to
// be further deserialized and checked by the caller.
//
// # Errors
//   * if its not found,
//   * or more than 1 result is found.
//   * Or there is a DB error of some kind.
// fn get_config_record(
// key: &ConfigKey,
// ) -> Result<Option<serde_json::Value>, Box<dyn Error + Send + Sync + 'static>> {
// let _results = get_config_records(key)?;
//
// Check if there is more than one record in the results.
// If there is exactly 1 record in the results, return it.
// Otherwise return the appropriate error.
//
// todo!()
// }
//
// Set a config record for the matching key.
//
// If the key does not exist, it is created.  Otherwise it is updated.
//
// # Parameters
//
// * `key` the Key to set.  Any parts of the key which are `None` become "".
// * `value` the json value to store in the record.
//
// # Returns
//
// Ok()
//
// # Errors
//   * There is a DB error of some kind.
//
// fn set_config_record(
// _key: &ConfigKey,
//     _value: &serde_json::Value,
// ) -> Result<(), Box<dyn Error + Send + Sync + 'static>> { todo!()
// }
//
// Individual Permissions assigned to an authorization.
// #[derive(Serialize, Deserialize)]
// pub(crate) struct Permissions {
// Example permission, at the moment there are no permission categories.
// pub(crate) read: bool,
// }
//
// Individual Authorization assigned to this API Key.
// #[derive(Serialize, Deserialize)]
// pub(crate) struct Authorization {
// Name of the API Token Owner
// pub(crate) name: String,
//
// When the API Token was created.
// #[serde(with = "ts_seconds")]
// pub(crate) created: DateTime<Utc>,
//
// When the API Token expires.
// #[serde(with = "ts_seconds")]
// pub(crate) expires: DateTime<Utc>,
//
// Individual permissions given to the API Token.
// pub(crate) perms: Permissions,
// }
//
// impl ElectionDB {
// Check if an API key is valid, and if it is, return its authorization record.
//
// # Parameters
//
// * `conn` - The Connection to the Election DB.
// * `token` - The API token to check (Should be a UUID String.)
//
// # Returns
//
// The authorization details of the checked API token.
//
// # Errors
// key
// * If the API token is invalid.
// * If the API token has expired.
// * If the Authorization record in the API Token record is malformed.
// * If there is a database connection error.
//
// # Panics
//
// Because its not yet implemented...
//
// # Notes
//
// API Tokens are not stored in the clear in the database, they are encrypted
// with a key supplied by a `TODO` environment variable.  This prevents a DB
// dump from exposing the API keys.
//
// pub(crate) fn check_api_token(
// &self,
// _token: &str,
// ) -> Result<Authorization, Box<dyn Error + Send + Sync + 'static>> {
// Read the encryption key from env var. Error if its not found. (Can cache it)
//
// Encrypt the passed token with the encryption key. Note, this isn't
// salted, but using it as a key requires that no two api tokens can be
// the same anyway.
// let encrypted_token = "todo";
//
// Create the api token key to find the auth record.
// ("api_token",<encrypted api key>, "")
//
// Lookup the record by calling `get_config_record()`
// let _auth = get_config_record(&ConfigKey::api_token(encrypted_token))?;
//
// Deserialize the result into a `Authorization` struct.
//
// And return it.
//
// todo!("Not yet implemented.")
// }
// }
//
