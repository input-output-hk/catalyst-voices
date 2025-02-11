import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/document/document_repository.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

void main() {
  late DocumentRepositoryImpl repository;

  late DriftCatalystDatabase database;

  late DraftDataSource draftsSource;
  late DocumentDataLocalSource localDocuments;
  late DocumentDataRemoteSource remoteDocuments;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    database = DriftCatalystDatabase(inMemory);

    draftsSource = DatabaseDraftsDataSource(database);
    localDocuments = DatabaseDocumentsDataSource(database);
    remoteDocuments = _MockDocumentDataRemoteSource();

    repository = DocumentRepositoryImpl(
      draftsSource,
      localDocuments,
      remoteDocuments,
    );
  });

  tearDown(() async {
    await database.close();
  });

  group(DocumentRepository, () {
    group('getDocumentData', () {
      test('remote source is called only once for same document', () async {
        // Given
        final id = const Uuid().v7();
        final version = id;

        final documentData = DocumentData(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            id: id,
            version: version,
          ),
          content: const DocumentDataContent({}),
        );

        final ref = DocumentRef(id: id, version: version);

        when(() => remoteDocuments.get(ref: ref))
            .thenAnswer((_) => Future.value(documentData));

        // When
        await repository.getDocumentData(ref: ref);
        await repository.getDocumentData(ref: ref);

        // Then
        verify(() => remoteDocuments.get(ref: ref)).called(1);
      });

      test('latest version is called when ref is not exact ', () async {
        // Given
        final id = const Uuid().v7();
        final version = id;

        final documentData = DocumentData(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            id: id,
            version: version,
          ),
          content: const DocumentDataContent({}),
        );

        final ref = DocumentRef(id: id);
        final exactRef = ref.copyWith(version: Optional(version));

        when(() => remoteDocuments.getLatestVersion(id))
            .thenAnswer((_) => Future.value(version));

        when(() => remoteDocuments.get(ref: exactRef))
            .thenAnswer((_) => Future.value(documentData));

        // When
        await repository.getDocumentData(ref: ref);

        // Then
        verify(() => remoteDocuments.getLatestVersion(id)).called(1);
        verify(() => remoteDocuments.get(ref: exactRef)).called(1);
      });
    });

    group('watchProposalDocument', () {
      test('description', () async {
        // Given
        // TODO(damian-molinski): remove mocked ids when api integrated.
        final templateRef = DocumentRef(
          id: mockedTemplateUuid,
          version: const Uuid().v7(),
        );
        final proposalRef = DocumentRef(
          id: mockedTemplateUuid,
          version: const Uuid().v7(),
        );

        when(() => remoteDocuments.get(ref: templateRef)).thenAnswer((_) {
          return _buildProposalTemplate(
            id: templateRef.id,
            version: templateRef.version,
          );
        });
        when(() => remoteDocuments.get(ref: proposalRef)).thenAnswer((_) {
          return _buildProposal(
            id: proposalRef.id,
            version: proposalRef.version,
            template: templateRef,
          );
        });

        // When
        final proposalStream = repository.watchProposalDocument(
          ref: proposalRef,
        );

        // Then
        expect(
          proposalStream,
          emitsThrough([
            isNotNull,
          ]),
        );
      });
    });
  });
}

Future<DocumentData> _buildProposalTemplate({
  String? id,
  String? version,
}) async {
  final rawContent = await VoicesDocumentsTemplates.proposalF14Schema;

  final metadata = DocumentDataMetadata(
    type: DocumentType.proposalTemplate,
    id: id ?? const Uuid().v7(),
    version: version ?? const Uuid().v7(),
  );

  final content = DocumentDataContent(rawContent);

  return DocumentData(
    metadata: metadata,
    content: content,
  );
}

Future<DocumentData> _buildProposal({
  String? id,
  String? version,
  DocumentRef? template,
}) async {
  final rawContent = await VoicesDocumentsTemplates.proposalF14Document;

  final metadata = DocumentDataMetadata(
    type: DocumentType.proposalDocument,
    id: id ?? const Uuid().v7(),
    version: version ?? const Uuid().v7(),
    template: template ??
        DocumentRef(
          id: const Uuid().v7(),
          version: const Uuid().v7(),
        ),
  );

  final content = DocumentDataContent(rawContent);

  return DocumentData(
    metadata: metadata,
    content: content,
  );
}

class _MockDocumentDataRemoteSource extends Mock
    implements DocumentDataRemoteSource {}
