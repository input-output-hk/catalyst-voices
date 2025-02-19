//! A binary `CIP-19` stack address (29  bytes) that can be stored to and load from a
//! database.

use std::fmt::{Debug, Display, Formatter};

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

/// A binary `CIP-19` stack address (29  bytes) that can be stored to and load from a
/// database.
#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Hash)]
pub struct DbStakeAddress(StakeAddress);

impl From<StakeAddress> for DbStakeAddress {
    fn from(value: StakeAddress) -> Self {
        Self(value)
    }
}

impl Display for DbStakeAddress {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl SerializeValue for DbStakeAddress {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        let bytes: Vec<_> = self.0.clone().into();
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
        let address = bytes
            .as_slice()
            .try_into()
            .map_err(|error| DeserializationError::new(DeserializeError { error }))?;
        Ok(Self(address))
    }
}

/// An invalid length error for `DbStakeAddress` deserialization.
#[derive(Debug)]
struct DeserializeError {
    /// An error value.
    error: anyhow::Error,
}

impl Display for DeserializeError {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "Unexpected to deserialize StakeAddress: {:?}",
            self.error
        )
    }
}

impl std::error::Error for DeserializeError {}
