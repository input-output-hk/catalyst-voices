//! A `UuidV7` wrapper that can be stored to and load from a database.

use catalyst_types::uuid::UuidV7;
use scylla::_macro_internal::{
    CellWriter, ColumnType, DeserializationError, DeserializeValue, FrameSlice, SerializationError,
    SerializeValue, TypeCheckError, WrittenCellProof,
};
use uuid::Uuid;

/// A `UuidV7` wrapper that can be stored to and load from a database.
#[derive(Debug, Copy, Clone, PartialEq, PartialOrd)]
pub struct DbUuidV7(UuidV7);

impl From<UuidV7> for DbUuidV7 {
    fn from(value: UuidV7) -> Self {
        Self(value)
    }
}

impl From<DbUuidV7> for UuidV7 {
    fn from(value: DbUuidV7) -> Self {
        value.0
    }
}

impl SerializeValue for DbUuidV7 {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        self.0.uuid().serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbUuidV7 {
    fn type_check(typ: &ColumnType) -> Result<(), TypeCheckError> {
        <Uuid>::type_check(typ)
    }

    fn deserialize(
        typ: &'metadata ColumnType<'metadata>, v: Option<FrameSlice<'frame>>,
    ) -> Result<Self, DeserializationError> {
        let value = <Uuid>::deserialize(typ, v)?;
        let value = UuidV7::try_from(value).map_err(DeserializationError::new)?;
        Ok(Self(value))
    }
}
