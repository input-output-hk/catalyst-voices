import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalBuilderState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final List<ProposalBuilderSegment> segments;
  final ProposalGuidance guidance;
  final NodeId? activeNodeId;
  final bool showValidationErrors;

  const ProposalBuilderState({
    this.isLoading = false,
    this.error,
    this.segments = const [],
    this.guidance = const ProposalGuidance(),
    this.activeNodeId,
    this.showValidationErrors = false,
  });

  @override
  List<Object?> get props => [
        isLoading,
        error,
        segments,
        guidance,
        activeNodeId,
        showValidationErrors,
      ];

  bool get showError => !isLoading && error != null;

  bool get showSegments => !isLoading && segments.isNotEmpty && error == null;

  ProposalBuilderState copyWith({
    bool? isLoading,
    Optional<LocalizedException>? error,
    List<ProposalBuilderSegment>? segments,
    ProposalGuidance? guidance,
    Optional<NodeId>? activeNodeId,
    bool? showValidationErrors,
  }) {
    return ProposalBuilderState(
      isLoading: isLoading ?? this.isLoading,
      error: error.dataOr(this.error),
      segments: segments ?? this.segments,
      guidance: guidance ?? this.guidance,
      activeNodeId: activeNodeId.dataOr(this.activeNodeId),
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
    );
  }
}

final class ProposalGuidance extends Equatable {
  final bool isNoneSelected;
  final List<ProposalGuidanceItem> guidanceList;

  const ProposalGuidance({
    this.isNoneSelected = false,
    this.guidanceList = const [],
  });

  @override
  List<Object?> get props => [
        isNoneSelected,
        guidanceList,
      ];

  bool get showEmptyState => !isNoneSelected && guidanceList.isEmpty;
}

final class ProposalGuidanceItem extends Equatable {
  final String segmentTitle;
  final String sectionTitle;
  final MarkdownData description;

  const ProposalGuidanceItem({
    required this.segmentTitle,
    required this.sectionTitle,
    required this.description,
  });

  @override
  List<Object?> get props => [
        segmentTitle,
        sectionTitle,
        description,
      ];
}
