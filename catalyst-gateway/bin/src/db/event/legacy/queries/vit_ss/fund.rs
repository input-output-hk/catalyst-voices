use chrono::{NaiveDateTime, Utc};

use crate::db::event::{
    error::NotFoundError,
    legacy::types::vit_ss::{
        challenge::{Challenge, ChallengeHighlights},
        fund::{Fund, FundNextInfo, FundStageDates, FundWithNext},
        goal::Goal,
        group::Group,
        vote_plan::Voteplan,
    },
    EventDB,
};

impl EventDB {
    const FUND_CHALLENGES_QUERY: &'static str = "SELECT
    objective.row_id AS internal_id,
    objective.id AS id,
    objective.category AS challenge_type,
    objective.title AS title,
    objective.description AS description,
    objective.rewards_total AS rewards_total,
    objective.proposers_rewards AS proposers_rewards,
    (objective.extra->'url') #>> '{}' AS challenge_url,
    (objective.extra->'sponsor') #>> '{}' AS highlights

    FROM objective
    WHERE objective.event = $1;";
    const FUND_GOALS_QUERY: &'static str = "SELECT
    id,
    name AS goal_name

    FROM goal
    WHERE goal.event_id = $1;";
    const FUND_GROUPS_QUERY: &'static str = "SELECT
    voteplan.token_id AS token_identifier,
    voting_group.name AS group_id

    FROM voting_group
    INNER JOIN voteplan ON voteplan.group_id = voting_group.name
    INNER JOIN objective ON voteplan.objective_id = objective.row_id
    WHERE objective.event = $1;";
    const FUND_QUERY: &'static str = "SELECT
    this_fund.row_id AS id,
    this_fund.name AS fund_name,
    this_fund.description AS fund_goal,

    this_fund.registration_snapshot_time AS registration_snapshot_time,

    this_fund.voting_power_threshold AS voting_power_threshold,

    this_fund.start_time AS fund_start_time,
    this_fund.end_time AS fund_end_time,

    this_fund.insight_sharing_start AS insight_sharing_start,
    this_fund.proposal_submission_start AS proposal_submission_start,
    this_fund.refine_proposals_start AS refine_proposals_start,
    this_fund.finalize_proposals_start AS finalize_proposals_start,
    this_fund.proposal_assessment_start AS proposal_assessment_start,
    this_fund.assessment_qa_start AS assessment_qa_start,
    this_fund.snapshot_start AS snapshot_start,
    this_fund.voting_start AS voting_start,
    this_fund.voting_end AS voting_end,
    this_fund.tallying_end AS tallying_end,

    (this_fund.extra->'url'->'results') #>> '{}' AS results_url,
    (this_fund.extra->'url'->'survey') #>> '{}' AS survey_url,

    next_fund.row_id AS next_id,

    next_fund.start_time AS next_fund_start_time,
    next_fund.registration_snapshot_time AS next_registration_snapshot_time,

    next_fund.name AS next_fund_name,

    next_fund.insight_sharing_start AS next_insight_sharing_start,
    next_fund.proposal_submission_start AS next_proposal_submission_start,
    next_fund.refine_proposals_start AS next_refine_proposals_start,
    next_fund.finalize_proposals_start AS next_finalize_proposals_start,
    next_fund.proposal_assessment_start AS next_proposal_assessment_start,
    next_fund.assessment_qa_start AS next_assessment_qa_start,
    next_fund.snapshot_start AS next_snapshot_start,
    next_fund.voting_start AS next_voting_start,
    next_fund.voting_end AS next_voting_end,
    next_fund.tallying_end AS next_tallying_end
    
    FROM event this_fund
    LEFT JOIN event next_fund ON next_fund.row_id = this_fund.row_id + 1
    WHERE this_fund.end_time > CURRENT_TIMESTAMP AT TIME ZONE 'UTC' AND this_fund.start_time < CURRENT_TIMESTAMP AT TIME ZONE 'UTC'
    ORDER BY this_fund.row_id DESC
    LIMIT 1;";
    const FUND_VOTE_PLANS_QUERY: &'static str = "SELECT
    voteplan.row_id AS id,
    voteplan.id AS chain_voteplan_id,

    voteplan.category AS chain_voteplan_payload,
    voteplan.encryption_key AS chain_vote_encryption_key,
    event.row_id AS fund_id,
    voteplan.token_id AS token_identifier

    FROM voteplan
    INNER JOIN objective ON voteplan.objective_id = objective.row_id
    INNER JOIN event ON objective.event = event.row_id
    WHERE event.row_id = $1;";
}

