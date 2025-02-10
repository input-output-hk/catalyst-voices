import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:synchronized/synchronized.dart';

abstract interface class DocumentRepository {
  factory DocumentRepository(
    SignedDocumentLocalSource localSource,
    SignedDocumentRemoteSource remoteSource,
  ) = DocumentRepositoryImpl;

  Future<void> publishDocument(SignedDocumentData document);

  Future<ProposalDocument> getProposalDocument({
    required SignedDocumentRef ref,
  });

  Future<ProposalTemplate> getProposalTemplate({
    required SignedDocumentRef ref,
  });
}

final class DocumentRepositoryImpl implements DocumentRepository {
  final SignedDocumentLocalSource _localSource;
  final SignedDocumentRemoteSource _remoteSource;

  final _templateLock = Lock();

  DocumentRepositoryImpl(
    this._localSource,
    this._remoteSource,
  );

  @override
  Future<void> publishDocument(SignedDocumentData document) {
    throw UnimplementedError();
  }

  @override
  Future<ProposalDocument> getProposalDocument({
    required SignedDocumentRef ref,
  }) async {
    // TODO(damian-molinski): remove this override once we have API
    ref = const SignedDocumentRef(id: 'proposal');

    final signedDocumentData = await _getSignedDocumentData(ref: ref);

    assert(
      signedDocumentData.metadata.type == SignedDocumentType.proposalDocument,
      'Invalid Proposal SignedDocument type',
    );
    assert(
      signedDocumentData.metadata.template != null,
      'Proposal metadata has no template',
    );

    final templateRef = signedDocumentData.metadata.template!;

    final template = await _templateLock.synchronized(() {
      return getProposalTemplate(ref: templateRef);
    });

    final metadata = ProposalMetadata(
      id: signedDocumentData.metadata.id,
      version: signedDocumentData.metadata.version,
    );

    final data = DocumentDataDto.fromJson(signedDocumentData.content.data);
    final schema = template.schema;
    final document = DocumentDto.fromJsonSchema(data, schema).toModel();

    return ProposalDocument(
      metadata: metadata,
      document: document,
    );
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required SignedDocumentRef ref,
  }) async {
    // TODO(damian-molinski): remove this override once we have API
    ref = const SignedDocumentRef(id: 'schema');

    final signedDocument = await _getSignedDocumentData(ref: ref);

    assert(
      signedDocument.metadata.type == SignedDocumentType.proposalTemplate,
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

  Future<SignedDocumentData> _getSignedDocumentData({
    required SignedDocumentRef ref,
  }) async {
    // if version is not specified we're asking remote for latest version
    // if remote does not know about this id its probably draft so
    // local will return latest version
    if (!ref.isExact) {
      final latestVersion = await _remoteSource.getLatestVersion(ref.id);
      ref = ref.copyWith(version: Optional(latestVersion));
    }

    final isCached = await _localSource.exists(ref: ref);
    if (isCached) {
      return _localSource.get(ref: ref);
    }

    final remoteData = await _remoteSource.get(ref: ref);

    await _localSource.save(data: remoteData);

    return remoteData;
  }
}
