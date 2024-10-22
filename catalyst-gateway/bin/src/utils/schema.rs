//! Utility functions for JSON schema processing

use std::sync::LazyLock;

use serde_json::{json, Value};

use crate::service::api_spec;

/// JSON schema version
pub(crate) const SCHEMA_VERSION: &str = "https://json-schema.org/draft/2020-12/schema";

/// Get the `OpenAPI` specification
pub(crate) static OPENAPI_SPEC: LazyLock<Value> = LazyLock::new(api_spec);

/// Extract a JSON schema from `schema_name`
pub(crate) fn extract_json_schema_for(schema_name: &str) -> Value {
    let schema = OPENAPI_SPEC
        .get("components")
        .and_then(|components| components.get("schemas"))
        .and_then(|schemas| schemas.get(schema_name))
        .cloned()
        .unwrap_or_default();

    // JSON schema not found, return an empty JSON object
    if schema.is_null() {
        return json!({});
    }
    update_refs(&schema, &OPENAPI_SPEC)
}

/// Function to resolve a `$ref` in the JSON schema
pub(crate) fn update_refs(example: &Value, base: &Value) -> Value {
    /// Return the new JSON with modified $refs.
    /// and the original values of the $refs
    fn traverse_and_update(example: &Value) -> (Value, Vec<String>) {
        if let Value::Object(map) = example {
            let mut new_map = serde_json::Map::new();
            let mut original_refs = Vec::new();

            for (key, value) in map {
                match key.as_str() {
                    "allOf" | "anyOf" | "oneOf" => {
                        // Iterate over the array and update each item
                        if let Value::Array(arr) = value {
                            let new_array: Vec<Value> = arr
                                .iter()
                                .map(|item| {
                                    let (updated_item, refs) = traverse_and_update(item);
                                    original_refs.extend(refs);
                                    updated_item
                                })
                                .collect();
                            new_map.insert(key.to_string(), Value::Array(new_array));
                        }
                    },
                    "$ref" => {
                        // Modify the ref value to a new path, which is
                        // "#/definitions/{schema_name}"
                        if let Value::String(ref ref_str) = value {
                            let original_ref = ref_str.clone();
                            let parts: Vec<&str> = ref_str.split('/').collect();
                            if let Some(schema_name) = parts.last() {
                                let new_ref = format!("#/definitions/{schema_name}");
                                new_map.insert(key.to_string(), json!(new_ref));
                                original_refs.push(original_ref);
                            }
                        }
                    },
                    _ => {
                        let (updated_value, refs) = traverse_and_update(value);
                        new_map.insert(key.to_string(), updated_value);
                        original_refs.extend(refs);
                    },
                }
            }

            (Value::Object(new_map), original_refs)
        } else {
            (example.clone(), Vec::new())
        }
    }

    let (updated_schema, references) = traverse_and_update(example);
    // Create new JSON to hold the definitions
    let mut definitions = json!({"definitions": {}});

    // Traverse the references and retrieve the values
    for r in references {
        let path = extract_ref(&r);
        if let Some(value) = get_nested_value(base, &path) {
            if let Some(obj) = value.as_object() {
                for (key, val) in obj {
                    if let Some(definitions_obj) = definitions
                        .get_mut("definitions")
                        .and_then(|v| v.as_object_mut())
                    {
                        // Insert the key-value pair into the definitions object
                        definitions_obj.insert(key.clone(), val.clone());
                    }
                }
            }
        }
    }

    // Add schema version
    let j = merge_json(&updated_schema, &json!( { "$schema": SCHEMA_VERSION } ));
    // Merge the definitions with the updated schema
    json!(merge_json(&j, &definitions))
}

/// Merge 2 JSON objects.
fn merge_json(json1: &Value, json2: &Value) -> Value {
    let mut merged = json1.as_object().cloned().unwrap_or_default();

    if let Some(obj2) = json2.as_object() {
        for (key, value) in obj2 {
            // Insert or overwrite the definitions
            merged.insert(key.clone(), value.clone());
        }
    }

    Value::Object(merged)
}

/// Get the nested value from a JSON object.
fn get_nested_value(base: &Value, path: &[String]) -> Option<Value> {
    let mut current_value = base;

    for segment in path {
        current_value = match current_value {
            Value::Object(ref obj) => {
                // If this is the last segment, return the key-value as a JSON object
                if segment == path.last().unwrap_or(&String::new()) {
                    return obj.get(segment).map(|v| json!({ segment: v }));
                }
                // Move to the next nested value
                obj.get(segment)?
            },
            _ => return None,
        };
    }

    None
}

/// Extract the reference parts from a $ref string
fn extract_ref(ref_str: &str) -> Vec<String> {
    ref_str
        .split('/')
        .filter_map(|part| {
            match part.trim() {
                "" | "#" => None,
                trimmed => Some(trimmed.to_string()),
            }
        })
        .collect()
}

#[cfg(test)]
mod test {
    use serde_json::{json, Value};

    use crate::utils::schema::{extract_json_schema_for, update_refs};

    #[test]
    fn test_update_refs() {
        let base_json: Value = json!({
            "components": {
                "schemas": {
                    "Example": {
                        "type": "object",
                        "properties": {
                            "data": {
                                "allOf": [
                                    {
                                        "$ref": "#/components/schemas/Props"
                                    }
                                ]
                            }
                        },
                        "required": ["data"],
                        "description": "Example schema"
                    },
                    "Props": {
                        "type": "object",
                        "properties": {
                            "prop1": {
                                "type": "string",
                                "description": "Property 1"
                            },
                            "prop2": {
                                "type": "string",
                                "description": "Property 2"
                            },
                            "prop3": {
                                "type": "string",
                                "description": "Property 3"
                            }
                        },
                        "required": ["prop1"]
                    }
                }
            }
        });

        let example_json: Value = json!({
            "type": "object",
            "properties": {
                "data": {
                    "allOf": [
                        {
                            "$ref": "#/components/schemas/Props"
                        }
                    ]
                }
            },
            "required": ["data"],
            "description": "Example schema"

        });

        let schema = update_refs(&example_json, &base_json);
        assert!(schema.get("definitions").unwrap().get("Props").is_some());
    }

    #[test]
    fn test_extract_json_schema_for_frontend_config() {
        let schema = extract_json_schema_for("FrontendConfig");
        println!("{schema}");
        assert!(schema.get("type").is_some());
        assert!(schema.get("properties").is_some());
        assert!(schema.get("description").is_some());
        assert!(schema.get("definitions").is_some());
        assert!(schema.get("$schema").is_some());
    }

    #[test]
    fn test_extract_json_schema_for_frontend_config_no_data() {
        let schema = extract_json_schema_for("test");
        assert!(schema.is_object());
    }
}
