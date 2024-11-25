import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:equatable/equatable.dart';

enum CampaignStage {
  draft,
  live,
  completed;

  bool get isCompleted => this == CampaignStage.completed;
  bool get isDraft => this == CampaignStage.draft;

  String localizedName(VoicesLocalizations l10n) => switch (this) {
        CampaignStage.draft => l10n.campaignStaringSoon,
        CampaignStage.live => l10n.campaignIsLive,
        CampaignStage.completed => l10n.campaignConcluded,
      };
}

class CompletedCampaignInformation extends InPageInformation {
  const CompletedCampaignInformation({required super.description})
      : super(stage: CampaignStage.completed);
}

mixin DateTimeMixin {
  DateTime get date;
}

class DraftCampaignInformation extends InPageInformation with DateTimeMixin {
  @override
  final DateTime date;

  const DraftCampaignInformation({
    required this.date,
    required super.description,
  }) : super(stage: CampaignStage.draft);

  @override
  List<Object?> get props => [...super.props, date];
}

sealed class InPageInformation extends Equatable {
  final CampaignStage stage;
  final String description;

  const InPageInformation({
    required this.stage,
    required this.description,
  });

  @override
  List<Object?> get props => [stage, description];
}

class LiveCampaignInformation extends InPageInformation with DateTimeMixin {
  @override
  final DateTime date;

  const LiveCampaignInformation({
    required this.date,
    required super.description,
  }) : super(stage: CampaignStage.live);

  @override
  List<Object?> get props => [...super.props, date];
}
