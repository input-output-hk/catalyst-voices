//! Simple array types implementor.

/// Macro to make creating validated and documented array types much easier.
///
/// ## Parameters
///
/// * `$ty` - The Type name to create. Example `MyNewType`.
/// * `$type_name` - The `OpenAPI` name for the type. Almost always going to be `string`.
/// * `$item_ty` - The Type name of the item inside this Type.
/// * `$schema` - A Poem `MetaSchema` which defines all the schema parameters for the
///   type.
/// * `$validation` - *OPTIONAL* Validation function to apply to the string value.
macro_rules! impl_array_types {
    ($(#[$docs:meta])* $ty:ident, $item_ty:ident, $schema:expr) => {
        impl_array_types!($(#[$docs])* $ty, $item_ty, $schema, |_| true);
    };

    ($(#[$docs:meta])* $ty:ident, $item_ty:ident, $schema:expr, $validator:expr) => {
        $(#[$docs])*
        #[derive(Debug, Default, Clone)]
        pub(crate) struct $ty(Vec<$item_ty>);

        impl From<Vec<$item_ty>> for $ty {
            fn from(value: Vec<$item_ty>) -> Self {
                Self(value)
            }
        }

        impl std::ops::Deref for $ty {
            type Target = Vec<$item_ty>;

            fn deref(&self) -> &Self::Target {
                &self.0
            }
        }

        impl std::ops::DerefMut for $ty {
            fn deref_mut(&mut self) -> &mut Self::Target {
                &mut self.0
            }
        }

        impl poem_openapi::types::Type for $ty {
            const IS_REQUIRED: bool = true;

            type RawValueType = Self;

            type RawElementValueType = Self;

            fn name() -> std::borrow::Cow<'static, str> {
                format!("{}", stringify!($ty)).into()
            }

            fn schema_ref() -> poem_openapi::registry::MetaSchemaRef {
                let schema_ref = poem_openapi::registry::MetaSchemaRef::Inline(Box::new(poem_openapi::registry::MetaSchema::new("array")));
                if let Some(schema) = $schema {
                    schema_ref.merge(schema)
                } else {
                    schema_ref
                }
            }

            fn as_raw_value(&self) -> Option<&Self::RawValueType> {
                Some(self)
            }

            fn register(registry: &mut poem_openapi::registry::Registry) {
                // note: to prevent `item_ty` from not being attached to the schema.
                $item_ty::register(registry);
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

        impl poem_openapi::types::ParseFromJSON for $ty {
            fn parse_from_json(value: Option<serde_json::Value>) -> poem_openapi::types::ParseResult<Self> {
                Ok(Self(
                    Vec::parse_from_json(value).map_err(|e| poem_openapi::types::ParseError::custom(e.into_message()))?,
                ))
            }
        }

        impl poem_openapi::types::ToJSON for $ty {
            fn to_json(&self) -> Option<serde_json::Value> {
                Some(serde_json::Value::Array(
                    self.0
                        .iter()
                        .map(poem_openapi::types::ToJSON::to_json)
                        .filter_map(|v| v)
                        .collect(),
                ))
            }
        }
    };
}
pub(crate) use impl_array_types;
