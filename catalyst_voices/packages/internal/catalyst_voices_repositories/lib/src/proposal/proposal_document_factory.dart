import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';

abstract final class ProposalDocumentFactory {
  ProposalDocumentFactory._();

  static ProposalDocument create(
    DocumentData documentData, {
    required ProposalTemplate template,
  }) {
    assert(
      documentData.metadata.type == DocumentType.proposalDocument,
      'Not a proposalDocument document data type',
    );

    final metadata = ProposalMetadata(
      id: documentData.metadata.id,
      templateRef: documentData.metadata.template!,
      parameters: documentData.metadata.parameters,
      authors: documentData.metadata.authors ?? [],
    );

    final schema = template.schema;
    final content = DocumentDataContentDto.fromModel(documentData.content);
    final document = DocumentDto.fromJsonSchema(content, schema).toModel();

    return ProposalDocument(
      metadata: metadata,
      document: document,
    );
  }
}
