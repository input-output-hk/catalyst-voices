import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

abstract interface class DocumentRepository {
  factory DocumentRepository(
    SignedDocumentManager signedDocumentManager,
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
  // ignore: unused_field
  final SignedDocumentManager _signedDocumentManager;

  final _proposalTemplateLock = Lock();

  DocumentRepositoryImpl(
    this._signedDocumentManager,
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

    final template = await _proposalTemplateLock.synchronized(() {
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

    final signedDocumentData = await _getSignedDocumentData(ref: ref);

    assert(
      signedDocumentData.metadata.type == SignedDocumentType.proposalTemplate,
      'Invalid SignedDocument type',
    );

    final metadata = ProposalTemplateMetadata(
      id: signedDocumentData.metadata.id,
      version: signedDocumentData.metadata.version,
    );

    final json = signedDocumentData.content.data;
    final schema = DocumentSchemaDto.fromJson(json).toModel();

    return ProposalTemplate(
      metadata: metadata,
      schema: schema,
    );
  }

  // TODO(damian-molinski): should return SignedDocument.
  // TODO(damian-molinski): make API call.
  // TODO(damian-molinski): implement caching.
  Future<SignedDocumentData> _getSignedDocumentData({
    required SignedDocumentRef ref,
  }) async {
    final isSchema = ref.id == 'schema';

    final signedDocument = await (isSchema
        ? VoicesDocumentsTemplates.proposalF14Schema
        : VoicesDocumentsTemplates.proposalF14Document);

    final type = isSchema
        ? SignedDocumentType.proposalTemplate
        : SignedDocumentType.proposalDocument;
    final ver = ref.version ?? const Uuid().v7();
    final template = !isSchema ? const SignedDocumentRef(id: 'schema') : null;

    final metadata = SignedDocumentMetadata(
      type: type,
      id: ref.id,
      version: ver,
      template: template,
    );

    final content = SignedDocumentContent(signedDocument);

    return SignedDocumentData(
      metadata: metadata,
      content: content,
    );
  }
}
