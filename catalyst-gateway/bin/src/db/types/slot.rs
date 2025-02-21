//! A `Slot` wrapper that can be stored to and load from a database.

use cardano_blockchain_types::Slot;
use num_bigint::BigInt;
use scylla::_macro_internal::{
    CellWriter, ColumnType, DeserializationError, DeserializeValue, FrameSlice, SerializationError,
    SerializeValue, TypeCheckError, WrittenCellProof,
};

/// A `Slot` wrapper that can be stored to and load from a database.\
#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct DbSlot(u64);

impl From<Slot> for DbSlot {
    fn from(value: Slot) -> Self {
        Self(value.into())
    }
}

impl From<u64> for DbSlot {
    fn from(value: u64) -> Self {
        Self(value)
    }
}

impl From<DbSlot> for u64 {
    fn from(value: DbSlot) -> Self {
        value.0
    }
}

impl From<DbSlot> for Slot {
    fn from(value: DbSlot) -> Self {
        value.0.into()
    }
}

impl From<DbSlot> for BigInt {
    fn from(value: DbSlot) -> Self {
        value.0.into()
    }
}

impl SerializeValue for DbSlot {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        BigInt::from(self.0).serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbSlot {
    fn type_check(typ: &ColumnType) -> Result<(), TypeCheckError> {
        <BigInt>::type_check(typ)
    }

    fn deserialize(
        typ: &'metadata ColumnType<'metadata>, v: Option<FrameSlice<'frame>>,
    ) -> Result<Self, DeserializationError> {
        let value = <BigInt>::deserialize(typ, v)?;
        let value = u64::try_from(value).map_err(DeserializationError::new)?;
        Ok(Self(value))
    }
}
