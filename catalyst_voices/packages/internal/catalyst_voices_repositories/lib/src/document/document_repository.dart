import 'dart:convert';
import 'dart:io';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_answers_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class DocumentRepository {
  factory DocumentRepository() = DocumentRepositoryImpl;

  Future<void> publishDocument(Document document);

  Future<Document> getDocument(String id);

  Future<DocumentSchema> getDocumentSchema(String id);
}

final class DocumentRepositoryImpl implements DocumentRepository {
  const DocumentRepositoryImpl();

  @override
  Future<void> publishDocument(Document document) {
    // TODO: implement publishDocument
    throw UnimplementedError();
  }

  @override
  Future<Document> getDocument(String id) async {
    const path = Paths.f14Proposal;
    final encodedAnswers = File(path).readAsStringSync();
    final decodedAnswers = json.decode(encodedAnswers) as Map<String, dynamic>;
    final answers = DocumentAnswersDto.fromJson(decodedAnswers);

    // TODO(damian-molinski): schema id may need to be updated
    final schemaUrl = answers.schemaUrl;
    final schema = await getDocumentSchema(schemaUrl);

    final documentDto = DocumentDto.fromJsonSchema(answers, schema);
    final document = documentDto.toModel();

    return document;
  }

  @override
  Future<DocumentSchema> getDocumentSchema(String id) async {
    const path = Paths.f14ProposalSchema;
    final encodedSchema = File(path).readAsStringSync();
    final schema = json.decode(encodedSchema) as Map<String, dynamic>;

    final documentSchemaDto = DocumentSchemaDto.fromJson(schema);
    final documentSchema = documentSchemaDto.toModel();

    return documentSchema;
  }
}
