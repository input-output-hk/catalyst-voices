//! Simple array types implementor.

/// Macro to make creating validated and documented array types much easier.
///
/// ## Parameters
///
/// * `$ty` - The Type name to create. Example `MyNewType`.
/// * `$type_name` - The `OpenAPI` name for the type. Almost always going to be `string`.
/// * `$item_type` - The Type name of the item inside this Type.
/// * `$schema` - A Poem `MetaSchema` which defines all the schema parameters for the
///   type.
/// * `$validation` - *OPTIONAL* Validation function to apply to the string value.
macro_rules! impl_array_types {
    ($(#[$docs:meta])* $ty:ident, $item_type:ident, $schema:expr) => {
        impl_array_types!($(#[$docs])* $ty, $item_type, $schema, |_| true);
    };

    ($(#[$docs:meta])* $ty:ident, $item_type:ident, $schema:expr, $validator:expr) => {
        $(#[$docs])*
        #[derive(Debug, Default, Clone)]
        pub(crate) struct $ty(Vec<$item_type>);

        impl From<Vec<$item_type>> for $ty {
            fn from(value: Vec<ErrorMessage>) -> Self {
                Self(value)
            }
        }

        impl Type for $ty {
            const IS_REQUIRED: bool = true;

            type RawValueType = Self;

            type RawElementValueType = Self;

            fn name() -> std::borrow::Cow<'static, str> {
                format!("{}", stringify!($ty)).into()
            }

            fn schema_ref() -> MetaSchemaRef {
                let schema_ref = MetaSchemaRef::Inline(Box::new(MetaSchema::new("array")));
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
            fn parse_from_json(value: Option<serde_json::Value>) -> ParseResult<Self> {
                Ok(Self(
                    Vec::parse_from_json(value).map_err(|e| ParseError::custom(e.into_message()))?,
                ))
            }
        }

        impl ToJSON for $ty {
            fn to_json(&self) -> Option<serde_json::Value> {
                Some(serde_json::Value::Array(
                    self.0
                        .iter()
                        .map(ToJSON::to_json)
                        .filter_map(|v| v)
                        .collect(),
                ))
            }
        }
    };
}
pub(crate) use impl_array_types;
