// Enum representing the state of a campaign.
// Draft: campaign is not published yet.
// Published: campaign is published and can be seen by users.
//
// This enum is used in conjunction with the CampaignStage enum
// from view_models/campaign/campaign_stage.dart to determine
// the stage of a campaign.
//
// If CampaignPublish is draft then CampaignStage must be draft.
enum CampaignPublish {
  draft,
  published;

  bool get isDraft => this == draft;
}
