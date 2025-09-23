import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:rxdart/rxdart.dart';

/// Base interface to interact with proposals. A specialized version of [DocumentRepository] which
/// provides additional methods specific to proposals.
abstract interface class ProposalRepository {
  const factory ProposalRepository(
    SignedDocumentManager signedDocumentManager,
    DocumentRepository documentRepository,
    CampaignRepository campaignRepository,
    ProposalDocumentDataLocalSource proposalsLocalSource,
  ) = ProposalRepositoryImpl;

  Future<void> deleteDraftProposal(DraftRef ref);

  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
  });

  Future<ProposalData> getProposal({
    required DocumentRef ref,
  });

  Future<ProposalPublish?> getProposalPublishForRef({
    required DocumentRef ref,
  });

  Future<List<ProposalData>> getProposals({
    SignedDocumentRef? categoryRef,
    required ProposalsFilterType type,
  });

  /// Fetches all proposals for page matching [request] as well as
  /// [filters].
  Future<Page<ProposalData>> getProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  });

  /// Returns [ProposalTemplate] for matching [ref].
  ///
  /// Source of data depends whether [ref] is [SignedDocumentRef] or [DraftRef].
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  });

  Future<void> publishProposal({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });

  Future<void> publishProposalAction({
    required SignedDocumentRef actionRef,
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef categoryId,
    required ProposalSubmissionAction action,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });

  Future<List<ProposalDocument>> queryVersionsOfId({
    required String id,
    bool includeLocalDrafts = false,
  });

  Future<void> upsertDraftProposal({required DocumentData document});

  Stream<int> watchCommentsCount({
    DocumentRef? refTo,
  });

  Stream<List<ProposalDocument>> watchLatestProposals({int? limit});

  /// Watches for [ProposalSubmissionAction] that were made on [refTo] document.
  ///
  /// As making action on document not always creates a new document ref
  /// we need to watch for actions on a document that has a reference to
  /// [refTo] document.
  Stream<ProposalPublish?> watchProposalPublish({
    required DocumentRef refTo,
  });

  Stream<ProposalsCount> watchProposalsCount({
    required ProposalsCountFilters filters,
  });

  Stream<Page<ProposalData>> watchProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  });

  Stream<List<ProposalDocument>> watchUserProposals({
    required CatalystId authorId,
  });
}

final class ProposalRepositoryImpl implements ProposalRepository {
  final SignedDocumentManager _signedDocumentManager;
  final DocumentRepository _documentRepository;
  final CampaignRepository _campaignRepository;
  final ProposalDocumentDataLocalSource _proposalsLocalSource;

  const ProposalRepositoryImpl(
    this._signedDocumentManager,
    this._documentRepository,
    this._campaignRepository,
    this._proposalsLocalSource,
  );

  @override
  Future<void> deleteDraftProposal(DraftRef ref) {
    return _documentRepository.deleteDocumentDraft(ref: ref);
  }

