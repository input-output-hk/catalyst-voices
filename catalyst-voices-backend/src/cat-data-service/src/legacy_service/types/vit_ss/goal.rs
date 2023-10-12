use super::super::SerdeType;
use event_db::types::vit_ss::goal::Goal;
use serde::{ser::Serializer, Serialize};

impl Serialize for SerdeType<&Goal> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct GoalSerde<'a> {
            id: i32,
            goal_name: &'a String,
            fund_id: i32,
        }
        GoalSerde {
            id: self.id,
            goal_name: &self.goal_name,
            fund_id: self.fund_id,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<Goal> {
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
    fn goal_json_test() {
        let goal = SerdeType(Goal {
            id: 1,
            goal_name: "goal_name 1".to_string(),
            fund_id: 1,
        });

        let json = serde_json::to_value(goal).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": 1,
                    "goal_name": "goal_name 1",
                    "fund_id": 1
                }
            )
        );
    }
}
