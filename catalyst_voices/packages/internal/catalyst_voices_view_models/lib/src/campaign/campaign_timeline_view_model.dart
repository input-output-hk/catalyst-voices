import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

class CampaignTimelineViewModel extends Equatable {
  final String title;
  final String description;
  final DateRange timeline;
  final CampaignTimelineStage stage;

  const CampaignTimelineViewModel({
    required this.title,
    required this.description,
    required this.timeline,
    required this.stage,
  });

  factory CampaignTimelineViewModel.fromModel(CampaignTimeline model) =>
      CampaignTimelineViewModel(
        title: model.title,
        description: model.description,
        timeline: DateRange(
          from: model.timeline.from,
          to: model.timeline.to,
        ),
        stage: model.stage,
      );

  @override
  List<Object?> get props => [
        title,
        description,
        timeline,
        stage,
      ];
}