impl EventDB {
    /// Get fund query
    // TODO(stevenj): https://github.com/input-output-hk/catalyst-voices/issues/68
    #[allow(dead_code, clippy::too_many_lines)]
    pub(crate) async fn get_fund() -> anyhow::Result<FundWithNext> {
        let rows = Self::query(Self::FUND_QUERY, &[]).await?;
        let row = rows.first().ok_or(NotFoundError)?;

        let fund_id = row.try_get("id")?;

        let fund_voting_start = row
            .try_get::<_, Option<NaiveDateTime>>("voting_start")?
            .unwrap_or_default()
            .and_local_timezone(Utc)
            .unwrap();
        let fund_voting_end = row
            .try_get::<_, Option<NaiveDateTime>>("voting_end")?
            .unwrap_or_default()
            .and_local_timezone(Utc)
            .unwrap();
        let fund_tallying_end = row
            .try_get::<_, Option<NaiveDateTime>>("tallying_end")?
            .unwrap_or_default()
            .and_local_timezone(Utc)
            .unwrap();

        let rows = Self::query(Self::FUND_VOTE_PLANS_QUERY, &[&fund_id]).await?;
        let mut chain_vote_plans = Vec::new();
        for row in rows {
            chain_vote_plans.push(Voteplan {
                id: row.try_get("id")?,
                chain_voteplan_id: row.try_get("chain_voteplan_id")?,
                chain_vote_start_time: fund_voting_start,
                chain_vote_end_time: fund_voting_end,
                chain_committee_end_time: fund_tallying_end,
                chain_voteplan_payload: row.try_get("chain_voteplan_payload")?,
                chain_vote_encryption_key: row
                    .try_get::<_, Option<String>>("chain_vote_encryption_key")?
                    .unwrap_or_default(),
                fund_id,
                token_identifier: row
                    .try_get::<_, Option<String>>("token_identifier")?
                    .unwrap_or_default(),
            });
        }

        let rows = Self::query(Self::FUND_CHALLENGES_QUERY, &[&fund_id]).await?;
        let mut challenges = Vec::new();
        for row in rows {
            challenges.push(Challenge {
                id: row.try_get("id")?,
                internal_id: row.try_get("internal_id")?,
                c_type: row.try_get("challenge_type")?,
                title: row.try_get("title")?,
                description: row.try_get("description")?,
                rewards_total: row
                    .try_get::<_, Option<i64>>("rewards_total")?
                    .unwrap_or_default(),
                proposers_rewards: row
                    .try_get::<_, Option<i64>>("proposers_rewards")?
                    .unwrap_or_default(),
                fund_id,
                url: row
                    .try_get::<_, Option<String>>("challenge_url")?
                    .unwrap_or_default(),
                highlights: row
                    .try_get::<_, Option<String>>("highlights")?
                    .map(|sponsor| ChallengeHighlights { sponsor }),
            });
        }

        let rows = Self::query(Self::FUND_GOALS_QUERY, &[&fund_id]).await?;
        let mut goals = Vec::new();
        for row in rows {
            goals.push(Goal {
                id: row.try_get("id")?,
                name: row.try_get("goal_name")?,
                fund_id,
            });
        }

        let rows = Self::query(Self::FUND_GROUPS_QUERY, &[&fund_id]).await?;
        let mut groups = Vec::new();
        for row in rows {
            groups.push(Group {
                g_id: row.try_get("group_id")?,
                token_identifier: row.try_get("token_identifier")?,
                fund_id,
            });
        }

        let fund = Fund {
            id: fund_id,
            name: row.try_get("fund_name")?,
            goal: row.try_get("fund_goal")?,
            voting_power_threshold: row.try_get("voting_power_threshold")?,
            start_time: row
                .try_get::<_, NaiveDateTime>("fund_start_time")?
                .and_local_timezone(Utc)
                .unwrap(),
            end_time: row
                .try_get::<_, NaiveDateTime>("fund_end_time")?
                .and_local_timezone(Utc)
                .unwrap(),
            next_fund_start_time: row
                .try_get::<_, Option<NaiveDateTime>>("next_fund_start_time")?
                .unwrap_or_default()
                .and_local_timezone(Utc)
                .unwrap(),
            registration_snapshot_time: row
                .try_get::<_, Option<NaiveDateTime>>("registration_snapshot_time")?
                .unwrap_or_default()
                .and_local_timezone(Utc)
                .unwrap(),
            next_registration_snapshot_time: row
                .try_get::<_, Option<NaiveDateTime>>("next_registration_snapshot_time")?
                .unwrap_or_default()
                .and_local_timezone(Utc)
                .unwrap(),
            chain_vote_plans,
            challenges,
            stage_dates: FundStageDates {
                insight_sharing_start: row
                    .try_get::<_, Option<NaiveDateTime>>("insight_sharing_start")?
                    .unwrap_or_default()
                    .and_local_timezone(Utc)
                    .unwrap(),
                proposal_submission_start: row
                    .try_get::<_, Option<NaiveDateTime>>("proposal_submission_start")?
                    .unwrap_or_default()
                    .and_local_timezone(Utc)
                    .unwrap(),
                refine_proposals_start: row
                    .try_get::<_, Option<NaiveDateTime>>("refine_proposals_start")?
                    .unwrap_or_default()
                    .and_local_timezone(Utc)
                    .unwrap(),
                finalize_proposals_start: row
                    .try_get::<_, Option<NaiveDateTime>>("finalize_proposals_start")?
                    .unwrap_or_default()
                    .and_local_timezone(Utc)
                    .unwrap(),
                proposal_assessment_start: row
                    .try_get::<_, Option<NaiveDateTime>>("proposal_assessment_start")?
                    .unwrap_or_default()
                    .and_local_timezone(Utc)
                    .unwrap(),
                assessment_qa_start: row
                    .try_get::<_, Option<NaiveDateTime>>("assessment_qa_start")?
                    .unwrap_or_default()
                    .and_local_timezone(Utc)
                    .unwrap(),
                snapshot_start: row
                    .try_get::<_, Option<NaiveDateTime>>("snapshot_start")?
                    .unwrap_or_default()
                    .and_local_timezone(Utc)
                    .unwrap(),
                voting_start: fund_voting_start,
                voting_end: fund_voting_end,
                tallying_end: fund_tallying_end,
            },
            goals,
            results_url: row
                .try_get::<_, Option<String>>("results_url")?
                .unwrap_or_default(),
            survey_url: row
                .try_get::<_, Option<String>>("survey_url")?
                .unwrap_or_default(),
            groups,
        };

        let next = match row.try_get::<_, Option<i32>>("next_id")? {
            Some(id) => {
                Some(FundNextInfo {
                    id,
                    fund_name: row.try_get("next_fund_name")?,
                    stage_dates: FundStageDates {
                        insight_sharing_start: row
                            .try_get::<_, Option<NaiveDateTime>>("next_insight_sharing_start")?
                            .unwrap_or_default()
                            .and_local_timezone(Utc)
                            .unwrap(),
                        proposal_submission_start: row
                            .try_get::<_, Option<NaiveDateTime>>("next_proposal_submission_start")?
                            .unwrap_or_default()
                            .and_local_timezone(Utc)
                            .unwrap(),
                        refine_proposals_start: row
                            .try_get::<_, Option<NaiveDateTime>>("next_refine_proposals_start")?
                            .unwrap_or_default()
                            .and_local_timezone(Utc)
                            .unwrap(),
                        finalize_proposals_start: row
                            .try_get::<_, Option<NaiveDateTime>>("next_finalize_proposals_start")?
                            .unwrap_or_default()
                            .and_local_timezone(Utc)
                            .unwrap(),
                        proposal_assessment_start: row
                            .try_get::<_, Option<NaiveDateTime>>("next_proposal_assessment_start")?
                            .unwrap_or_default()
                            .and_local_timezone(Utc)
                            .unwrap(),
                        assessment_qa_start: row
                            .try_get::<_, Option<NaiveDateTime>>("next_assessment_qa_start")?
                            .unwrap_or_default()
                            .and_local_timezone(Utc)
                            .unwrap(),
                        snapshot_start: row
                            .try_get::<_, Option<NaiveDateTime>>("next_snapshot_start")?
                            .unwrap_or_default()
                            .and_local_timezone(Utc)
                            .unwrap(),
                        voting_start: row
                            .try_get::<_, Option<NaiveDateTime>>("next_voting_start")?
                            .unwrap_or_default()
                            .and_local_timezone(Utc)
                            .unwrap(),
                        voting_end: row
                            .try_get::<_, Option<NaiveDateTime>>("next_voting_end")?
                            .unwrap_or_default()
                            .and_local_timezone(Utc)
                            .unwrap(),
                        tallying_end: row
                            .try_get::<_, Option<NaiveDateTime>>("next_tallying_end")?
                            .unwrap_or_default()
                            .and_local_timezone(Utc)
                            .unwrap(),
                    },
                })
            },
            None => None,
        };

        Ok(FundWithNext { fund, next })
    }
}
