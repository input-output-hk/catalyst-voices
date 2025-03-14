import 'dart:math';
import 'dart:typed_data';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/document/document_repository.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final _proposalDescription = """
Zanzibar is becoming one of the hotspots for DID's through
World Mobile and PRISM, but its potential is only barely exploited.
Zanzibar is becoming one of the hotspots for DID's through World Mobile
and PRISM, but its potential is only barely exploited.
"""
    .replaceAll('\n', ' ');

// TODO(LynxLynxx): remove after implementing reading db
int _maxResults(ProposalPublish? stage) {
  if (stage == null) {
    return 64;
  }
  if (stage == ProposalPublish.submittedProposal) {
    return 48;
  }
  return 32;
}

abstract interface class ProposalRepository {
  const factory ProposalRepository(DocumentRepository documentRepository) =
      ProposalRepositoryImpl;

  Future<List<String>> addFavoriteProposal(String proposalId);

  Future<DraftRef> createDraftProposal({
    required DocumentDataContent content,
    required SignedDocumentRef template,
    DraftRef? selfRef,
  });

  Future<void> deleteDraftProposal(DraftRef ref);

  Future<Uint8List> encodeProposalForExport({
    required DocumentDataMetadata metadata,
    required DocumentDataContent content,
  });

  Future<List<String>> getFavoritesProposalsIds();

  Future<ProposalData> getProposal({
    required DocumentRef ref,
  });

  /// Fetches all proposals.
  Future<ProposalsSearchResult> getProposals({
    required ProposalPaginationRequest request,
  });

  /// Returns [ProposalTemplate] for matching [ref].
  ///
  /// Source of data depends whether [ref] is [SignedDocumentRef] or [DraftRef].
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  });

  Future<List<String>> getUserProposalsIds(String userId);

  Future<DocumentRef> importProposal(Uint8List data);

  Future<List<String>> removeFavoriteProposal(String proposalId);
}

final class ProposalRepositoryImpl implements ProposalRepository {
  final DocumentRepository _documentRepository;
  const ProposalRepositoryImpl(this._documentRepository);

  @override
  Future<List<String>> addFavoriteProposal(String proposalId) async {
    // TODO(LynxLynxx): add proposal to favorites
    return getFavoritesProposalsIds();
  }

  @override
  Future<DraftRef> createDraftProposal({
    required DocumentDataContent content,
    required SignedDocumentRef template,
    DraftRef? selfRef,
  }) {
    return _documentRepository.createDocumentDraft(
      type: DocumentType.proposalDocument,
      content: content,
      template: template,
      selfRef: selfRef,
    );
  }

  @override
  Future<void> deleteDraftProposal(DraftRef ref) {
    return _documentRepository.deleteDocumentDraft(ref: ref);
  }

  @override
  Future<Uint8List> encodeProposalForExport({
    required DocumentDataMetadata metadata,
    required DocumentDataContent content,
  }) {
    return _documentRepository.encodeDocumentForExport(
      metadata: metadata,
      content: content,
    );
  }

  @override
  Future<List<String>> getFavoritesProposalsIds() async {
    // TODO(LynxLynxx): read db to get favorites proposals ids
    return <String>[];
  }

  @override
  Future<ProposalData> getProposal({
    required DocumentRef ref,
  }) async {
    final documentData = await _documentRepository.getDocumentData(ref: ref);
    final commentsCount = await _documentRepository.getRefCount(
      ref: ref,
      type: DocumentType.commentTemplate,
    );
    final templateRef = documentData.metadata.template!;
    final documentTemplate =
        await _documentRepository.getDocumentData(ref: templateRef);
    final proposalDocument = _buildProposalDocument(
      documentData: documentData,
      templateData: documentTemplate,
    );
    final documentVersions = await _documentRepository.getAllVersionsOfId(
      id: ref.id,
    );
    final proposalVersions = documentVersions
        .map(
          (e) => _buildProposalData(
            documentData: e,
            documentTemplate: documentTemplate,
          ),
        )
        .toList();

    return ProposalData(
      document: proposalDocument,
      categoryId: documentData.metadata.categoryId ?? '',
      commentsCount: commentsCount,
      versions: proposalVersions,
    );
  }

