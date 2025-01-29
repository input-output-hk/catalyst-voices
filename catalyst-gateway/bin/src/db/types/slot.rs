//! A `Slot` wrapper that can be stored to and load from a database.

use cardano_blockchain_types::Slot;
use scylla::_macro_internal::{
    CellWriter, ColumnType, DeserializationError, DeserializeValue, FrameSlice, SerializationError,
    SerializeValue, TypeCheckError, WrittenCellProof,
};

/// A `Slot` wrapper that can be stored to and load from a database.
#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct DbSlot(u64);

impl From<Slot> for DbSlot {
    fn from(value: Slot) -> Self {
        Self(value.into())
    }
}

impl From<DbSlot> for Slot {
    fn from(value: DbSlot) -> Self {
        value.0.into()
    }
}

impl SerializeValue for DbSlot {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        let value = i64::try_from(self.0).map_err(SerializationError::new)?;
        value.serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbSlot {
    fn type_check(typ: &ColumnType) -> Result<(), TypeCheckError> {
        <i64>::type_check(typ)
    }

    fn deserialize(
        typ: &'metadata ColumnType<'metadata>, v: Option<FrameSlice<'frame>>,
    ) -> Result<Self, DeserializationError> {
        let value = <i64>::deserialize(typ, v)?;
        let value = u64::try_from(value).map_err(DeserializationError::new)?;
        Ok(Self(value))
    }
}
