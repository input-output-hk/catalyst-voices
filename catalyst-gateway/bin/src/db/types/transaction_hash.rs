//! A `TransactionHash` hash wrapper that can be stored to and load from a database.

use std::fmt::{Display, Formatter};

use cardano_blockchain_types::TransactionHash;
use scylla::{
    deserialize::{DeserializationError, DeserializeValue, FrameSlice, TypeCheckError},
    frame::response::result::ColumnType,
    serialize::{
        value::SerializeValue,
        writers::{CellWriter, WrittenCellProof},
        SerializationError,
    },
};

/// A `TransactionHash` wrapper that can be stored to and load from a database.
#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct DbTransactionHash(TransactionHash);

impl Display for DbTransactionHash {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        f.write_str(&format!("{}", self.0))
    }
}

impl From<TransactionHash> for DbTransactionHash {
    fn from(value: TransactionHash) -> Self {
        Self(value)
    }
}

impl From<DbTransactionHash> for TransactionHash {
    fn from(value: DbTransactionHash) -> Self {
        value.0
    }
}

impl SerializeValue for DbTransactionHash {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        let bytes: Vec<u8> = self.0.into();
        bytes.serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbTransactionHash {
    fn type_check(typ: &ColumnType) -> Result<(), TypeCheckError> {
        <Vec<u8>>::type_check(typ)
    }

    fn deserialize(
        typ: &'metadata ColumnType<'metadata>, v: Option<FrameSlice<'frame>>,
    ) -> Result<Self, DeserializationError> {
        let bytes = <Vec<u8>>::deserialize(typ, v)?;
        let hash = TransactionHash::try_from(bytes).map_err(DeserializationError::new)?;
        Ok(Self(hash))
    }
}
