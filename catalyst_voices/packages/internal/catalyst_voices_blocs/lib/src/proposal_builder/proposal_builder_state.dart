import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalBuilderMetadata extends Equatable {
  final ProposalPublish publish;
  final DocumentRef? documentRef;
  final DocumentRef? originalDocumentRef;
  final SignedDocumentRef? templateRef;
  final SignedDocumentRef? categoryId;

  /// The current iteration version, 0 if not published.
  final int currentIteration;

  const ProposalBuilderMetadata({
    this.publish = ProposalPublish.localDraft,
    this.documentRef,
    this.originalDocumentRef,
    this.templateRef,
    this.categoryId,
    this.currentIteration = 0,
  });

  factory ProposalBuilderMetadata.newDraft({
    required SignedDocumentRef templateRef,
    required SignedDocumentRef categoryId,
  }) {
    final firstRef = DraftRef.generateFirstRef();
    return ProposalBuilderMetadata(
      publish: ProposalPublish.localDraft,
      documentRef: firstRef,
      templateRef: templateRef,
      categoryId: categoryId,
      currentIteration: 0,
    );
  }

  @override
  List<Object?> get props => [
        publish,
        documentRef,
        originalDocumentRef,
        templateRef,
        categoryId,
        currentIteration,
      ];

  ProposalBuilderMetadata copyWith({
    ProposalPublish? publish,
    Optional<DocumentRef>? documentRef,
    Optional<DocumentRef>? originalDocumentRef,
    Optional<SignedDocumentRef>? templateRef,
    Optional<SignedDocumentRef>? categoryId,
    int? currentIteration,
  }) {
    return ProposalBuilderMetadata(
      publish: publish ?? this.publish,
      documentRef: documentRef.dataOr(this.documentRef),
      originalDocumentRef: originalDocumentRef.dataOr(this.originalDocumentRef),
      templateRef: templateRef.dataOr(this.templateRef),
      categoryId: categoryId.dataOr(this.categoryId),
      currentIteration: currentIteration ?? this.currentIteration,
    );
  }
}

final class ProposalBuilderState extends Equatable {
  final bool isChanging;
  final LocalizedException? error;
  final Document? document;
  final ProposalBuilderMetadata metadata;
  final List<DocumentSegment> segments;
  final ProposalGuidance guidance;
  final NodeId? activeNodeId;
  final bool showValidationErrors;

  const ProposalBuilderState({
    this.isChanging = false,
    this.error,
    this.document,
    this.metadata = const ProposalBuilderMetadata(),
    this.segments = const [],
    this.guidance = const ProposalGuidance(),
    this.activeNodeId,
    this.showValidationErrors = false,
  });

  String? get proposalTitle {
    final property = document?.getProperty(ProposalDocument.titleNodeId)
        as DocumentValueProperty<String>?;

    return property?.value;
  }

  @override
  List<Object?> get props => [
        isChanging,
        error,
        document,
        metadata,
        segments,
        guidance,
        activeNodeId,
        showValidationErrors,
      ];

  bool get showError => !isChanging && error != null;

  bool get showSegments => !isChanging && segments.isNotEmpty && error == null;

  ProposalBuilderState copyWith({
    bool? isChanging,
    Optional<LocalizedException>? error,
    Optional<Document>? document,
    ProposalBuilderMetadata? metadata,
    List<DocumentSegment>? segments,
    ProposalGuidance? guidance,
    Optional<NodeId>? activeNodeId,
    bool? showValidationErrors,
  }) {
    return ProposalBuilderState(
      isChanging: isChanging ?? this.isChanging,
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
