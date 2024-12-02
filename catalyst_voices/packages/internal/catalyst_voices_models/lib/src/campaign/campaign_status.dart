enum CampaignStatus {
  draft,
  live,
  completed;

  bool get isCompleted => this == CampaignStatus.completed;
  bool get isDraft => this == CampaignStatus.draft;
}
