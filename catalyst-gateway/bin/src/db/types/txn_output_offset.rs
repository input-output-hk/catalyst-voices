//! A `TxnOutputOffset` wrapper that can be stored to and load from a database.

use cardano_blockchain_types::TxnOutputOffset;
use scylla::_macro_internal::{
    CellWriter, ColumnType, DeserializationError, DeserializeValue, FrameSlice, SerializationError,
    SerializeValue, TypeCheckError, WrittenCellProof,
};

/// A `TxnOutputOffset` wrapper that can be stored to and load from a database.
#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct DbTxnOutputOffset(i16);

impl From<TxnOutputOffset> for DbTxnOutputOffset {
    fn from(value: TxnOutputOffset) -> Self {
        Self(value.into())
    }
}

impl From<i16> for DbTxnOutputOffset {
    fn from(value: i16) -> Self {
        Self(value)
    }
}

impl From<DbTxnOutputOffset> for TxnOutputOffset {
    fn from(value: DbTxnOutputOffset) -> Self {
        value.0.into()
    }
}

impl From<DbTxnOutputOffset> for i16 {
    fn from(value: DbTxnOutputOffset) -> Self {
        value.0
    }
}

impl SerializeValue for DbTxnOutputOffset {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        self.0.serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbTxnOutputOffset {
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
