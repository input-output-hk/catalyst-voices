-- Define F10 IdeaScale parameters.
INSERT INTO config (id, id2, id3, value) VALUES (
  'ideascale',
  '0',
  '',
  '{  
        "group_id": 37429,
        "review_stage_ids": [171],
        "nr_allocations": [1, 1],
        "campaign_group_id": 88,
        "questions": {
            "Question 1": "Impact / Alignment",
            "Question 2": "Feasibility",
            "Question 3": "Auditability"
        },
        "stage_ids": [4684, 4685, 4686],
        "proposals": {
            "field_mappings": {
                "proposer_url": ["relevant_link_1", "website__github_repository__or_any_other_relevant_link__", "relevant_link_3"],
                "proposer_relevant_experience": "relevant_experience",
                "public_key": "ada_payment_address__",
                "funds": ["requested_funds", "requested_funds_in_ada","requested_funds_coti"]
            },
            "extra_field_mappings": {
                "metrics": "key_metrics_to_measure",
                "goal": "how_does_success_look_like_",
                "solution": "problem_solution",
                "brief": "challenge_brief",
                "importance": "importance",
                "full_solution": "please_describe_your_proposed_solution",
                "team_details":  "please_provide_details_of_the_people_who_will_work_on_the_project_",
                "auto_translated": "auto_translated",
                "budget_breakdown": "please_provide_a_detailed_budget_breakdown",
                "challenges_or_risks": "what_main_challenges_or_risks_do_you_foresee_to_deliver_this_project_successfully_",
                "timeline_and_key_milestones": "please_provide_a_detailed_plan__a_timeline__and_key_milestones_for_delivering_your_proposal_",
                "how_solution_address_challenge": "please_describe_how_your_proposed_solution_will_address_the_challenge_",
                "sdg_rating": "sdg_rating",
                "return_in_a_later_round": "if_you_are_funded__will_you_return_to_catalyst_in_a_later_round_for_further_funding__please_explain",
                "relevant_link_1": "relevant_link_1",
                "relevant_link_2": "website__github_repository__or_any_other_relevant_link__",
                "relevant_link_3": "relevant_link_3",
                "progress_metrics": "what_will_you_measure_to_track_your_project_s_progress__and_how_will_you_measure_it_",
                "new_proposal": "is_this_proposal_is_a_continuation_of_a_previously_funded_project_in_catalyst__or_an_entirely_new_o"
            }
        },
        "proposals_scores_csv": {
            "id_field": "proposal_id",
            "score_field": "Rating"
        }
     }'
);

-- Use F10 params for event with row_id = 10.
INSERT INTO config (id, id2, id3, value) VALUES (
  'event',
  'ideascale_params',
  '0',
  '{"params_id": "TestFund"}'
) ON CONFLICT (id, id2, id3) DO UPDATE
SET value = excluded.value;
