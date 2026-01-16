import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/document/document_repository.dart';
import 'package:catalyst_voices_repositories/src/dto/document_data_with_ref_dat.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixture/signed_document/signed_document_test_data.dart';
import '../../fixture/voices_document_templates.dart';
import '../database/connection/test_connection.dart';
import '../database/drift_test_platforms.dart';

void main() {
  // this is required only by VoicesDocumentsTemplates
  TestWidgetsFlutterBinding.ensureInitialized();

  late DocumentRepositoryImpl repository;

  late DriftCatalystDatabase database;

  late DraftDataSource draftsSource;
  late SignedDocumentDataSource localDocuments;
  late DocumentDataRemoteSource remoteDocuments;

  setUp(() async {
    final connection = await buildTestConnection();
    database = DriftCatalystDatabase(connection);

    draftsSource = DatabaseDraftsDataSource(database);
    localDocuments = DatabaseDocumentsDataSource(database, const CatalystProfiler.noop());
    remoteDocuments = _MockDocumentDataRemoteSource();

    repository = DocumentRepositoryImpl(
      database,
      draftsSource,
      localDocuments,
      remoteDocuments,
    );
  });

  tearDown(() async {
    await database.close();
  });

  group(DocumentRepository, () {
    // TODO(LynxLynxx): change test to new implementation
    test(
      'getDocument returns correct model',
      () async {
        // Given
        final templateData = await VoicesDocumentsTemplates.proposalF14Schema;
        final proposalData = await VoicesDocumentsTemplates.proposalF14Document;

        final templateRef = SignedDocumentRef.first(DocumentRefFactory.randomUuidV7());
        final template = DocumentDataFactory.build(
          id: templateRef,
          type: DocumentType.proposalTemplate,
          content: DocumentDataContent(templateData),
        );
        final proposal = DocumentDataFactory.build(
          id: SignedDocumentRef.first(DocumentRefFactory.randomUuidV7()),
          template: templateRef,
          content: DocumentDataContent(proposalData),
        );

        when(
          () => remoteDocuments.get(template.id),
        ).thenAnswer((_) => Future.value(template));
        when(
          () => remoteDocuments.get(proposal.id),
        ).thenAnswer((_) => Future.value(proposal));

        // When
        final ref = proposal.id;
        final proposalDocument = await repository.getDocumentData(
          id: ref,
        );

        // Then
        expect(
          proposalDocument.metadata.id,
          proposal.metadata.id,
        );
      },
      onPlatform: driftOnPlatforms,
    );

    test(
      'getDocument correctly propagates errors',
      () async {
        // Given
        final templateRef = DocumentRefFactory.signedDocumentRef();
        final proposal = DocumentDataFactory.build(
          id: SignedDocumentRef.first(DocumentRefFactory.randomUuidV7()),
          template: templateRef,
        );

        when(() => remoteDocuments.get(templateRef)).thenAnswer(
          (_) => Future.error(DocumentNotFoundException(ref: templateRef)),
        );
        when(() => remoteDocuments.get(proposal.id)).thenAnswer(
          (_) => Future.error(DocumentNotFoundException(ref: templateRef)),
        );

        // When
        final ref = proposal.id;
        final proposalDocumentFuture = repository.getDocumentData(
          id: ref,
        );

        // Then
        expect(
          () async => proposalDocumentFuture,
          throwsA(isA<DocumentNotFoundException>()),
        );
      },
      onPlatform: driftOnPlatforms,
    );

    group('getDocumentData', () {
      test(
        'remote source is called only once for same proposal',
        () async {
          // Given
          final id = DocumentRefFactory.randomUuidV7();
          final version = id;

          final documentData = DocumentDataFactory.build(
            id: SignedDocumentRef(id: id, ver: version),
          );

          final ref = documentData.id;

          when(() => remoteDocuments.get(ref)).thenAnswer((_) => Future.value(documentData));

          // When
          await repository.getDocumentData(id: ref);
          await repository.getDocumentData(id: ref);

          // Then
          verify(() => remoteDocuments.get(ref)).called(1);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'latest version is called when ref is not exact ',
        () async {
          // Given
          final id = DocumentRefFactory.randomUuidV7();
          final version = id;

          final documentData = DocumentDataFactory.build(
            id: SignedDocumentRef(id: id, ver: version),
          );

          final ref = SignedDocumentRef(id: id);
          final exactRef = ref.copyWith(ver: Optional(version));

          when(() => remoteDocuments.getLatestVersion(id)).thenAnswer((_) => Future.value(version));

          when(
            () => remoteDocuments.get(exactRef),
          ).thenAnswer((_) => Future.value(documentData));

          // When
          await repository.getDocumentData(id: ref);

          // Then
          verify(() => remoteDocuments.getLatestVersion(id)).called(1);
          verify(() => remoteDocuments.get(exactRef)).called(1);
        },
        onPlatform: driftOnPlatforms,
      );
    });

    group('watchDocumentWithRef', () {
      test(
        'template reference is watched and combined correctly',
        () async {
          // Given
          final templateRef = DocumentRefFactory.signedDocumentRef();
          final template = DocumentDataFactory.build(
            type: DocumentType.proposalTemplate,
            id: templateRef,
          );
          final proposal = DocumentDataFactory.build(template: templateRef);

          when(
            () => remoteDocuments.get(template.id),
          ).thenAnswer((_) => Future.value(template));
          when(
            () => remoteDocuments.get(proposal.id),
          ).thenAnswer((_) => Future.value(proposal));

          // When
          final proposalStream = repository.watchDocumentWithRef(
            ref: proposal.id,
            refGetter: (data) => data.metadata.template!,
          );

          // Then
          expect(
            proposalStream,
            emitsInOrder([
              // db initially is empty so emits null first,
              isNull,
              // second is emitted because template initially is not there
              isNull,
              // should have all data ready.
              predicate<DocumentsDataWithRefData?>(
                (data) => data?.data.id == proposal.id && data?.refData.id == template.id,
                'data or dataRef ref do not match',
              ),
            ]),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'loads template once when two documents refers to it',
        () async {
          // Given
          final templateRef = DocumentRefFactory.signedDocumentRef();
          final template = DocumentDataFactory.build(
            type: DocumentType.proposalTemplate,
            id: templateRef,
          );
          final proposal1 = DocumentDataFactory.build(template: templateRef);
          final proposal2 = DocumentDataFactory.build(template: templateRef);

          when(
            () => remoteDocuments.get(template.id),
          ).thenAnswer((_) => Future.value(template));
          when(
            () => remoteDocuments.get(proposal1.id),
          ).thenAnswer((_) => Future.value(proposal1));
          when(
            () => remoteDocuments.get(proposal2.id),
          ).thenAnswer((_) => Future.value(proposal2));

          // When
          final proposal1Future = repository
              .watchDocumentWithRef(
                ref: proposal1.id,
                refGetter: (data) => data.metadata.template!,
              )
              .firstWhere((element) => element != null);
          final proposal2Future = repository
              .watchDocumentWithRef(
                ref: proposal2.id,
                refGetter: (data) => data.metadata.template!,
              )
              .firstWhere((element) => element != null);

          final proposals = await Future.wait([proposal1Future, proposal2Future]);

          // Then
          expect(proposals[0]!.data.id, proposal1.id);
          expect(proposals[1]!.data.id, proposal2.id);

          verify(() => remoteDocuments.get(template.id)).called(1);
        },
        onPlatform: driftOnPlatforms,
      );
    });

    group(
      'insertDocument',
      () {
        test(
          'draft document data is saved',
          () async {
            // Given
            final id = DocumentRefFactory.draftRef();
            final documentDataToSave = DocumentDataFactory.buildDraft(id: id);

            // When
            await repository.upsertLocalDraftDocument(document: documentDataToSave);

            // Then
            final savedDocumentData = await repository.getDocumentData(id: id);

            expect(savedDocumentData, equals(documentDataToSave));
          },
          onPlatform: driftOnPlatforms,
        );
      },
    );

    test(
      'updating proposal draft '
      'should emit changes',
      () async {
        // Given
        const updatedContent = DocumentDataContent({'title': 'My proposal'});

        final templateRef = DocumentRefFactory.signedDocumentRef();
        final templateData = DocumentDataFactory.build(
          id: templateRef,
          type: DocumentType.proposalTemplate,
        );

        final draftRef = DocumentRefFactory.draftRef();
        final draftData = DocumentDataFactory.buildDraft(
          id: draftRef,
          template: templateRef,
        );

        final updatedData = DocumentDataFactory.buildDraft(
          id: draftRef,
          template: templateRef,
          content: updatedContent,
        );

        // When
        await localDocuments.save(data: templateData);
        await draftsSource.save(data: draftData);

        // Then
        await repository.upsertLocalDraftDocument(document: updatedData);

        final draftStream = repository.watchDocumentWithRef(
          ref: draftRef,
          refGetter: (data) => data.metadata.template!,
        );

        // Then
        expect(
          draftStream,
          emitsInOrder([
            predicate<DocumentsDataWithRefData?>((data) {
              final isRef = data?.data.id == draftRef;
              final isContent = data?.data.content == updatedContent;
              return isRef && isContent;
            }),
          ]),
        );
      },
      onPlatform: driftOnPlatforms,
    );

    test(
      'watchProposalsDocuments returns correct model',
      () async {
        final templateRef = DocumentRefFactory.signedDocumentRef();
        final templateData = DocumentDataFactory.build(
          id: templateRef,
          type: DocumentType.proposalTemplate,
        );

        const publicDraftContent = DocumentDataContent({'title': 'My proposal'});
        final publicDraftRef = DocumentRefFactory.signedDocumentRef();
        final publicDraftData = DocumentDataFactory.build(
          id: publicDraftRef,
          template: templateRef,
          parameters: DocumentParameters({DocumentRefFactory.signedDocumentRef()}),
          content: publicDraftContent,
        );

        await localDocuments.save(data: templateData);
        await localDocuments.save(data: publicDraftData);

        final latestProposals = repository.watchAllDocuments(
          refGetter: (data) => data.metadata.template!,
        );

        expect(
          latestProposals,
          emitsInOrder([
            predicate<List<DocumentsDataWithRefData>>((dataList) {
              if (dataList.isEmpty) return false;
              final data = dataList.first;
              final isRef = data.data.id == publicDraftRef;
              final isContent = data.data.content == publicDraftContent;
              return isRef && isContent;
            }),
          ]),
        );
      },
      onPlatform: driftOnPlatforms,
    );

    test(
      'parseDocumentForImport exported with v0.0.1 signed document spec',
      () async {
        final bytes = await SignedDocumentTestData.exportedProposalV0_0_1Bytes;
        final document = await repository.parseDocumentForImport(data: bytes);

        expect(document.metadata.type, equals(DocumentType.proposalDocument));
        expect(document.metadata.template, isNotNull);
        expect(document.metadata.parameters, isNotEmpty);
      },
      onPlatform: driftOnPlatforms,
    );

    test(
      'parseDocumentForImport exported with v0.0.4 signed document spec',
      () async {
        final bytes = await SignedDocumentTestData.exportedProposalV0_0_4Bytes;
        final document = await repository.parseDocumentForImport(data: bytes);

        expect(document.metadata.type, equals(DocumentType.proposalDocument));
        expect(document.metadata.template, isNotNull);
        expect(document.metadata.parameters, isNotEmpty);
      },
      onPlatform: driftOnPlatforms,
    );
  });
}

class _MockDocumentDataRemoteSource extends Mock implements DocumentDataRemoteSource {}
