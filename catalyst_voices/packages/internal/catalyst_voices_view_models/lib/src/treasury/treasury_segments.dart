import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

final class TreasurySegment extends BaseSegment<TreasurySection> {
  const TreasurySegment({
    required super.id,
    required super.sections,
  });

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.treasuryCreateCampaign;
  }
}

sealed class TreasurySection extends BaseSection {
  const TreasurySection({
    required super.id,
    super.isEnabled,
    super.isEditable,
  });

  @override
  String resolveTitle(BuildContext context);

  String? resolveDesc(BuildContext context) => null;
}

final class SetupCampaignDetails extends TreasurySection {
  const SetupCampaignDetails({
    required super.id,
  });

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.setupCampaignDetails;
  }
}

final class SetupCampaignStages extends TreasurySection {
  const SetupCampaignStages({
    required super.id,
  });

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.setupCampaignStages;
  }
}

final class SetupProposalTemplate extends TreasurySection {
  const SetupProposalTemplate({
    required super.id,
  });

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.setupBaseProposalTemplate;
  }

  @override
  String resolveDesc(BuildContext context) {
    return context.l10n.setupBaseQuestions;
  }
}

final class SetupCampaignCategories extends TreasurySection {
  const SetupCampaignCategories({
    required super.id,
  });

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.setupCategories;
  }
}
