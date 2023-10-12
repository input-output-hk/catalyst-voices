use super::super::{serialize_datetime_as_rfc3339, SerdeType};
use chrono::{DateTime, Utc};
use event_db::types::vit_ss::{
    challenge::Challenge,
    fund::{Fund, FundNextInfo, FundStageDates, FundWithNext},
    goal::Goal,
    group::Group,
    vote_plan::Voteplan,
};
use serde::{ser::Serializer, Serialize};

impl Serialize for SerdeType<&FundStageDates> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct FundStageDatesSerde<'a> {
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            insight_sharing_start: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            proposal_submission_start: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            refine_proposals_start: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            finalize_proposals_start: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            proposal_assessment_start: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            assessment_qa_start: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            snapshot_start: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            voting_start: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            voting_end: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            tallying_end: &'a DateTime<Utc>,
        }
        FundStageDatesSerde {
            insight_sharing_start: &self.insight_sharing_start,
            proposal_submission_start: &self.proposal_submission_start,
            refine_proposals_start: &self.refine_proposals_start,
            finalize_proposals_start: &self.finalize_proposals_start,
            proposal_assessment_start: &self.proposal_assessment_start,
            assessment_qa_start: &self.assessment_qa_start,
            snapshot_start: &self.snapshot_start,
            voting_start: &self.voting_start,
            voting_end: &self.voting_end,
            tallying_end: &self.tallying_end,
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<FundStageDates> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&Fund> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct FundSerde<'a> {
            id: i32,
            fund_name: &'a String,
            fund_goal: &'a String,
            voting_power_threshold: i64,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            fund_start_time: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            fund_end_time: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            next_fund_start_time: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            registration_snapshot_time: &'a DateTime<Utc>,
            #[serde(serialize_with = "serialize_datetime_as_rfc3339")]
            next_registration_snapshot_time: &'a DateTime<Utc>,
            chain_vote_plans: Vec<SerdeType<&'a Voteplan>>,
            challenges: Vec<SerdeType<&'a Challenge>>,
            #[serde(flatten)]
            stage_dates: SerdeType<&'a FundStageDates>,
            goals: Vec<SerdeType<&'a Goal>>,
            results_url: &'a String,
            survey_url: &'a String,
            groups: Vec<SerdeType<&'a Group>>,
        }
        FundSerde {
            id: self.id,
            fund_name: &self.fund_name,
            fund_goal: &self.fund_goal,
            voting_power_threshold: self.voting_power_threshold,
            fund_start_time: &self.fund_start_time,
            fund_end_time: &self.fund_end_time,
            next_fund_start_time: &self.next_fund_start_time,
            registration_snapshot_time: &self.registration_snapshot_time,
            next_registration_snapshot_time: &self.next_registration_snapshot_time,
            chain_vote_plans: self.chain_vote_plans.iter().map(SerdeType).collect(),
            challenges: self.challenges.iter().map(SerdeType).collect(),
            stage_dates: SerdeType(&self.stage_dates),
            goals: self.goals.iter().map(SerdeType).collect(),
            results_url: &self.results_url,
            survey_url: &self.survey_url,
            groups: self.groups.iter().map(SerdeType).collect(),
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<Fund> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&FundNextInfo> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct FundNextInfoSerde<'a> {
            id: i32,
            fund_name: &'a String,
            #[serde(flatten)]
            stage_dates: SerdeType<&'a FundStageDates>,
        }
        FundNextInfoSerde {
            id: self.id,
            fund_name: &self.fund_name,
            stage_dates: SerdeType(&self.stage_dates),
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<FundNextInfo> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        SerdeType(&self.0).serialize(serializer)
    }
}

impl Serialize for SerdeType<&FundWithNext> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        #[derive(Serialize)]
        struct FundWithNextSerde<'a> {
            #[serde(flatten)]
            fund: SerdeType<&'a Fund>,
            #[serde(skip_serializing_if = "Option::is_none")]
            next: Option<SerdeType<&'a FundNextInfo>>,
        }
        FundWithNextSerde {
            fund: SerdeType(&self.fund),
            next: self.next.as_ref().map(SerdeType),
        }
        .serialize(serializer)
    }
}

