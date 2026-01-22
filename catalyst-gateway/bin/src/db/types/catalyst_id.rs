//! A `CatalystId` wrapper that can be stored to and load from a database.

use catalyst_types::catalyst_id::CatalystId;
use scylla::_macro_internal::{
    CellWriter, ColumnType, DeserializationError, DeserializeValue, FrameSlice, SerializationError,
    SerializeValue, TypeCheckError, WrittenCellProof,
};

/// A `CatalystId` wrapper that can be stored to and load from a database.
#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Hash)]
pub struct DbCatalystId(CatalystId);

impl From<CatalystId> for DbCatalystId {
    fn from(value: CatalystId) -> Self {
        Self(value)
    }
}

impl From<DbCatalystId> for CatalystId {
    fn from(value: DbCatalystId) -> Self {
        value.0
    }
}

impl SerializeValue for DbCatalystId {
    fn serialize<'b>(
        &self,
        typ: &ColumnType,
        writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        self.0.as_short_id().to_string().serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbCatalystId {
    fn type_check(typ: &ColumnType) -> Result<(), TypeCheckError> {
        String::type_check(typ)
    }

    fn deserialize(
        typ: &'metadata ColumnType<'metadata>,
        v: Option<FrameSlice<'frame>>,
    ) -> Result<Self, DeserializationError> {
        let id = String::deserialize(typ, v)?;

        let id: CatalystId = id.parse().map_err(|e| {
            tracing::error!(e = ?e, id=id, "Cannot parse catalyst id");
            DeserializationError::new(e)
        })?;
        Ok(Self(id))
    }
}
