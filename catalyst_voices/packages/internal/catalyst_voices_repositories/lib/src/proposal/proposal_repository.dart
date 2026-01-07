import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:catalyst_voices_repositories/src/proposal/proposal_document_factory.dart';
import 'package:catalyst_voices_repositories/src/proposal/proposal_template_factory.dart';
import 'package:rxdart/rxdart.dart';

/// Base interface to interact with proposals. A specialized version of [DocumentRepository] which
/// provides additional methods specific to proposals.
abstract interface class ProposalRepository {
  const factory ProposalRepository(
    SignedDocumentManager signedDocumentManager,
    DocumentRepository documentRepository,
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

  /// Returns [ProposalTemplate] which belongs to [category].
  ///
  /// Returns null if no matching template is found.
  Future<ProposalTemplate?> getProposalTemplate({
    required DocumentRef category,
  });

  Future<void> publishProposal({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });

  Future<void> publishProposalAction({
    required DocumentDataMetadata metadata,
    required ProposalSubmissionAction action,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });

  Future<List<ProposalDocument>> queryVersionsOfId({
    required String id,
    bool includeLocalDrafts = false,
  });

  Future<void> updateProposalFavorite({
    required String id,
    required bool isFavorite,
  });

  Future<void> upsertDraftProposal({required DocumentData document});

  Stream<int> watchCommentsCount({
    DocumentRef? referencing,
  });

  Stream<List<ProposalDocument>> watchLatestProposals({int? limit});

  /// Watches for [ProposalSubmissionAction] that were made on [referencing] document.
  ///
  /// As making action on document not always creates a new document ref
  /// we need to watch for actions on a document that has a reference to
  /// [referencing] document.
  Stream<ProposalPublish?> watchProposalPublish({
    required DocumentRef referencing,
  });

  Stream<Page<JoinedProposalBriefData>> watchProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });

  Stream<int> watchProposalsCountV2({
    ProposalsFiltersV2 filters,
  });

  Stream<List<ProposalTemplate>> watchProposalTemplates({
    required CampaignFilters campaign,
  });

  Stream<List<ProposalDocument>> watchUserProposals({
    required CatalystId authorId,
  });
}

final class ProposalRepositoryImpl implements ProposalRepository {
  final SignedDocumentManager _signedDocumentManager;
  final DocumentRepository _documentRepository;
  final ProposalDocumentDataLocalSource _proposalsLocalSource;

  const ProposalRepositoryImpl(
    this._signedDocumentManager,
    this._documentRepository,
    this._proposalsLocalSource,
  );

  @override
  Future<void> deleteDraftProposal(DraftRef ref) {
    return _documentRepository.deleteDocumentDraft(id: ref);
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
    final documentData = await _documentRepository.getDocumentData(id: ref);
    final commentsCount = await _documentRepository.getRefCount(
      referencing: ref,
      type: DocumentType.commentDocument,
    );
    final proposalPublish = await getProposalPublishForRef(ref: ref);
    if (proposalPublish == null) {
      throw const NotFoundException(message: 'Proposal is hidden');
    }
    final templateRef = documentData.metadata.template!;
    final documentTemplate = await _documentRepository.getDocumentData(id: templateRef);
    final proposalDocument = _buildProposalDocument(
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
      referencing: ref,
      type: DocumentType.proposalActionDocument,
    );

    final action = _buildProposalActionData(data);
    return _getProposalPublish(ref: ref, action: action);
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef category,
  }) async {
    // TODO(damian-molinski): Implement it
    final documentData = await _documentRepository.getDocumentData(id: ref);

    return ProposalTemplateFactory.create(documentData);
  }

  @override
  Future<void> publishProposal({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(document.content.data),
      metadata: document.metadata,
      catalystId: catalystId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: signedDocument);
  }

  @override
  Future<void> publishProposalAction({
    required DocumentDataMetadata metadata,
    required ProposalSubmissionAction action,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final dto = ProposalSubmissionActionDocumentDto(
      action: ProposalSubmissionActionDto.fromModel(action),
    );

    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(dto.toJson()),
      metadata: metadata,
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
        .toList();
  }

  @override
  Future<void> updateProposalFavorite({
    required String id,
    required bool isFavorite,
  }) {
    return _proposalsLocalSource.updateProposalFavorite(id: id, isFavorite: isFavorite);
  }

  @override
  Future<void> upsertDraftProposal({required DocumentData document}) {
    return _documentRepository.upsertLocalDraftDocument(document: document);
  }

  @override
  Stream<int> watchCommentsCount({
    DocumentRef? referencing,
  }) {
    return _documentRepository.watchCount(
      referencing: referencing,
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
          ).toList(),
        );
  }

  @override
  Stream<ProposalPublish?> watchProposalPublish({
    required DocumentRef referencing,
  }) {
    return _documentRepository
        .watchRefToDocumentData(
          referencing: referencing,
          type: DocumentType.proposalActionDocument,
        )
        .map((data) {
          final action = _buildProposalActionData(data);

          return _getProposalPublish(ref: referencing, action: action);
        });
  }

  @override
  Stream<Page<JoinedProposalBriefData>> watchProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order = const UpdateDate.desc(),
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    return _proposalsLocalSource.watchProposalsBriefPage(
      request: request,
      order: order,
      filters: filters,
    );
  }

  @override
  Stream<int> watchProposalsCountV2({
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    return _proposalsLocalSource.watchProposalsCountV2(filters: filters);
  }

  @override
  Stream<List<ProposalTemplate>> watchProposalTemplates({
    required CampaignFilters campaign,
  }) {
    return _proposalsLocalSource
        .watchProposalTemplates(campaign: campaign)
        .map((event) => event.map(ProposalTemplateFactory.create).toList());
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
        .map(
          (documents) => documents.map(
            (doc) {
              final documentData = doc.data;
              final templateData = doc.refData;

              return _buildProposalDocument(
                documentData: documentData,
                templateData: templateData,
              );
            },
          ).toList(),
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

  ProposalDocument _buildProposalDocument({
    required DocumentData documentData,
    required DocumentData templateData,
  }) {
    final template = ProposalTemplateFactory.create(templateData);
    final proposal = ProposalDocumentFactory.create(documentData, template: template);
    return proposal;
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
