//! A Catalyst short identifier.

use std::borrow::Cow;

use catalyst_types::id_uri::IdUri;
use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{ParseFromParameter, ParseResult, Type},
};

/// A Catalyst short identifier.
#[derive(Debug, Clone, PartialEq, Hash)]
pub(crate) struct CatalystId(IdUri);

impl Type for CatalystId {
    type RawElementValueType = IdUri;
    type RawValueType = IdUri;

    const IS_REQUIRED: bool = true;

    fn name() -> Cow<'static, str> {
        "string(<network>/<public key>)".into()
    }

    fn schema_ref() -> MetaSchemaRef {
        let schema = MetaSchema {
            title: Some("Catalyst short ID".into()),
            description: Some("Catalyst short identifier in string format".into()),
            example: Some("cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE".into()),
            ..MetaSchema::ANY
        };
        MetaSchemaRef::Inline(Box::new(schema))
    }

    fn as_raw_value(&self) -> Option<&Self::RawValueType> {
        Some(&self.0)
    }

    fn raw_element_iter<'a>(
        &'a self,
    ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
        Box::new(self.as_raw_value().into_iter())
    }
}

impl From<IdUri> for CatalystId {
    fn from(value: IdUri) -> Self {
        Self(value.as_short_id())
    }
}

impl From<CatalystId> for IdUri {
    fn from(value: CatalystId) -> Self {
        value.0
    }
}

impl ParseFromParameter for CatalystId {
    fn parse_from_parameter(value: &str) -> ParseResult<Self> {
        let id: IdUri = match value.parse() {
            Ok(v) => v,
            Err(e) => return Err(format!("Invalid Catalyst ID: {e:?}").into()),
        };
        Ok(Self(id.as_short_id()))
    }
}
