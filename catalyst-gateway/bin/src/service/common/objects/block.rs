//! Defines API schemas of block related types.

use poem_openapi::{types::Example, NewType, Object};

#[derive(NewType)]
/// Epoch number.
pub(crate) struct Epoch(pub u32);

#[derive(NewType)]
/// Slot number.
pub(crate) struct Slot(pub u32);

#[derive(Object)]
#[oai(example = true)]
/// Block time defined as the pair (epoch, slot).
pub(crate) struct BlockDate {
    /// Block's epoch.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    pub epoch: Epoch,
    /// Block's slot number.
    // TODO(bkioshn): https://github.com/input-output-hk/catalyst-voices/issues/239
    #[oai(validator(minimum(value = "0"), maximum(value = "4294967295")))]
    pub slot_id: Slot,
}

impl Example for BlockDate {
    fn example() -> Self {
        Self {
            epoch: Epoch(1),
            slot_id: Slot(5),
        }
    }
}
