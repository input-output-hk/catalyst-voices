part of 'treasury_sections.dart';

final class CampaignSetup extends TreasurySection<DummyTopicStep> {
  const CampaignSetup({
    required super.id,
    required super.steps,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Setup Campaign';
  }
}

final class DummyTopicStep extends TreasurySectionStep {
  const DummyTopicStep({
    required super.id,
    required super.sectionId,
    super.isEditable,
  });

  @override
  String localizedName(BuildContext context) {
    return 'Topic $id';
  }

  String localizedDesc(BuildContext context) {
    return localizedName(context);
  }
}
