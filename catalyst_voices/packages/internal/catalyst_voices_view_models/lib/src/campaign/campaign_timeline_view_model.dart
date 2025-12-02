import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// View model for campaign timeline.
///
/// This view model is used to display the timeline of a campaign.
class CampaignTimelineViewModel extends Equatable {
  final String title;
  final String description;
  final DateRange timeline;
  final CampaignPhaseType type;

  const CampaignTimelineViewModel({
    required this.title,
    required this.description,
    required this.timeline,
    required this.type,
  });

  factory CampaignTimelineViewModel.fromModel(CampaignPhase model) => CampaignTimelineViewModel(
    title: model.title,
    description: model.description,
    timeline: DateRange(
      from: model.timeline.from,
      to: model.timeline.to,
    ),
    type: model.type,
  );

  @override
  List<Object?> get props => [
    title,
    description,
    timeline,
    type,
  ];
}
