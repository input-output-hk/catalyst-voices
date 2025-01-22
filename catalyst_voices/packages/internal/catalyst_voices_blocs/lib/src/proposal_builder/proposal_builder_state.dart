import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalBuilderState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final List<Segment> segments;
  final ProposalGuidance guidance;

  const ProposalBuilderState({
    this.isLoading = false,
    this.error,
    this.segments = const [],
    this.guidance = const ProposalGuidance(),
  });

  bool get showSegments => !isLoading && segments.isNotEmpty && error == null;

  bool get showError => !isLoading && error != null;

  ProposalBuilderState copyWith({
    bool? isLoading,
    Optional<LocalizedException>? error,
    List<Segment>? segments,
    ProposalGuidance? guidance,
  }) {
    return ProposalBuilderState(
      isLoading: isLoading ?? this.isLoading,
      error: error.dataOr(this.error),
      segments: segments ?? this.segments,
      guidance: guidance ?? this.guidance,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        segments,
        guidance,
      ];
}

final class ProposalGuidance extends Equatable {
  final bool isNoneSelected;
  final List<MarkdownData> guidanceList;

  const ProposalGuidance({
    this.isNoneSelected = false,
    this.guidanceList = const [],
  });

  bool get showEmptyState => !isNoneSelected && guidanceList.isEmpty;

  @override
  List<Object?> get props => [
        isNoneSelected,
        guidanceList,
      ];
}
