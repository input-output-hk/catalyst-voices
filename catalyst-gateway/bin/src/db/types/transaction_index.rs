//! A `TxnIndex` wrapper that can be stored to and load from a database.

use cardano_blockchain_types::TxnIndex;
use scylla::_macro_internal::{
    CellWriter, ColumnType, DeserializationError, DeserializeValue, FrameSlice, SerializationError,
    SerializeValue, TypeCheckError, WrittenCellProof,
};

/// A `TxnIndex` wrapper that can be stored to and load from a database.
#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct DbTxnIndex(i16);

impl From<TxnIndex> for DbTxnIndex {
    fn from(value: TxnIndex) -> Self {
        Self(value.into())
    }
}

impl From<DbTxnIndex> for TxnIndex {
    fn from(value: DbTxnIndex) -> Self {
        value.0.into()
    }
}

impl From<DbTxnIndex> for i16 {
    fn from(value: DbTxnIndex) -> Self {
        value.0
    }
}

impl SerializeValue for DbTxnIndex {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        self.0.serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbTxnIndex {
    fn type_check(typ: &ColumnType) -> Result<(), TypeCheckError> {
        <i16>::type_check(typ)
    }

    fn deserialize(
        typ: &'metadata ColumnType<'metadata>, v: Option<FrameSlice<'frame>>,
    ) -> Result<Self, DeserializationError> {
        let value = <i16>::deserialize(typ, v)?;
        Ok(Self(value))
    }
}
