//! Verify registration TXs

use std::error::Error;

/// Cddl schema:
/// <https://cips.cardano.org/cips/cip36/schema.cddl>
pub struct CddlConfig {
    pub spec_cip36: String,
}

impl CddlConfig {
    #[must_use]
    pub fn new() -> Self {
        let cddl_36: String = include_str!("cip36.cddl").to_string();

        CddlConfig {
            spec_cip36: cddl_36,
        }
    }
}

impl Default for CddlConfig {
    fn default() -> Self {
        Self::new()
    }
}

/// Validate raw registration binary against 61284+61825 CDDL spec
///
/// # Errors
///
/// Failure will occur if parsed keys do not match CDDL spec
pub fn validate_reg_cddl(bin_reg: &[u8], cddl_config: &CddlConfig) -> Result<(), Box<dyn Error>> {
    cddl::validate_cbor_from_slice(&cddl_config.spec_cip36, bin_reg, None)?;

    Ok(())
}
