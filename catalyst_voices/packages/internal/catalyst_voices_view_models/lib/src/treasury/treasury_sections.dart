import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

part 'campaign_setup.dart';

sealed class TreasurySection<T extends TreasurySectionStep>
    extends BaseSection<T> {
  const TreasurySection({
    required super.id,
    required super.steps,
  });
}

sealed class TreasurySectionStep extends BaseSectionStep {
  const TreasurySectionStep({
    required super.id,
    required super.sectionId,
    super.isEnabled,
    super.isEditable,
  });
}
