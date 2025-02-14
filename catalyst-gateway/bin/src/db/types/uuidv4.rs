//! A `UuidV4` wrapper that can be stored to and load from a database.

use catalyst_types::uuid::UuidV4;
use scylla::_macro_internal::{
    CellWriter, ColumnType, DeserializationError, DeserializeValue, FrameSlice, SerializationError,
    SerializeValue, TypeCheckError, WrittenCellProof,
};
use uuid::Uuid;

/// A `UuidV4` wrapper that can be stored to and load from a database.
#[derive(Debug, Copy, Clone, PartialEq, PartialOrd)]
pub struct DbUuidV4(UuidV4);

impl From<UuidV4> for DbUuidV4 {
    fn from(value: UuidV4) -> Self {
        Self(value)
    }
}

impl From<DbUuidV4> for UuidV4 {
    fn from(value: DbUuidV4) -> Self {
        value.0
    }
}

impl SerializeValue for DbUuidV4 {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        self.0.uuid().serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbUuidV4 {
    fn type_check(typ: &ColumnType) -> Result<(), TypeCheckError> {
        <Uuid>::type_check(typ)
    }

    fn deserialize(
        typ: &'metadata ColumnType<'metadata>, v: Option<FrameSlice<'frame>>,
    ) -> Result<Self, DeserializationError> {
        let value = <Uuid>::deserialize(typ, v)?;
        let value = UuidV4::try_from(value).map_err(DeserializationError::new)?;
        Ok(Self(value))
    }
}
