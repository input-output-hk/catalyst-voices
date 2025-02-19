//! A binary `CIP-19` stack address (29  bytes) that can be stored to and load from a
//! database.

use std::fmt::{Debug, Display, Formatter};

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

/// A length in bytes of the address.
const ADDRESS_LENGTH: usize = 29;

/// A binary `CIP-19` stack address (29  bytes) that can be stored to and load from a
/// database.
#[allow(clippy::module_name_repetitions)]
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct DbStakeAddress(Vec<u8>);

impl From<StakeAddress> for DbStakeAddress {
    fn from(value: StakeAddress) -> Self {
        // This `to_vec()` call includes both the header and the payload.
        Self(value.to_vec())
    }
}

impl From<DbStakeAddress> for Vec<u8> {
    fn from(value: DbStakeAddress) -> Self {
        value.0
    }
}

impl AsRef<[u8]> for DbStakeAddress {
    fn as_ref(&self) -> &[u8] {
        self.0.as_ref()
    }
}

impl SerializeValue for DbStakeAddress {
    fn serialize<'b>(
        &self, typ: &ColumnType, writer: CellWriter<'b>,
    ) -> Result<WrittenCellProof<'b>, SerializationError> {
        self.0.serialize(typ, writer)
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
        if bytes.len() != ADDRESS_LENGTH {
            return Err(DeserializationError::new(InvalidLength {
                length: bytes.len(),
            }));
        }
        Ok(Self(bytes))
    }
}

/// An invalid length error for `DbCip19StakeAddress` deserialization.
#[derive(Debug)]
struct InvalidLength {
    /// An incorrect actual length value.
    length: usize,
}

impl Display for InvalidLength {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "Unexpected length {}, expected {ADDRESS_LENGTH}",
            self.length
        )
    }
}

impl std::error::Error for InvalidLength {}
