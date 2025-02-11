import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

abstract interface class DocumentRepository {
  factory DocumentRepository(
    DraftDataSource drafts,
    DocumentDataLocalSource localDocuments,
    DocumentDataRemoteSource remoteDocuments,
  ) = DocumentRepositoryImpl;

  Stream<ProposalDocument?> watchProposalDocument({
    required DocumentRef ref,
  });

  Future<ProposalDocument> getProposalDocument({
    required DocumentRef ref,
  });

  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  });
}

final class DocumentRepositoryImpl implements DocumentRepository {
  // ignore: unused_field
  final DraftDataSource _drafts;
  final DocumentDataLocalSource _localDocuments;
  final DocumentDataRemoteSource _remoteDocuments;

  final _templateLock = Lock();

  DocumentRepositoryImpl(
    this._drafts,
    this._localDocuments,
    this._remoteDocuments,
  );

  @override
  Stream<ProposalDocument?> watchProposalDocument({
    required DocumentRef ref,
  }) {
    // TODO(damian-molinski): remove this override once we have API
    ref = const DocumentRef(id: mockedDocumentUuid);

    return _watchDocumentData(ref: ref).asyncMap(
      (documentData) async {
        if (documentData == null) {
          return null;
        }

        return _buildProposalDocument(from: documentData);
      },
    );
  }

  @override
  Future<ProposalDocument> getProposalDocument({
    required DocumentRef ref,
  }) async {
    // TODO(damian-molinski): remove this override once we have API
    ref = const DocumentRef(id: mockedDocumentUuid);

    final documentData = await getDocumentData(ref: ref);

    return _buildProposalDocument(from: documentData);
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  }) async {
    // TODO(damian-molinski): remove this override once we have API
    ref = const DocumentRef(id: mockedTemplateUuid);

    final signedDocument = await getDocumentData(ref: ref);

    assert(
      signedDocument.metadata.type == DocumentType.proposalTemplate,
      'Invalid SignedDocument type',
    );

    final metadata = ProposalTemplateMetadata(
      id: signedDocument.metadata.id,
      version: signedDocument.metadata.version,
    );

    final json = signedDocument.content.data;
    final schema = DocumentSchemaDto.fromJson(json).toModel();

    return ProposalTemplate(
      metadata: metadata,
      schema: schema,
    );
  }

  Future<ProposalDocument> _buildProposalDocument({
    required DocumentData from,
  }) async {
    assert(
      from.metadata.type == DocumentType.proposalDocument,
      'Invalid Proposal SignedDocument type',
    );
    assert(
      from.metadata.template != null,
      'Proposal metadata has no template',
    );

    final templateRef = from.metadata.template!;

    final template = await _templateLock.synchronized(() {
      return getProposalTemplate(ref: templateRef);
    });

    final metadata = ProposalMetadata(
      id: from.metadata.id,
      version: from.metadata.version,
    );

    final content = DocumentDataContentDto.fromModel(
      from.content,
    );
    final schema = template.schema;
    final document = DocumentDto.fromJsonSchema(content, schema).toModel();

    return ProposalDocument(
      metadata: metadata,
      document: document,
    );
  }

  Stream<DocumentData?> _watchDocumentData({
    required DocumentRef ref,
  }) {
    /// Make sure we're update to date with document ref.
    // ignore: discarded_futures
    getDocumentData(ref: ref).ignore();

    return _localDocuments.watch(ref: ref);
  }

  @visibleForTesting
  Future<DocumentData> getDocumentData({
    required DocumentRef ref,
  }) async {
    // if version is not specified we're asking remote for latest version
    // if remote does not know about this id its probably draft so
    // local will return latest version
    if (!ref.isExact) {
      final latestVersion = await _remoteDocuments.getLatestVersion(ref.id);
      ref = ref.copyWith(version: Optional(latestVersion));
    }

    final isCached = await _localDocuments.exists(ref: ref);
    if (isCached) {
      return _localDocuments.get(ref: ref);
    }

    final remoteData = await _remoteDocuments.get(ref: ref);

    await _localDocuments.save(data: remoteData);

    return remoteData;
  }
}
