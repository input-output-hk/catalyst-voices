//! A `IdUri` wrapper that can be stored to and load from a database.

use catalyst_types::id_uri::IdUri;
use scylla::_macro_internal::{
    CellWriter, ColumnType, DeserializationError, DeserializeValue, FrameSlice, SerializationError,
    SerializeValue, TypeCheckError, WrittenCellProof,
};

/// A `IdUri` wrapper that can be stored to and load from a database.
#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Hash)]
pub struct DbCatalystId(IdUri);

impl From<IdUri> for DbCatalystId {
    fn from(value: IdUri) -> Self {
        Self(value)
    }
}

impl From<DbCatalystId> for IdUri {
    fn from(value: DbCatalystId) -> Self {
        value.0
    }
}

impl SerializeValue for DbCatalystId {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        self.0.as_short_id().to_string().serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbCatalystId {
    fn type_check(typ: &ColumnType) -> Result<(), TypeCheckError> {
        String::type_check(typ)
    }

    fn deserialize(
        typ: &'metadata ColumnType<'metadata>, v: Option<FrameSlice<'frame>>,
    ) -> Result<Self, DeserializationError> {
        let id = String::deserialize(typ, v)?;
        let id: IdUri = id.parse().map_err(DeserializationError::new)?;
        Ok(Self(id))
    }
}