impl Serialize for SerdeType<FundWithNext> {
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
    use chrono::{DateTime, NaiveDateTime, Utc};
    use serde_json::json;

    #[test]
    fn fund_stage_dates_json_test() {
        let fund_stage_dates = SerdeType(FundStageDates {
            insight_sharing_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
            proposal_submission_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
            refine_proposals_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
            finalize_proposals_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
            proposal_assessment_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
            assessment_qa_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
            snapshot_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
            voting_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
            voting_end: DateTime::from_utc(NaiveDateTime::default(), Utc),
            tallying_end: DateTime::from_utc(NaiveDateTime::default(), Utc),
        });

        let json = serde_json::to_value(fund_stage_dates).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "insight_sharing_start": "1970-01-01T00:00:00+00:00",
                    "proposal_submission_start": "1970-01-01T00:00:00+00:00",
                    "refine_proposals_start": "1970-01-01T00:00:00+00:00",
                    "finalize_proposals_start": "1970-01-01T00:00:00+00:00",
                    "proposal_assessment_start": "1970-01-01T00:00:00+00:00",
                    "assessment_qa_start": "1970-01-01T00:00:00+00:00",
                    "snapshot_start": "1970-01-01T00:00:00+00:00",
                    "voting_start": "1970-01-01T00:00:00+00:00",
                    "voting_end": "1970-01-01T00:00:00+00:00",
                    "tallying_end": "1970-01-01T00:00:00+00:00",
                }
            )
        );
    }

    #[test]
    fn fund_json_test() {
        let fund = SerdeType(Fund {
            id: 1,
            fund_name: "test".to_string(),
            fund_goal: "test".to_string(),
            voting_power_threshold: 1,
            fund_start_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
            fund_end_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
            next_fund_start_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
            registration_snapshot_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
            next_registration_snapshot_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
            chain_vote_plans: vec![],
            challenges: vec![],
            stage_dates: FundStageDates {
                insight_sharing_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                proposal_submission_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                refine_proposals_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                finalize_proposals_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                proposal_assessment_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                assessment_qa_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                snapshot_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                voting_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                voting_end: DateTime::from_utc(NaiveDateTime::default(), Utc),
                tallying_end: DateTime::from_utc(NaiveDateTime::default(), Utc),
            },
            goals: vec![],
            results_url: "test".to_string(),
            survey_url: "test".to_string(),
            groups: vec![],
        });

        let json = serde_json::to_value(fund).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": 1,
                    "fund_name": "test",
                    "fund_goal": "test",
                    "voting_power_threshold": 1,
                    "fund_start_time": "1970-01-01T00:00:00+00:00",
                    "fund_end_time": "1970-01-01T00:00:00+00:00",
                    "next_fund_start_time": "1970-01-01T00:00:00+00:00",
                    "registration_snapshot_time": "1970-01-01T00:00:00+00:00",
                    "next_registration_snapshot_time": "1970-01-01T00:00:00+00:00",
                    "chain_vote_plans": [],
                    "challenges": [],
                    "insight_sharing_start": "1970-01-01T00:00:00+00:00",
                    "proposal_submission_start": "1970-01-01T00:00:00+00:00",
                    "refine_proposals_start": "1970-01-01T00:00:00+00:00",
                    "finalize_proposals_start": "1970-01-01T00:00:00+00:00",
                    "proposal_assessment_start": "1970-01-01T00:00:00+00:00",
                    "assessment_qa_start": "1970-01-01T00:00:00+00:00",
                    "snapshot_start": "1970-01-01T00:00:00+00:00",
                    "voting_start": "1970-01-01T00:00:00+00:00",
                    "voting_end": "1970-01-01T00:00:00+00:00",
                    "tallying_end": "1970-01-01T00:00:00+00:00",
                    "goals": [],
                    "results_url": "test",
                    "survey_url": "test",
                    "groups": []
                }
            )
        );
    }

    #[test]
    fn fund_next_info_json_test() {
        let fund_next_info = SerdeType(FundNextInfo {
            id: 1,
            fund_name: "test".to_string(),
            stage_dates: FundStageDates {
                insight_sharing_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                proposal_submission_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                refine_proposals_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                finalize_proposals_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                proposal_assessment_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                assessment_qa_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                snapshot_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                voting_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                voting_end: DateTime::from_utc(NaiveDateTime::default(), Utc),
                tallying_end: DateTime::from_utc(NaiveDateTime::default(), Utc),
            },
        });

        let json = serde_json::to_value(fund_next_info).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": 1,
                    "fund_name": "test",
                    "insight_sharing_start": "1970-01-01T00:00:00+00:00",
                    "proposal_submission_start": "1970-01-01T00:00:00+00:00",
                    "refine_proposals_start": "1970-01-01T00:00:00+00:00",
                    "finalize_proposals_start": "1970-01-01T00:00:00+00:00",
                    "proposal_assessment_start": "1970-01-01T00:00:00+00:00",
                    "assessment_qa_start": "1970-01-01T00:00:00+00:00",
                    "snapshot_start": "1970-01-01T00:00:00+00:00",
                    "voting_start": "1970-01-01T00:00:00+00:00",
                    "voting_end": "1970-01-01T00:00:00+00:00",
                    "tallying_end": "1970-01-01T00:00:00+00:00",
                }
            )
        );
    }

    #[test]
    fn fund_with_next_json_test() {
        let fund_with_next = SerdeType(FundWithNext {
            fund: Fund {
                id: 1,
                fund_name: "test".to_string(),
                fund_goal: "test".to_string(),
                voting_power_threshold: 1,
                fund_start_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
                fund_end_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
                next_fund_start_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
                registration_snapshot_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
                next_registration_snapshot_time: DateTime::from_utc(NaiveDateTime::default(), Utc),
                chain_vote_plans: vec![],
                challenges: vec![],
                stage_dates: FundStageDates {
                    insight_sharing_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                    proposal_submission_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                    refine_proposals_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                    finalize_proposals_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                    proposal_assessment_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                    assessment_qa_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                    snapshot_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                    voting_start: DateTime::from_utc(NaiveDateTime::default(), Utc),
                    voting_end: DateTime::from_utc(NaiveDateTime::default(), Utc),
                    tallying_end: DateTime::from_utc(NaiveDateTime::default(), Utc),
                },
                goals: vec![],
                results_url: "test".to_string(),
                survey_url: "test".to_string(),
                groups: vec![],
            },
            next: None,
        });

        let json = serde_json::to_value(fund_with_next).unwrap();
        assert_eq!(
            json,
            json!(
                {
                    "id": 1,
                    "fund_name": "test",
                    "fund_goal": "test",
                    "voting_power_threshold": 1,
                    "fund_start_time": "1970-01-01T00:00:00+00:00",
                    "fund_end_time": "1970-01-01T00:00:00+00:00",
                    "next_fund_start_time": "1970-01-01T00:00:00+00:00",
                    "registration_snapshot_time": "1970-01-01T00:00:00+00:00",
                    "next_registration_snapshot_time": "1970-01-01T00:00:00+00:00",
                    "chain_vote_plans": [],
                    "challenges": [],
                    "insight_sharing_start": "1970-01-01T00:00:00+00:00",
                    "proposal_submission_start": "1970-01-01T00:00:00+00:00",
                    "refine_proposals_start": "1970-01-01T00:00:00+00:00",
                    "finalize_proposals_start": "1970-01-01T00:00:00+00:00",
                    "proposal_assessment_start": "1970-01-01T00:00:00+00:00",
                    "assessment_qa_start": "1970-01-01T00:00:00+00:00",
                    "snapshot_start": "1970-01-01T00:00:00+00:00",
                    "voting_start": "1970-01-01T00:00:00+00:00",
                    "voting_end": "1970-01-01T00:00:00+00:00",
                    "tallying_end": "1970-01-01T00:00:00+00:00",
                    "goals": [],
                    "results_url": "test",
                    "survey_url": "test",
                    "groups": []
                }
            )
        );
    }
}
