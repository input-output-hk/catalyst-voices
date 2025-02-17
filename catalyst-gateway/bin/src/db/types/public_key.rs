//! A `VerifyingKey` wrapper that can be stored to and load from a database.

use ed25519_dalek::VerifyingKey;
use scylla::_macro_internal::{
    CellWriter, ColumnType, DeserializationError, DeserializeValue, FrameSlice, SerializationError,
    SerializeValue, TypeCheckError, WrittenCellProof,
};

/// An ed25519 public key (32 bytes) wrapper that can be stored to and load from a
/// database.
#[allow(clippy::module_name_repetitions)]
#[derive(Debug, PartialEq, Eq, Hash)]
pub struct DbPublicKey(VerifyingKey);

impl AsRef<[u8]> for DbPublicKey {
    fn as_ref(&self) -> &[u8] {
        self.0.as_ref()
    }
}

impl From<VerifyingKey> for DbPublicKey {
    fn from(value: VerifyingKey) -> Self {
        Self(value)
    }
}

impl From<DbPublicKey> for VerifyingKey {
    fn from(value: DbPublicKey) -> Self {
        value.0
    }
}

impl SerializeValue for DbPublicKey {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        self.0.as_ref().serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbPublicKey {
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
