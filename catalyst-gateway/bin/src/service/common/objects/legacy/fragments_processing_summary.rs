//! Define information about fragments that were processed.

use poem_openapi::{types::Example, Enum, NewType, Object};

#[derive(NewType)]
#[oai(example = true)]
/// Unique ID of a fragment.
///
/// A fragment is the binary representation of a signed transaction.
/// The fragment ID is the hex-encoded representation of 32 bytes.
pub(crate) struct FragmentId(String);

impl Example for FragmentId {
    fn example() -> Self {
        Self("0x7db6f91f3c92c0aef7b3dd497e9ea275229d2ab4dba6a1b30ce6b32db9c9c3b2".into())
    }
}

#[derive(Enum)]
/// The reason for which a fragment was rejected.
pub(crate) enum ReasonRejected {
    /// This fragment was already processed by the node.
    FragmentAlreadyInLog,
    /// This fragment failed validation.
    FragmentInvalid,
    /// One of the previous fragments was rejected and `fail_fast` is enabled.
    PreviousFragmentInvalid,
    /// One of the mempools rejected this fragment due to reaching capacity limit.
    PoolOverflow,
}

#[derive(Object)]
#[oai(example = true)]
/// Information about a rejected fragment.
pub(crate) struct RejectedFragment {
    #[oai(rename = "id")]
    #[oai(validator(max_length = 66, min_length = 66, pattern = "0x[0-9a-f]{64}"))]
    /// The ID of the rejected fragment.
    ///
    /// Currently, the hex encoded bytes that represent the fragment ID. In the
    /// future, this might change to including the prefix "0x".
    fragment_id: FragmentId,
    /// The number of the pool that caused this error.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    pool_number: usize,
    /// The reason why this fragment was rejected.
    reason: ReasonRejected,
}

impl Example for RejectedFragment {
    fn example() -> Self {
        Self {
            fragment_id: FragmentId::example(),
            pool_number: 1,
            reason: ReasonRejected::FragmentAlreadyInLog,
        }
    }
}

#[derive(Object, Default)]
#[oai(example = true)]
/// Information about whether a message was accepted or rejected.
pub(crate) struct FragmentsProcessingSummary {
    /// IDs of accepted fragments.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    // Pattern: hex
    #[oai(validator(
        max_items = "100",
        max_length = 66,
        min_length = 66,
        pattern = "0x[0-9a-f]{64}"
    ))]
    accepted: Vec<FragmentId>,
    /// Detailed information about rejected fragments.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(max_items = "100"))]
    rejected: Vec<RejectedFragment>,
}

impl Example for FragmentsProcessingSummary {
    fn example() -> Self {
        Self {
            accepted: vec![FragmentId::example()],
            rejected: vec![RejectedFragment::example()],
        }
    }
}
