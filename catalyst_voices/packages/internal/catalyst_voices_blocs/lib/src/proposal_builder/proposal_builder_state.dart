import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

final class ProposalBuilderMetadata extends Equatable {
  final ProposalPublish publish;
  final DocumentRef? documentRef;
  final DocumentRef? templateRef;

  /// The current iteration version, 0 if not published.
  final int currentIteration;

  const ProposalBuilderMetadata({
    this.publish = ProposalPublish.localDraft,
    this.documentRef,
    this.templateRef,
    this.currentIteration = 0,
  });

  factory ProposalBuilderMetadata.newDraft({required DocumentRef templateRef}) {
    final id = const Uuid().v7();
    return ProposalBuilderMetadata(
      publish: ProposalPublish.localDraft,
      documentRef: DraftRef(id: id, version: id),
      templateRef: templateRef,
      currentIteration: 0,
    );
  }

  @override
  List<Object?> get props => [
        publish,
        documentRef,
        templateRef,
        currentIteration,
      ];
}

final class ProposalBuilderState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final Document? document;
  final ProposalBuilderMetadata metadata;
  final List<ProposalBuilderSegment> segments;
  final ProposalGuidance guidance;
  final NodeId? activeNodeId;
  final bool showValidationErrors;

  const ProposalBuilderState({
    this.isLoading = false,
    this.error,
    this.document,
    this.metadata = const ProposalBuilderMetadata(),
    this.segments = const [],
    this.guidance = const ProposalGuidance(),
    this.activeNodeId,
    this.showValidationErrors = false,
  });

  String? get proposalTitle {
    final property = document?.getProperty(Proposal.titleNodeId)
        as DocumentValueProperty<String>?;

    return property?.value;
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        document,
        metadata,
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
    Optional<Document>? document,
    ProposalBuilderMetadata? metadata,
    List<ProposalBuilderSegment>? segments,
    ProposalGuidance? guidance,
    Optional<NodeId>? activeNodeId,
    bool? showValidationErrors,
  }) {
    return ProposalBuilderState(
      isLoading: isLoading ?? this.isLoading,
      error: error.dataOr(this.error),
      document: document.dataOr(this.document),
      metadata: metadata ?? this.metadata,
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
