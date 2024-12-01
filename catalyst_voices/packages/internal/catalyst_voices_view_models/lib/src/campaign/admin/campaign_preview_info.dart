import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class CampaignPreviewInfo extends Equatable {
  final CampaignStatus stage;
  final String description;

  const CampaignPreviewInfo({
    required this.stage,
    required this.description,
  });

  @override
  List<Object?> get props => [stage, description];
}

class CompletedCampaignInformation extends CampaignPreviewInfo {
  const CompletedCampaignInformation({required super.description})
      : super(stage: CampaignStatus.completed);
}

class DraftCampaignInformation extends CampaignPreviewInfo with DateTimeMixin {
  @override
  final DateTime date;

  const DraftCampaignInformation({
    required this.date,
    required super.description,
  }) : super(stage: CampaignStatus.draft);

  @override
  List<Object?> get props => [date, description];
}

class LiveCampaignInformation extends CampaignPreviewInfo with DateTimeMixin {
  @override
  final DateTime date;

  const LiveCampaignInformation({
    required this.date,
    required super.description,
  }) : super(stage: CampaignStatus.live);

  @override
  List<Object?> get props => [date, description];
}

mixin DateTimeMixin {
  DateTime get date;
  CampaignStatus get stage;

  String localizedDate(
    VoicesLocalizations l10n,
    (String date, String time) formattedDate,
  ) {
    if (stage == CampaignStatus.draft) {
      return l10n.campaignBeginsOn(formattedDate.$1, formattedDate.$2);
    } else {
      return l10n.campaignEndsOn(formattedDate.$1, formattedDate.$2);
    }
  }
}
