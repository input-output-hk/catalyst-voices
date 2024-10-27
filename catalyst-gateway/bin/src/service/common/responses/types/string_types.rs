//! Simple string types.
//!
//! This code comes from Poem, but it is not exported by Poem, so replicated here.
//!
//! Original Source: <https://raw.githubusercontent.com/poem-web/poem/refs/heads/master/poem-openapi/src/types/string_types.rs>
use std::{
    borrow::Cow,
    ops::{Deref, DerefMut},
};

use poem_openapi::{
    registry::{MetaSchema, MetaSchemaRef},
    types::{ParseError, ParseFromJSON, ParseFromParameter, ParseResult, ToJSON, Type},
};
use serde_json::Value;

/// Macro to make creating validated and documented string types much easier.
macro_rules! impl_string_types {
    ($(#[$docs:meta])* $ty:ident, $type_name:literal, $format:literal, $schema:expr ) => {
        impl_string_types!($(#[$docs])* $ty, $type_name, $format, $schema, |_| true);
    };

    ($(#[$docs:meta])* $ty:ident, $type_name:literal, $format:literal, $schema:expr, $validator:expr) => {
        $(#[$docs])*
        #[derive(Debug, Clone, Eq, PartialEq, Hash)]
        pub struct $ty(pub String);

        impl Deref for $ty {
            type Target = String;

            fn deref(&self) -> &Self::Target {
                &self.0
            }
        }

        impl DerefMut for $ty {
            fn deref_mut(&mut self) -> &mut Self::Target {
                &mut self.0
            }
        }

        impl AsRef<str> for $ty {
            fn as_ref(&self) -> &str {
                &self.0
            }
        }

        impl Type for $ty {
            const IS_REQUIRED: bool = true;

            type RawValueType = Self;

            type RawElementValueType = Self;

            fn name() -> Cow<'static, str> {
                concat!($type_name, "(", $format, ")").into()
            }

            fn schema_ref() -> MetaSchemaRef {
                let schema_ref = MetaSchemaRef::Inline(Box::new(MetaSchema::new_with_format($type_name, $format)));
                if let Some(schema) = $schema {
                    schema_ref.merge(schema)
                } else {
                    schema_ref
                }


                /*
                <RetryAfter as poem_openapi::types::Type>::schema_ref()
                .merge(poem_openapi::registry::MetaSchema {
                    title: ::std::option::Option::Some(
                        ::std::string::ToString::to_string(
                            "Http Date or Interval in seconds.",
                        ),
                    ),
                    description: ::std::option::Option::Some(
                        "Valid formats:\n\n* `Retry-After: <http-date>`\n* `Retry-After: <delay-seconds>`\n\nSee: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Retry-After>",
                    ),
                    external_docs: ::std::option::Option::None,
                    example: {
                        let value = <Self as poem_openapi::types::Example>::example();
                        <Self as poem_openapi::types::ToJSON>::to_json(&value)
                    },
                    ..poem_openapi::registry::MetaSchema::ANY
                })
                */
            }

            fn as_raw_value(&self) -> Option<&Self::RawValueType> {
                Some(self)
            }

            fn raw_element_iter<'a>(
                &'a self,
            ) -> Box<dyn Iterator<Item = &'a Self::RawElementValueType> + 'a> {
                Box::new(self.as_raw_value().into_iter())
            }

            #[inline]
            fn is_empty(&self) -> bool {
                self.0.is_empty()
            }
        }

        impl ParseFromJSON for $ty {
            fn parse_from_json(value: Option<Value>) -> ParseResult<Self> {
                let value = value.unwrap_or_default();
                if let Value::String(value) = value {
                    let validator = $validator;
                    if !validator(&value) {
                        return Err(concat!("invalid ", $format).into());
                    }
                    Ok(Self(value))
                } else {
                    Err(ParseError::expected_type(value))
                }
            }
        }

        impl ParseFromParameter for $ty {
            fn parse_from_parameter(value: &str) -> ParseResult<Self> {
                let validator = $validator;
                if !validator(value) {
                    return Err(concat!("invalid ", $format).into());
                }
                Ok(Self(value.to_string()))
            }
        }

        impl ToJSON for $ty {
            fn to_json(&self) -> Option<Value> {
                Some(Value::String(self.0.clone()))
            }
        }
    };
}

// Note: Docs don't get applied to ExtraHeaders, only headers specifically defined for a
// response/request.

// Access-Control-Allow-Origin Header String Type
impl_string_types!(
    /// Indicates whether the response can be shared with requesting code from the given origin.
    ///
    /// Valid formats:
    ///
    /// * `Access-Control-Allow-Origin: *`
    /// * `Access-Control-Allow-Origin: <origin>`
    /// * `Access-Control-Allow-Origin: null`
    ///
    /// See: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin>
    AccessControlAllowOriginHeader,
    "string",
    "origin",
    Some(MetaSchema {
        title: Some("Access-Control-Allow-Origin Header".to_owned()),
        description: Some("Valid formats:

* `Access-Control-Allow-Origin: *`
* `Access-Control-Allow-Origin: <origin>`
* `Access-Control-Allow-Origin: null`

See: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin>"),
        example: Some(Value::String("*".to_string())),
        ..poem_openapi::registry::MetaSchema::ANY
    })
);

// RateLimit Header String Type
impl_string_types!(
    /// Indicates how the request rate should be limited by the caller.
    ///
    /// See: <https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/>
    /// "\"default\";q=100;w=10"
    RateLimitHeader,
    "string",
    "rate-limit",
    None
);
