//! A binary `CIP-19` stack address (29  bytes) that can be stored to and load from a
//! database.

use pallas::ledger::addresses::StakeAddress;
use scylla::{
    deserialize::{DeserializationError, DeserializeValue, FrameSlice, TypeCheckError},
    frame::response::result::ColumnType,
    serialize::{
        value::SerializeValue,
        writers::{CellWriter, WrittenCellProof},
        SerializationError,
    },
};

/// A binary `CIP-19` stack address (29  bytes) that can be stored to and load from a
/// database.
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct DbCip19StakeAddress(Vec<u8>);

impl From<StakeAddress> for DbCip19StakeAddress {
    fn from(value: StakeAddress) -> Self {
        Self(value.to_vec())
    }
}

impl From<DbCip19StakeAddress> for Vec<u8> {
    fn from(value: DbCip19StakeAddress) -> Self {
        value.0
    }
}

impl SerializeValue for DbCip19StakeAddress {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        self.0.serialize(typ, writer)
    }
}

impl<'frame, 'metadata> DeserializeValue<'frame, 'metadata> for DbCip19StakeAddress {
    fn type_check(typ: &ColumnType) -> Result<(), TypeCheckError> {
        <Vec<u8>>::type_check(typ)
    }

    fn deserialize(
        typ: &'metadata ColumnType<'metadata>, v: Option<FrameSlice<'frame>>,
    ) -> Result<Self, DeserializationError> {
        const EXPECTED_LENGTH: usize = 20;

        let bytes = <Vec<u8>>::deserialize(typ, v)?;
        if bytes.len() != EXPECTED_LENGTH {
            return Err(DeserializationError::new(format!(
                "Unexpected length {}, expected {EXPECTED_LENGTH}",
                bytes.len()
            )));
        }
        Ok(Self(bytes))
    }
}
