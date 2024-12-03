import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class CampaignInfo extends Equatable {
  final CampaignStatus stage;
  final String description;

  const CampaignInfo({
    required this.stage,
    required this.description,
  });

  factory CampaignInfo.fromCampaign(Campaign campaign) {
    return DraftCampaignInfo(
      startDate: campaign.startDate,
      /* cSpell:disable */
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
          ' Sed do eiusmod tempor incididunt ut labore et dolore magna.',
      /* cSpell:enable */
    );
  }

  @override
  List<Object?> get props => [stage, description];
}

class CompletedCampaignInfo extends CampaignInfo {
  const CompletedCampaignInfo({required super.description})
      : super(stage: CampaignStatus.completed);
}

class DraftCampaignInfo extends CampaignInfo with DateTimeMixin {
  @override
  final DateTime startDate;

  const DraftCampaignInfo({
    required this.startDate,
    required super.description,
  }) : super(stage: CampaignStatus.draft);

  @override
  List<Object?> get props => [startDate, description];
}

class LiveCampaignInfo extends CampaignInfo with DateTimeMixin {
  @override
  final DateTime startDate;

  const LiveCampaignInfo({
    required this.startDate,
    required super.description,
  }) : super(stage: CampaignStatus.live);

  @override
  List<Object?> get props => [startDate, description];
}

mixin DateTimeMixin {
  DateTime get startDate;
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
