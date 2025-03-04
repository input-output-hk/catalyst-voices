//! Cardano Improvement Proposal 509 (CIP-509) API object.
//! Doc Reference: <https://github.com/input-output-hk/catalyst-CIPs/tree/x509-envelope-metadata/CIP-XXXX>
//! CDDL Reference: <https://github.com/input-output-hk/catalyst-CIPs/blob/x509-envelope-metadata/CIP-XXXX/x509-envelope.cddl>

use crate::service::common::types::generic::uuidv4::UUIDv4;

/// CIP 509 registration transaction data.
#[derive(Debug, Clone)]
#[allow(dead_code)]
pub struct Cip509 {
    /// A registration purpose (`UUIDv4`).
    ///
    /// The purpose is defined by the consuming dApp.
    purpose: Option<UUIDv4>,
}
