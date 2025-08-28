import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// View model for campaign timeline.
///
/// This view model is used to display the timeline of a campaign.
class CampaignTimelineViewModel extends Equatable {
  static const List<CampaignPhaseType> offstagePhases = [
    CampaignPhaseType.reviewRegistration,
  ];

  final String title;
  final String description;
  final DateRange timeline;
  final CampaignPhaseType type;

  final bool offstage;

  const CampaignTimelineViewModel({
    required this.title,
    required this.description,
    required this.timeline,
    required this.type,
    this.offstage = false,
  });

  factory CampaignTimelineViewModel.fromModel(CampaignPhase model) => CampaignTimelineViewModel(
    title: model.title,
    description: model.description,
    timeline: DateRange(
      from: model.timeline.from,
      to: model.timeline.to,
    ),
    type: model.type,
    offstage: offstagePhases.contains(model.type),
  );

  @override
  List<Object?> get props => [
    title,
    description,
    timeline,
    type,
    offstage,
  ];
}
