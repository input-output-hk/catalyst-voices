/// Enum representing the state of a campaign.
/// Draft: campaign is not published yet.
/// Published: campaign is published and can be seen by users.
enum CampaignPublish {
  draft,
  published;

  bool get isDraft => this == draft;
}