  @override
  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
  }) {
    return _documentRepository.encodeDocumentForExport(
      document: document,
    );
  }

  @override
  Future<ProposalData> getProposal({
    required DocumentRef ref,
  }) async {
    final documentData = await _documentRepository.getDocumentData(ref: ref);
    final commentsCount = await _documentRepository.getRefCount(
      ref: ref,
      type: DocumentType.commentDocument,
    );
    final proposalPublish = await getProposalPublishForRef(ref: ref);
    if (proposalPublish == null) {
      throw const NotFoundException(message: 'Proposal is hidden');
    }
    final templateRef = documentData.metadata.template!;
    final documentTemplate = await _documentRepository.getDocumentData(ref: templateRef);
    final proposalDocument = await _buildProposalDocument(
      documentData: documentData,
      templateData: documentTemplate,
    );

    return ProposalData(
      document: proposalDocument,
      commentsCount: commentsCount,
      publish: proposalPublish,
    );
  }

  @override
  Future<ProposalPublish?> getProposalPublishForRef({
    required DocumentRef ref,
  }) async {
    final data = await _documentRepository.getRefToDocumentData(
      refTo: ref,
      type: DocumentType.proposalActionDocument,
    );

    final action = _buildProposalActionData(data);
    return _getProposalPublish(ref: ref, action: action);
  }

  @override
  Future<List<ProposalData>> getProposals({
    SignedDocumentRef? categoryRef,
    required ProposalsFilterType type,
  }) async {
    return _proposalsLocalSource
        .getProposals(type: type, categoryRef: categoryRef)
        .then((value) => value.map(_buildProposalData).wait);
  }

  @override
  Future<Page<ProposalData>> getProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  }) {
    return _proposalsLocalSource
        .getProposalsPage(request: request, filters: filters, order: order)
        .then((value) => value.asyncMap(_buildProposalData));
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  }) async {
    final proposalDocument = await _documentRepository.getDocumentData(ref: ref);

    return _buildProposalTemplate(documentData: proposalDocument);
  }

  @override
  Future<void> publishProposal({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(document.content.data),
      metadata: _createProposalMetadata(document.metadata),
      catalystId: catalystId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: signedDocument);
  }

  @override
  Future<void> publishProposalAction({
    required SignedDocumentRef actionRef,
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef categoryId,
    required ProposalSubmissionAction action,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final dto = ProposalSubmissionActionDocumentDto(
      action: ProposalSubmissionActionDto.fromModel(action),
    );
    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(dto.toJson()),
      metadata: SignedDocumentMetadata(
        contentType: SignedDocumentContentType.json,
        documentType: DocumentType.proposalActionDocument,
        id: actionRef.id,
        ver: actionRef.version,
        ref: SignedDocumentMetadataRef.fromDocumentRef(proposalRef),
        categoryId: SignedDocumentMetadataRef.fromDocumentRef(categoryId),
      ),
      catalystId: catalystId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: signedDocument);
  }

  @override
  Future<List<ProposalDocument>> queryVersionsOfId({
    required String id,
    bool includeLocalDrafts = false,
  }) async {
    final documents = await _documentRepository.queryVersionsOfId(
      id: id,
      includeLocalDrafts: includeLocalDrafts,
    );

    return documents
        .map(
          (e) => _buildProposalDocument(
            documentData: e.data,
            templateData: e.refData,
          ),
        )
        .wait;
  }

  @override
  Future<void> upsertDraftProposal({required DocumentData document}) {
    return _documentRepository.upsertDocument(document: document);
  }

  @override
  Stream<int> watchCommentsCount({
    DocumentRef? refTo,
  }) {
    return _documentRepository.watchCount(
      refTo: refTo,
      type: DocumentType.commentDocument,
    );
  }

  @override
  Stream<List<ProposalDocument>> watchLatestProposals({int? limit}) {
    return _documentRepository
        .watchDocuments(
          limit: limit,
          unique: true,
          type: DocumentType.proposalDocument,
        )
        .asyncMap(
          (documents) => documents.map(
            (doc) {
              final documentData = doc.data;
              final templateData = doc.refData;

              return _buildProposalDocument(
                documentData: documentData,
                templateData: templateData,
              );
            },
          ).wait,
        );
  }

  @override
  Stream<ProposalPublish?> watchProposalPublish({
    required DocumentRef refTo,
  }) {
    return _documentRepository
        .watchRefToDocumentData(
          refTo: refTo,
          type: DocumentType.proposalActionDocument,
        )
        .map((data) {
          final action = _buildProposalActionData(data);

          return _getProposalPublish(ref: refTo, action: action);
        });
  }

  @override
  Stream<ProposalsCount> watchProposalsCount({
    required ProposalsCountFilters filters,
  }) {
    return _proposalsLocalSource.watchProposalsCount(filters: filters);
  }

  @override
  Stream<Page<ProposalData>> watchProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  }) {
    return _proposalsLocalSource
        .watchProposalsPage(request: request, filters: filters, order: order)
        .asyncMap((value) => value.asyncMap(_buildProposalData));
  }

  @override
  Stream<List<ProposalDocument>> watchUserProposals({
    required CatalystId authorId,
  }) {
    return _documentRepository
        .watchDocuments(
          type: DocumentType.proposalDocument,
          getLocalDrafts: true,
          unique: true,
          authorId: authorId,
        )
        .whereNotNull()
        .asyncMap(
          (documents) => documents.map(
            (doc) {
              final documentData = doc.data;
              final templateData = doc.refData;

              return _buildProposalDocument(
                documentData: documentData,
                templateData: templateData,
              );
            },
          ).wait,
        );
  }

  ProposalSubmissionAction? _buildProposalActionData(
    DocumentData? action,
  ) {
    if (action == null) {
      return null;
    }
    final dto = ProposalSubmissionActionDocumentDto.fromJson(action.content.data);
    return dto.action.toModel();
  }

  Future<ProposalData> _buildProposalData(ProposalDocumentData data) async {
    final action = _buildProposalActionData(data.action);

    final publish = switch (action) {
      ProposalSubmissionAction.aFinal => ProposalPublish.submittedProposal,
      ProposalSubmissionAction.draft || null => ProposalPublish.publishedDraft,
      ProposalSubmissionAction.hide => throw ArgumentError(
        'Proposal(${data.proposal.metadata.selfRef}) is '
        'unsupported ${ProposalSubmissionAction.hide}. Make sure to filter '
        'out hidden proposals before this code is reached.',
      ),
    };

    final document = await _buildProposalDocument(
      documentData: data.proposal,
      templateData: data.template,
    );

    return ProposalData(
      document: document,
      publish: publish,
      commentsCount: data.commentsCount,
    );
  }

  Future<ProposalDocument> _buildProposalDocument({
    required DocumentData documentData,
    required DocumentData templateData,
  }) async {
    assert(
      documentData.metadata.type == DocumentType.proposalDocument,
      'Not a proposalDocument document data type',
    );

    final currency = await _getProposalCurrency(
      documentData.metadata.categoryId ?? templateData.metadata.categoryId,
    );

    final metadata = ProposalMetadata(
      selfRef: documentData.metadata.selfRef,
      templateRef: documentData.metadata.template!,
      categoryId: documentData.metadata.categoryId!,
      authors: documentData.metadata.authors ?? [],
      currency: currency,
    );

    final template = _buildProposalTemplate(documentData: templateData);
    final schema = template.schema;
    final content = DocumentDataContentDto.fromModel(documentData.content);
    final document = DocumentDto.fromJsonSchema(content, schema).toModel();

    return ProposalDocument(
      metadata: metadata,
      document: document,
    );
  }

  ProposalTemplate _buildProposalTemplate({
    required DocumentData documentData,
  }) {
    assert(
      documentData.metadata.type == DocumentType.proposalTemplate,
      'Not a proposalTemplate document data type',
    );

    final metadata = ProposalTemplateMetadata(
      selfRef: documentData.metadata.selfRef,
    );

    final contentData = documentData.content.data;
    final schema = DocumentSchemaDto.fromJson(contentData).toModel();

    return ProposalTemplate(
      metadata: metadata,
      schema: schema,
    );
  }

  SignedDocumentMetadata _createProposalMetadata(
    DocumentDataMetadata metadata,
  ) {
    final template = metadata.template;
    final categoryId = metadata.categoryId;

    return SignedDocumentMetadata(
      contentType: SignedDocumentContentType.json,
      documentType: DocumentType.proposalDocument,
      id: metadata.id,
      ver: metadata.version,
      template: template == null ? null : SignedDocumentMetadataRef.fromDocumentRef(template),
      categoryId: categoryId == null ? null : SignedDocumentMetadataRef.fromDocumentRef(categoryId),
    );
  }

  Future<Currency> _getProposalCurrency(SignedDocumentRef? categoryRef) async {
    final category = categoryRef != null
        ? await _campaignRepository.getCategory(categoryRef)
        : null;

    return category?.currency ?? const Currency.fallback();
  }

  ProposalPublish? _getProposalPublish({
    required DocumentRef ref,
    required ProposalSubmissionAction? action,
  }) {
    if (ref is DraftRef) {
      return ProposalPublish.localDraft;
    } else {
      return switch (action) {
        ProposalSubmissionAction.aFinal => ProposalPublish.submittedProposal,
        ProposalSubmissionAction.hide => null,
        ProposalSubmissionAction.draft || null => ProposalPublish.publishedDraft,
      };
    }
  }
}
