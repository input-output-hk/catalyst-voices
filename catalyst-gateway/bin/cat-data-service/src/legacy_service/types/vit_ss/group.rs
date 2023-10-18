use super::super::SerdeType;
use event_db::types::vit_ss::group::Group;
use serde::{ser::Serializer, Serialize};

impl Serialize for SerdeType<&Group> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct GroupSerde<'a> {
            fund_id: i32,
            token_identifier: &'a String,
            group_id: &'a String,
        }
        GroupSerde {
            fund_id: self.fund_id,
            token_identifier: &self.token_identifier,
            group_id: &self.group_id,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<Group> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn group_json_test() {
        let group = SerdeType(Group {
            fund_id: 1,
            token_identifier: "token_identifier 1".to_string(),
            group_id: "group_id 1".to_string(),
        });

        let json = serde_json::to_value(group).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "fund_id": 1,
                    "token_identifier": "token_identifier 1",
                    "group_id": "group_id 1"
                }
            )
        );
    }
}
