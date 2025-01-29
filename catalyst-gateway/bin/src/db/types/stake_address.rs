//! A `StakeAddress` hash wrapper that can be stored to and load from a database.

use cardano_blockchain_types::StakeAddress;
use scylla::{
    deserialize::{DeserializationError, DeserializeValue, FrameSlice, TypeCheckError},
    frame::response::result::ColumnType,
    serialize::{
        value::SerializeValue,
        writers::{CellWriter, WrittenCellProof},
        SerializationError,
    },
};

/// A `StakeAddress` wrapper that can be stored to and load from a database.
#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct DbStakeAddress(StakeAddress);

impl From<StakeAddress> for DbStakeAddress {
    fn from(value: StakeAddress) -> Self {
        Self(value)
    }
}

impl From<DbStakeAddress> for StakeAddress {
    fn from(value: DbStakeAddress) -> Self {
        value.0
    }
}

impl SerializeValue for DbStakeAddress {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        let bytes: Vec<u8> = self.0.into();
        bytes.serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbStakeAddress {
    fn type_check(typ: &ColumnType) -> Result<(), TypeCheckError> {
        <Vec<u8>>::type_check(typ)
    }

    fn deserialize(
        typ: &'metadata ColumnType<'metadata>, v: Option<FrameSlice<'frame>>,
    ) -> Result<Self, DeserializationError> {
        let bytes = <Vec<u8>>::deserialize(typ, v)?;
        let hash = StakeAddress::try_from(bytes).map_err(DeserializationError::new)?;
        Ok(Self(hash))
    }
}
