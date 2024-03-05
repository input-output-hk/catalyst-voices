//! Block stream parsing and filtering utils

use pallas::ledger::traverse::Era;

/// Eras before staking should be ignored
pub fn valid_era(era: Era) -> bool {
    match era {
        Era::Byron => false,
        Era::Shelley => true,
        Era::Allegra => true,
        Era::Mary => true,
        Era::Alonzo => true,
        Era::Babbage => true,
        Era::Conway => true,
        _ => false,
    }
}
