import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalBuilderState extends Equatable {
  final List<Segment> segments;
  final ProposalGuidance guidance;

  const ProposalBuilderState({
    this.segments = const [],
    this.guidance = const ProposalGuidance(),
  });

  ProposalBuilderState copyWith({
    List<Segment>? segments,
    ProposalGuidance? guidance,
  }) {
    return ProposalBuilderState(
      segments: segments ?? this.segments,
      guidance: guidance ?? this.guidance,
    );
  }

  @override
  List<Object?> get props => [
        segments,
        guidance,
      ];
}

final class ProposalGuidance extends Equatable {
  final bool isNoneSelected;
  final List<Guidance> guidances;

  const ProposalGuidance({
    this.isNoneSelected = false,
    this.guidances = const [],
  });

  bool get showEmptyState => !isNoneSelected && guidances.isEmpty;

  @override
  List<Object?> get props => [
        isNoneSelected,
        guidances,
      ];
}
