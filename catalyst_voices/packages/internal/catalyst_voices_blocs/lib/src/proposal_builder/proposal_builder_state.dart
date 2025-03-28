import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class ProposalBuilderMetadata extends Equatable {
  final ProposalPublish publish;
  final DocumentRef? documentRef;
  final DocumentRef? originalDocumentRef;
  final SignedDocumentRef? templateRef;
  final SignedDocumentRef? categoryId;
  final List<DocumentVersion> versions;

  const ProposalBuilderMetadata({
    this.publish = ProposalPublish.localDraft,
    this.documentRef,
    this.originalDocumentRef,
    this.templateRef,
    this.categoryId,
    this.versions = const [],
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
      versions: const [],
    );
  }

  DocumentVersion? get latestVersion =>
      versions.firstWhereOrNull((e) => e.isLatest);

  @override
  List<Object?> get props => [
        publish,
        documentRef,
        originalDocumentRef,
        templateRef,
        categoryId,
        versions,
      ];

  ProposalBuilderMetadata copyWith({
    ProposalPublish? publish,
    Optional<DocumentRef>? documentRef,
    Optional<DocumentRef>? originalDocumentRef,
    Optional<SignedDocumentRef>? templateRef,
    Optional<SignedDocumentRef>? categoryId,
    List<DocumentVersion>? versions,
  }) {
    return ProposalBuilderMetadata(
      publish: publish ?? this.publish,
      documentRef: documentRef.dataOr(this.documentRef),
      originalDocumentRef: originalDocumentRef.dataOr(this.originalDocumentRef),
      templateRef: templateRef.dataOr(this.templateRef),
      categoryId: categoryId.dataOr(this.categoryId),
      versions: versions ?? this.versions,
    );
  }
}

final class ProposalBuilderState extends Equatable {
  final bool isLoading;
  final bool isChanging;
  final LocalizedException? error;
  final Document? document;
  final ProposalBuilderMetadata metadata;
  final List<DocumentSegment> documentSegments;
  final Segment? commentsSegment;
  final ProposalCommentsSort commentsSort;
  final ProposalGuidance guidance;
  final CampaignCategoryDetailsViewModel? category;
  final NodeId? activeNodeId;
  final bool showValidationErrors;

  const ProposalBuilderState({
    this.isLoading = false,
    this.isChanging = false,
    this.error,
    this.document,
    this.metadata = const ProposalBuilderMetadata(),
    this.documentSegments = const [],
    this.commentsSegment,
    this.commentsSort = ProposalCommentsSort.newest,
    this.guidance = const ProposalGuidance(),
    this.category,
    this.activeNodeId,
    this.showValidationErrors = false,
  });

  List<Segment> get allSegments => [
        ...documentSegments,
        if (commentsSegment case final value?) value,
      ];

  String? get proposalTitle {
    final property = document?.getProperty(ProposalDocument.titleNodeId)
        as DocumentValueProperty<String>?;

    return property?.value;
  }

  @override
  List<Object?> get props => [
        isLoading,
        isChanging,
        error,
        document,
        metadata,
        documentSegments,
        commentsSegment,
        commentsSort,
        guidance,
        category,
        activeNodeId,
        showValidationErrors,
      ];

  bool get showError => !isLoading && error != null;

  bool get showSegments =>
      !isLoading && allSegments.isNotEmpty && error == null;

  ProposalBuilderState copyWith({
    bool? isLoading,
    bool? isChanging,
    Optional<LocalizedException>? error,
    Optional<Document>? document,
    ProposalBuilderMetadata? metadata,
    List<DocumentSegment>? documentSegments,
    Optional<Segment>? commentsSegment,
    ProposalGuidance? guidance,
    Optional<CampaignCategoryDetailsViewModel>? category,
    Optional<NodeId>? activeNodeId,
    bool? showValidationErrors,
  }) {
    return ProposalBuilderState(
      isLoading: isLoading ?? this.isLoading,
      isChanging: isChanging ?? this.isChanging,
      error: error.dataOr(this.error),
      document: document.dataOr(this.document),
      metadata: metadata ?? this.metadata,
      documentSegments: documentSegments ?? this.documentSegments,
      commentsSegment: commentsSegment.dataOr(this.commentsSegment),
      guidance: guidance ?? this.guidance,
      category: category.dataOr(this.category),
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
