import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

final class TreasurySection extends BaseSection<TreasurySectionStep> {
  const TreasurySection({
    required super.id,
    required super.steps,
  });

  @override
  String localizedName(BuildContext context) {
    return context.l10n.treasuryCreateCampaign;
  }
}

sealed class TreasurySectionStep extends BaseSectionStep {
  const TreasurySectionStep({
    required super.id,
    required super.sectionId,
    super.isEnabled,
    super.isEditable,
  });

  String localizedDesc(BuildContext context) => localizedName(context);
}

final class SetupCampaignDetailsStep extends TreasurySectionStep {
  const SetupCampaignDetailsStep({
    required super.id,
    required super.sectionId,
  });

  @override
  String localizedName(BuildContext context) {
    return context.l10n.setupCampaignDetails;
  }
}

final class SetupCampaignStagesStep extends TreasurySectionStep {
  const SetupCampaignStagesStep({
    required super.id,
    required super.sectionId,
  });

  @override
  String localizedName(BuildContext context) {
    return context.l10n.setupCampaignStages;
  }
}

final class SetupProposalTemplateStep extends TreasurySectionStep {
  const SetupProposalTemplateStep({
    required super.id,
    required super.sectionId,
  });

  @override
  String localizedName(BuildContext context) {
    return context.l10n.setupBaseProposalTemplate;
  }

  @override
  String localizedDesc(BuildContext context) {
    return context.l10n.setupBaseQuestions;
  }
}

final class SetupCampaignCategoriesStep extends TreasurySectionStep {
  const SetupCampaignCategoriesStep({
    required super.id,
    required super.sectionId,
  });

  @override
  String localizedName(BuildContext context) {
    return context.l10n.setupCategories;
  }
}