  @override
  Future<ProposalsSearchResult> getProposals({
    required ProposalPaginationRequest request,
  }) async {
    // optionally filter by status.
    final proposals = <Proposal>[];

    // Return users proposals match his account id with proposals metadata from
    // author field.
    if (request.usersProposals) {
      return _getUserProposalsSearchResult(request);
    } else if (request.usersFavorite) {
      return _getFavoritesProposalsSearchResult(request);
    }

    for (var i = 0; i < request.pageSize; i++) {
      // ignore: lines_longer_than_80_chars
      final stage = Random().nextBool()
          ? ProposalPublish.submittedProposal
          : ProposalPublish.publishedDraft;
      proposals.add(
        Proposal(
          selfRef: SignedDocumentRef.generateFirstRef(),
          category: 'Cardano Use Cases / MVP',
          title: 'Proposal Title that rocks the world',
          updateDate: DateTime.now().minusDays(2),
          fundsRequested: Coin.fromAda(100000),
          status: ProposalStatus.draft,
          publish: request.stage ?? stage,
          commentsCount: 0,
          description: _proposalDescription,
          duration: 6,
          author: 'Alex Wells',
          versions: const [],
        ),
      );
    }

    return ProposalsSearchResult(
      maxResults: _maxResults(request.stage),
      proposals: proposals,
    );
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  }) async {
    final proposalDocument =
        await _documentRepository.getDocumentData(ref: ref);

    return _buildProposalTemplate(documentData: proposalDocument);
  }

  @override
  Future<List<String>> getUserProposalsIds(String userId) async {
    // TODO(LynxLynxx): read db to get user's proposals
    return <String>[];
  }

  @override
  Future<DocumentRef> importProposal(Uint8List data) {
    return _documentRepository.importDocument(data: data);
  }

  @override
  Future<List<String>> removeFavoriteProposal(String proposalId) async {
    // TODO(LynxLynxx): remove proposal from favorites
    return getFavoritesProposalsIds();
  }

  BaseProposalData _buildProposalData({
    required DocumentData documentData,
    required DocumentData documentTemplate,
  }) {
    assert(
      documentData.metadata.type == DocumentType.proposalDocument,
      'Not a proposalDocument document data type',
    );

    final document = _buildProposalDocument(
      documentData: documentData,
      templateData: documentTemplate,
    );

    return BaseProposalData(
      document: document,
    );
  }

  ProposalDocument _buildProposalDocument({
    required DocumentData documentData,
    required DocumentData templateData,
  }) {
    assert(
      documentData.metadata.type == DocumentType.proposalDocument,
      'Not a proposalDocument document data type',
    );

    final template = _buildProposalTemplate(documentData: templateData);

    final metadata = ProposalMetadata(
      selfRef: documentData.metadata.selfRef,
    );

    final content = DocumentDataContentDto.fromModel(
      documentData.content,
    );
    final schema = template.schema;
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

  Future<ProposalsSearchResult> _getFavoritesProposalsSearchResult(
    ProposalPaginationRequest request,
  ) async {
    final favoritesIds = await getFavoritesProposalsIds();
    final proposals = <Proposal>[];
    final range = PagingRange.calculateRange(
      pageKey: request.pageKey,
      itemsPerPage: request.pageSize,
      maxResults: favoritesIds.length,
    );
    if (favoritesIds.isEmpty) {
      return const ProposalsSearchResult(
        maxResults: 0,
        proposals: [],
      );
    }
    for (var i = range.from; i <= range.to; i++) {
      final ref = SignedDocumentRef(id: favoritesIds[i]);
      final proposalData = await getProposal(ref: ref);
      final proposal = Proposal.fromData(proposalData);
      proposals.add(proposal);
    }

    return ProposalsSearchResult(
      maxResults: favoritesIds.length,
      proposals: proposals,
    );
  }

  Future<ProposalsSearchResult> _getUserProposalsSearchResult(
    ProposalPaginationRequest request,
  ) async {
    final userProposalsIds = await getUserProposalsIds('');
    final proposals = <Proposal>[];
    final range = PagingRange.calculateRange(
      pageKey: request.pageKey,
      itemsPerPage: request.pageSize,
      maxResults: userProposalsIds.length,
    );
    if (userProposalsIds.isEmpty) {
      return const ProposalsSearchResult(
        maxResults: 0,
        proposals: [],
      );
    }
    for (var i = range.from; i <= range.to; i++) {
      final ref = SignedDocumentRef(id: userProposalsIds[i]);
      final proposalData = await getProposal(ref: ref);
      final proposal = Proposal.fromData(proposalData);
      proposals.add(proposal);
    }

    return ProposalsSearchResult(
      maxResults: userProposalsIds.length,
      proposals: proposals,
    );
  }
}
