//! Simple string types.
//!
//! This code comes from Poem, but it is not exported by Poem, so replicated here.
//!
//! Original Source: <https://raw.githubusercontent.com/poem-web/poem/refs/heads/master/poem-openapi/src/types/string_types.rs>

/// Macro to make creating validated and documented string types much easier.
///
/// ## Parameters
///
/// * `$ty` - The Type name to create. Example `MyNewType`.
/// * `$type_name` - The `OpenAPI` name for the type. Almost always going to be `string`.
/// * `$format` - The `OpenAPI` format for the type. Where possible use a defined
///   `OpenAPI` or `JsonSchema` format.
/// * `$schema` - A Poem `MetaSchema` which defines all the schema parameters for the
///   type.
/// * `$validation` - *OPTIONAL* Validation function to apply to the string value.
///
///
/// ## Example
///
/// ```ignore
/// impl_string_types!(MyNewType, "string", "date", MyNewTypeSchema, SomeValidationFunction);
/// ```
///
/// Is the equivalent of:
///
/// ```ignore
/// #[derive(Debug, Clone, Eq, PartialEq, Hash)]
/// pub(crate) struct MyNewType(pub String);
///
/// impl <stuff> for MyNewType { ... }
/// ```
macro_rules! impl_string_types {
    ($(#[$docs:meta])* $ty:ident, $type_name:literal, $format:literal, $schema:expr ) => {
        impl_string_types!($(#[$docs])* $ty, $type_name, $format, $schema, |_| true);
    };

    ($(#[$docs:meta])* $ty:ident, $type_name:literal, $format:literal, $schema:expr, $validator:expr) => {
        $(#[$docs])*
        #[derive(Debug, Clone, Eq, PartialEq, Hash)]
        pub(crate) struct $ty(String);

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
pub(crate) use impl_string_types;
