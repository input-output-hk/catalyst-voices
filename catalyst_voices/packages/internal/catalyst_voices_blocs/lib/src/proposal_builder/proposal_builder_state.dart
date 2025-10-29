import 'package:catalyst_voices_blocs/src/comments/comments_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class ProposalBuilderMetadata extends Equatable {
  final ProposalPublish publish;
  final DocumentRef? documentRef;
  final DocumentRef? originalDocumentRef;
  final SignedDocumentRef? templateRef;
  final DocumentParameters? parameters;
  final List<DocumentVersion> versions;
  final bool fromActiveCampaign;

  const ProposalBuilderMetadata({
    this.publish = ProposalPublish.localDraft,
    this.documentRef,
    this.originalDocumentRef,
    this.templateRef,
    this.parameters,
    this.versions = const [],
    this.fromActiveCampaign = true,
  });

  factory ProposalBuilderMetadata.newDraft({
    required SignedDocumentRef templateRef,
    required DocumentParameters parameters,
  }) {
    final firstRef = DraftRef.generateFirstRef();
    return ProposalBuilderMetadata(
      documentRef: firstRef,
      templateRef: templateRef,
      parameters: parameters,
    );
  }

  DocumentVersion? get latestVersion => versions.firstWhereOrNull((e) => e.isLatest);

  @override
  List<Object?> get props => [
    publish,
    documentRef,
    originalDocumentRef,
    templateRef,
    parameters,
    versions,
    fromActiveCampaign,
  ];

  ProposalBuilderMetadata copyWith({
    ProposalPublish? publish,
    Optional<DocumentRef>? documentRef,
    Optional<DocumentRef>? originalDocumentRef,
    Optional<SignedDocumentRef>? templateRef,
    Optional<DocumentParameters>? parameters,
    List<DocumentVersion>? versions,
    bool? fromActiveCampaign,
  }) {
    return ProposalBuilderMetadata(
      publish: publish ?? this.publish,
      documentRef: documentRef.dataOr(this.documentRef),
      originalDocumentRef: originalDocumentRef.dataOr(this.originalDocumentRef),
      templateRef: templateRef.dataOr(this.templateRef),
      parameters: parameters.dataOr(this.parameters),
      versions: versions ?? this.versions,
      fromActiveCampaign: fromActiveCampaign ?? this.fromActiveCampaign,
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
  final List<Segment> commentSegments;
  final CommentsState comments;
  final ProposalGuidance guidance;
  final CampaignCategoryDetailsViewModel? category;
  final NodeId? activeNodeId;
  final ProposalBuilderValidationErrors? validationErrors;
  final bool canPublish;
  final bool isMaxProposalsLimitReached;

  const ProposalBuilderState({
    this.isLoading = false,
    this.isChanging = false,
    this.error,
    this.document,
    this.metadata = const ProposalBuilderMetadata(),
    this.documentSegments = const [],
    this.commentSegments = const [],
    this.comments = const CommentsState(),
    this.guidance = const ProposalGuidance(),
    this.category,
    this.activeNodeId,
    this.validationErrors,
    this.canPublish = false,
    this.isMaxProposalsLimitReached = true,
  });

  List<Segment> get allSegments => [
    ...documentSegments,
    ...commentSegments,
  ];

  String? get proposalTitle {
    final property =
        document?.getProperty(ProposalDocument.titleNodeId) as DocumentValueProperty<String>?;

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
    commentSegments,
    comments,
    guidance,
    category,
    activeNodeId,
    validationErrors,
    canPublish,
    isMaxProposalsLimitReached,
  ];

  bool get showError => !isLoading && error != null;

  bool get showSegments => !isLoading && allSegments.isNotEmpty && error == null;

  ProposalBuilderMenuItemData buildMenuItem({
    required ProposalMenuItemAction action,
  }) {
    final latestVersion = metadata.latestVersion?.number;

    return ProposalBuilderMenuItemData(
      action: action,
      proposalTitle: proposalTitle,
      currentIteration: latestVersion ?? DocumentVersion.firstNumber,
      canPublish: canPublish,
    );
  }

  ProposalBuilderState copyWith({
    bool? isLoading,
    bool? isChanging,
    Optional<LocalizedException>? error,
    Optional<Document>? document,
    ProposalBuilderMetadata? metadata,
    List<DocumentSegment>? documentSegments,
    List<Segment>? commentSegments,
    CommentsState? comments,
    ProposalGuidance? guidance,
    Optional<CampaignCategoryDetailsViewModel>? category,
    Optional<NodeId>? activeNodeId,
    Optional<ProposalBuilderValidationErrors>? validationErrors,
    bool? canPublish,
    bool? isMaxProposalsLimitReached,
  }) {
    return ProposalBuilderState(
      isLoading: isLoading ?? this.isLoading,
      isChanging: isChanging ?? this.isChanging,
      error: error.dataOr(this.error),
      document: document.dataOr(this.document),
      metadata: metadata ?? this.metadata,
      documentSegments: documentSegments ?? this.documentSegments,
      commentSegments: commentSegments ?? this.commentSegments,
      comments: comments ?? this.comments,
      guidance: guidance ?? this.guidance,
      category: category.dataOr(this.category),
      activeNodeId: activeNodeId.dataOr(this.activeNodeId),
      validationErrors: validationErrors.dataOr(this.validationErrors),
      canPublish: canPublish ?? this.canPublish,
      isMaxProposalsLimitReached: isMaxProposalsLimitReached ?? this.isMaxProposalsLimitReached,
    );
  }
}

final class ProposalBuilderValidationErrors extends Equatable {
  final ProposalBuilderValidationStatus status;
  final ProposalBuilderValidationOrigin origin;
  final List<String> errors;

  const ProposalBuilderValidationErrors({
    required this.status,
    required this.origin,
    required this.errors,
  });

  @override
  List<Object?> get props => [status, origin, errors];

  bool get showErrors {
    switch (status) {
      case ProposalBuilderValidationStatus.notStarted:
      case ProposalBuilderValidationStatus.cleared:
        return false;
      case ProposalBuilderValidationStatus.pendingShowAll:
      case ProposalBuilderValidationStatus.pendingHideAll:
        return true;
    }
  }

  ProposalBuilderValidationErrors copyWith({
    ProposalBuilderValidationStatus? status,
    ProposalBuilderValidationOrigin? origin,
    List<String>? errors,
  }) {
    return ProposalBuilderValidationErrors(
      status: status ?? this.status,
      origin: origin ?? this.origin,
      errors: errors ?? this.errors,
    );
  }

  ProposalBuilderValidationErrors withErrorList(
    List<String> errors,
  ) {
    return copyWith(
      status: _ensureStatusMatchesErrorList(status, errors),
      errors: errors,
    );
  }

  ProposalBuilderValidationStatus _ensureStatusMatchesErrorList(
    ProposalBuilderValidationStatus status,
    List<String> errors,
  ) {
    switch (status) {
      case ProposalBuilderValidationStatus.notStarted:
      case ProposalBuilderValidationStatus.pendingShowAll:
      case ProposalBuilderValidationStatus.pendingHideAll:
        if (errors.isEmpty) {
          return ProposalBuilderValidationStatus.cleared;
        } else {
          return status;
        }

      case ProposalBuilderValidationStatus.cleared:
        if (errors.isEmpty) {
          return status;
        } else {
          return ProposalBuilderValidationStatus.pendingShowAll;
        }
    }
  }
}

enum ProposalBuilderValidationOrigin {
  shareDraft,
  submitForReview,
}

enum ProposalBuilderValidationStatus {
  notStarted,
  pendingShowAll,
  pendingHideAll,
  cleared,
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
  final DocumentNodeId nodeId;

  const ProposalGuidanceItem({
    required this.segmentTitle,
    required this.sectionTitle,
    required this.description,
    required this.nodeId,
  });

  @override
  List<Object?> get props => [
    segmentTitle,
    sectionTitle,
    description,
    nodeId,
  ];
}
