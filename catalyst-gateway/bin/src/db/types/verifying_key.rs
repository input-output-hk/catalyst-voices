//! A `VerifyingKey` wrapper that can be stored to and load from a database.

use ed25519_dalek::{VerifyingKey, PUBLIC_KEY_LENGTH};
use scylla::_macro_internal::{
    CellWriter, ColumnType, DeserializationError, DeserializeValue, FrameSlice, SerializationError,
    SerializeValue, TypeCheckError, WrittenCellProof,
};

/// A `VerifyingKey` wrapper that can be stored to and load from a database.
#[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct DbVerifyingKey([u8; PUBLIC_KEY_LENGTH]);

impl From<VerifyingKey> for DbVerifyingKey {
    fn from(value: VerifyingKey) -> Self {
        Self(value.to_bytes())
    }
}

impl From<DbVerifyingKey> for VerifyingKey {
    fn from(value: DbVerifyingKey) -> Self {
        // This should never fail because the wrapper can only be constructed from the original
        // type and `DeserializeValue` performs validation.
        VerifyingKey::from_bytes(&value.0).expect("Invalid VerifyingKey")
    }
}

impl SerializeValue for DbVerifyingKey {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        self.0.serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbVerifyingKey {
    fn type_check(typ: &ColumnType) -> Result<(), TypeCheckError> {
        <Vec<u8>>::type_check(typ)
    }

    fn deserialize(
        typ: &'metadata ColumnType<'metadata>, v: Option<FrameSlice<'frame>>,
    ) -> Result<Self, DeserializationError> {
        let bytes = <Vec<u8>>::deserialize(typ, v)?;
        let key = VerifyingKey::try_from(bytes.as_slice()).map_err(DeserializationError::new)?;
        Ok(key.into())
    }
}
