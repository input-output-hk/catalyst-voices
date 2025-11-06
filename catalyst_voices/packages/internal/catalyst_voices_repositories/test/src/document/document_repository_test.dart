import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/document/document_repository.dart';
import 'package:catalyst_voices_repositories/src/dto/document_data_with_ref_dat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
  late DocumentFavoriteSource favoriteDocuments;

  setUp(() async {
    final connection = await buildTestConnection();
    database = DriftCatalystDatabase(connection);

    draftsSource = DatabaseDraftsDataSource(database);
    localDocuments = DatabaseDocumentsDataSource(database);
    remoteDocuments = _MockDocumentDataRemoteSource();
    favoriteDocuments = DatabaseDocumentFavoriteSource(database);

    repository = DocumentRepositoryImpl(
      database,
      draftsSource,
      localDocuments,
      remoteDocuments,
      favoriteDocuments,
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
          selfRef: templateRef,
          type: DocumentType.proposalTemplate,
          content: DocumentDataContent(templateData),
        );
        final proposal = DocumentDataFactory.build(
          selfRef: SignedDocumentRef.first(DocumentRefFactory.randomUuidV7()),
          template: templateRef,
          content: DocumentDataContent(proposalData),
        );

        when(
          () => remoteDocuments.get(ref: template.ref),
        ).thenAnswer((_) => Future.value(template));
        when(
          () => remoteDocuments.get(ref: proposal.ref),
        ).thenAnswer((_) => Future.value(proposal));

        // When
        final ref = proposal.ref;
        final proposalDocument = await repository.getDocumentData(
          ref: ref,
        );

        // Then
        expect(
          proposalDocument.metadata.selfRef,
          proposal.metadata.selfRef,
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
          selfRef: SignedDocumentRef.first(DocumentRefFactory.randomUuidV7()),
          template: templateRef,
        );

        when(() => remoteDocuments.get(ref: templateRef)).thenAnswer(
          (_) => Future.error(DocumentNotFoundException(ref: templateRef)),
        );
        when(() => remoteDocuments.get(ref: proposal.ref)).thenAnswer(
          (_) => Future.error(DocumentNotFoundException(ref: templateRef)),
        );

        // When
        final ref = proposal.ref;
        final proposalDocumentFuture = repository.getDocumentData(
          ref: ref,
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
            selfRef: SignedDocumentRef(id: id, version: version),
          );

          final ref = documentData.ref;

          when(() => remoteDocuments.get(ref: ref)).thenAnswer((_) => Future.value(documentData));

          // When
          await repository.getDocumentData(ref: ref);
          await repository.getDocumentData(ref: ref);

          // Then
          verify(() => remoteDocuments.get(ref: ref)).called(1);
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
            selfRef: SignedDocumentRef(id: id, version: version),
          );

          final ref = SignedDocumentRef(id: id);
          final exactRef = ref.copyWith(version: Optional(version));

          when(() => remoteDocuments.getLatestVersion(id)).thenAnswer((_) => Future.value(version));

          when(
            () => remoteDocuments.get(ref: exactRef),
          ).thenAnswer((_) => Future.value(documentData));

          // When
          await repository.getDocumentData(ref: ref);

          // Then
          verify(() => remoteDocuments.getLatestVersion(id)).called(1);
          verify(() => remoteDocuments.get(ref: exactRef)).called(1);
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
            selfRef: templateRef,
          );
          final proposal = DocumentDataFactory.build(template: templateRef);

          when(
            () => remoteDocuments.get(ref: template.ref),
          ).thenAnswer((_) => Future.value(template));
          when(
            () => remoteDocuments.get(ref: proposal.ref),
          ).thenAnswer((_) => Future.value(proposal));

          // When
          final proposalStream = repository.watchDocumentWithRef(
            ref: proposal.ref,
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
                (data) => data?.data.ref == proposal.ref && data?.refData.ref == template.ref,
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
            selfRef: templateRef,
          );
          final proposal1 = DocumentDataFactory.build(template: templateRef);
          final proposal2 = DocumentDataFactory.build(template: templateRef);

          when(
            () => remoteDocuments.get(ref: template.ref),
          ).thenAnswer((_) => Future.value(template));
          when(
            () => remoteDocuments.get(ref: proposal1.ref),
          ).thenAnswer((_) => Future.value(proposal1));
          when(
            () => remoteDocuments.get(ref: proposal2.ref),
          ).thenAnswer((_) => Future.value(proposal2));

          // When
          final proposal1Future = repository
              .watchDocumentWithRef(
                ref: proposal1.ref,
                refGetter: (data) => data.metadata.template!,
              )
              .firstWhere((element) => element != null);
          final proposal2Future = repository
              .watchDocumentWithRef(
                ref: proposal2.ref,
                refGetter: (data) => data.metadata.template!,
              )
              .firstWhere((element) => element != null);

          final proposals = await Future.wait([proposal1Future, proposal2Future]);

          // Then
          expect(proposals[0]!.data.ref, proposal1.ref);
          expect(proposals[1]!.data.ref, proposal2.ref);

          verify(() => remoteDocuments.get(ref: template.ref)).called(1);
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
            final documentDataToSave = DocumentDataFactory.build(
              selfRef: DocumentRefFactory.draftRef(),
            );

            // When
            await repository.upsertDocument(document: documentDataToSave);

            // Then
            final savedDocumentData = await repository.getDocumentData(
              ref: documentDataToSave.metadata.selfRef,
            );

            expect(savedDocumentData, equals(documentDataToSave));
          },
          onPlatform: driftOnPlatforms,
        );
      },
      skip: 'V2 drafts are not yet migrated',
    );

    test(
      'updating proposal draft '
      'should emit changes',
      () async {
        // Given
        const updatedContent = DocumentDataContent({'title': 'My proposal'});

        final templateRef = DocumentRefFactory.signedDocumentRef();
        final templateData = DocumentDataFactory.build(
          selfRef: templateRef,
          type: DocumentType.proposalTemplate,
        );

        final draftRef = DocumentRefFactory.draftRef();
        final draftData = DocumentDataFactory.build(
          selfRef: draftRef,
          template: templateRef,
        );

        final updatedData = DocumentDataFactory.build(
          selfRef: draftRef,
          template: templateRef,
          content: updatedContent,
        );

        // When
        await localDocuments.save(data: templateData);
        await draftsSource.save(data: draftData);

        // Then
        await repository.upsertDocument(document: updatedData);

        final draftStream = repository.watchDocumentWithRef(
          ref: draftRef,
          refGetter: (data) => data.metadata.template!,
        );

        // Then
        expect(
          draftStream,
          emitsInOrder([
            predicate<DocumentsDataWithRefData?>((data) {
              final isRef = data?.data.ref == draftRef;
              final isContent = data?.data.content == updatedContent;
              return isRef && isContent;
            }),
          ]),
        );
      },
      skip: 'V2 drafts are not yet migrated',
      onPlatform: driftOnPlatforms,
    );

    test(
      'watchProposalsDocuments returns correct model',
      () async {
        final templateRef = DocumentRefFactory.signedDocumentRef();
        final templateData = DocumentDataFactory.build(
          selfRef: templateRef,
          type: DocumentType.proposalTemplate,
        );

        const publicDraftContent = DocumentDataContent({'title': 'My proposal'});
        final publicDraftRef = DocumentRefFactory.signedDocumentRef();
        final publicDraftData = DocumentDataFactory.build(
          selfRef: publicDraftRef,
          template: templateRef,
          categoryId: DocumentRefFactory.signedDocumentRef(),
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
              final isRef = data.data.ref == publicDraftRef;
              final isContent = data.data.content == publicDraftContent;
              return isRef && isContent;
            }),
          ]),
        );
      },
      skip: 'V2 drafts are not yet migrated',
      onPlatform: driftOnPlatforms,
    );
  });
}

class _MockDocumentDataRemoteSource extends Mock implements DocumentDataRemoteSource {}
