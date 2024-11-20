import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

enum CampaignStage { draft, live, completed }

class CompletedCampaignInformation extends InPageInformation {
  const CompletedCampaignInformation({required super.description})
      : super(stage: CampaignStage.completed);

  @override
  List<Object?> get props => [
        ...super.props,
      ];
}

mixin DateTimeMixin {
  DateTime get date;
  CampaignStage get stage;

  String getFormattedDate(VoicesLocalizations l10n) {
    final dayMonthFormatter = DateFormat('d MMMM').format(date);
    final timeFormatter = DateFormat('HH:mm').format(date);

    if (stage == CampaignStage.draft) {
      return l10n.campaignBeginsOn(dayMonthFormatter, timeFormatter);
    } else {
      return l10n.campaignEndsOn(dayMonthFormatter, timeFormatter);
    }
  }
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
  List<Object?> get props => [stage];

  String stageTranslation(VoicesLocalizations l10n) => switch (stage) {
        CampaignStage.draft => l10n.campaignStaringSoon,
        CampaignStage.live => l10n.campaignIsLive,
        CampaignStage.completed => l10n.campaignConcluded,
      };
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

extension CampaignStageExt on CampaignStage {
  bool get isCompleted => this == CampaignStage.completed;
  bool get isDraft => this == CampaignStage.draft;
}
