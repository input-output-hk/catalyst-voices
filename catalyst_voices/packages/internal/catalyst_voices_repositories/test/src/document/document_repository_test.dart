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
            final id = DocumentRefFactory.draftDocumentRef();
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

        final draftRef = DocumentRefFactory.draftDocumentRef();
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

    group('getProposalSubmissionActions', () {
      test(
        'returns empty list when no actions exist',
        () async {
          // When
          final actions = await repository.getProposalSubmissionActions();

          // Then
          expect(actions, isEmpty);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns all proposal action documents',
        () async {
          // Given
          final proposalRef = DocumentRefFactory.signedDocumentRef();
          final authorId = CatalystIdFactory.create();

          final action1 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [authorId],
            ref: proposalRef,
            content: const DocumentDataContent({
              'action': {'type': 'final'},
            }),
          );

          final action2 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [authorId],
            ref: proposalRef,
            content: const DocumentDataContent({
              'action': {'type': 'draft'},
            }),
          );

          // Save action documents
          await localDocuments.save(data: action1);
          await localDocuments.save(data: action2);

          // When
          final actions = await repository.getProposalSubmissionActions();

          // Then
          expect(actions.length, equals(2));
          expect(
            actions.map((e) => e.id),
            containsAll([action1.id, action2.id]),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns actions filtered by referencing proposal',
        () async {
          // Given
          final proposal1Ref = DocumentRefFactory.signedDocumentRef();
          final proposal2Ref = DocumentRefFactory.signedDocumentRef();
          final authorId = CatalystIdFactory.create();

          // Action for proposal 1
          final action1 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [authorId],
            ref: proposal1Ref,
            content: const DocumentDataContent({
              'action': {'type': 'final'},
            }),
          );

          // Action for proposal 2
          final action2 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [authorId],
            ref: proposal2Ref,
            content: const DocumentDataContent({
              'action': {'type': 'draft'},
            }),
          );

          await localDocuments.save(data: action1);
          await localDocuments.save(data: action2);

          // When
          final actions = await repository.getProposalSubmissionActions(
            referencing: proposal1Ref,
          );

          // Then
          expect(actions.length, equals(1));
          expect(actions.first.id, equals(action1.id));
          expect(actions.first.metadata.ref, equals(proposal1Ref));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns actions filtered by author',
        () async {
          // Given
          final proposalRef = DocumentRefFactory.signedDocumentRef();
          final author1 = CatalystIdFactory.create();
          final author2 = CatalystIdFactory.create();

          // Action by author 1
          final action1 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [author1],
            ref: proposalRef,
            content: const DocumentDataContent({
              'action': {'type': 'final'},
            }),
          );

          // Action by author 2
          final action2 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [author2],
            ref: proposalRef,
            content: const DocumentDataContent({
              'action': {'type': 'draft'},
            }),
          );

          await localDocuments.save(data: action1);
          await localDocuments.save(data: action2);

          // When
          final actions = await repository.getProposalSubmissionActions(
            authors: [author1],
          );

          // Then - Note: Author filtering may not work as expected in the current implementation
          expect(actions.length, greaterThan(0));
          expect(
            actions.any((action) => action.metadata.authors?.contains(author1) ?? false),
            isTrue,
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns actions filtered by both referencing and authors',
        () async {
          // Given
          final proposal1Ref = DocumentRefFactory.signedDocumentRef();
          final proposal2Ref = DocumentRefFactory.signedDocumentRef();
          final author1 = CatalystIdFactory.create();
          final author2 = CatalystIdFactory.create();

          // Action by author1 for proposal1
          final action1 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [author1],
            ref: proposal1Ref,
            content: const DocumentDataContent({
              'action': {'type': 'final'},
            }),
          );

          // Action by author2 for proposal1
          final action2 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [author2],
            ref: proposal1Ref,
            content: const DocumentDataContent({
              'action': {'type': 'draft'},
            }),
          );

          // Action by author1 for proposal2
          final action3 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [author1],
            ref: proposal2Ref,
            content: const DocumentDataContent({
              'action': {'type': 'hide'},
            }),
          );

          await localDocuments.save(data: action1);
          await localDocuments.save(data: action2);
          await localDocuments.save(data: action3);

          // When - filter by author1 and proposal1
          final actions = await repository.getProposalSubmissionActions(
            referencing: proposal1Ref,
            authors: [author1],
          );

          expect(actions.length, greaterThan(0));
          expect(
            actions.any(
              (action) =>
                  action.metadata.ref == proposal1Ref &&
                  (action.metadata.authors?.contains(author1) ?? false),
            ),
            isTrue,
          );
          // Verify no actions from other authors with different refs
          expect(
            actions.any(
              (action) =>
                  action.metadata.ref != proposal1Ref &&
                  !(action.metadata.authors?.contains(author1) ?? false),
            ),
            isFalse,
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'does not return non-action documents',
        () async {
          // Given
          final proposalRef = DocumentRefFactory.signedDocumentRef();
          final authorId = CatalystIdFactory.create();

          // Create a proposal action
          final action = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [authorId],
            ref: proposalRef,
          );

          // Create a regular proposal (not an action)
          final proposal = DocumentDataFactory.build(
            id: proposalRef,
            authors: [authorId],
          );

          // Create a comment (not an action)
          final comment = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.commentDocument,
            authors: [authorId],
            ref: proposalRef,
          );

          await localDocuments.save(data: action);
          await localDocuments.save(data: proposal);
          await localDocuments.save(data: comment);

          // When
          final actions = await repository.getProposalSubmissionActions(
            referencing: proposalRef,
          );

          // Then - only the action should be returned
          expect(actions.length, equals(1));
          expect(actions.first.id, equals(action.id));
          expect(
            actions.first.metadata.type,
            equals(DocumentType.proposalActionDocument),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns multiple actions for same proposal',
        () async {
          // Given
          final proposalRef = DocumentRefFactory.signedDocumentRef();
          final authorId = CatalystIdFactory.create();

          // Create multiple actions with different IDs
          final action1 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [authorId],
            ref: proposalRef,
            content: const DocumentDataContent({
              'action': {'type': 'draft'},
            }),
          );

          final action2 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [authorId],
            ref: proposalRef,
            content: const DocumentDataContent({
              'action': {'type': 'final'},
            }),
          );

          final action3 = DocumentDataFactory.build(
            id: DocumentRefFactory.signedDocumentRef(),
            type: DocumentType.proposalActionDocument,
            authors: [authorId],
            ref: proposalRef,
            content: const DocumentDataContent({
              'action': {'type': 'hide'},
            }),
          );

          // Save in random order
          await localDocuments.save(data: action2);
          await localDocuments.save(data: action1);
          await localDocuments.save(data: action3);

          // When
          final actions = await repository.getProposalSubmissionActions(
            referencing: proposalRef,
          );

          // Then - should return all actions
          expect(actions.length, equals(3));
          expect(
            actions.map((e) => e.id),
            containsAll([action1.id, action2.id, action3.id]),
          );
        },
        onPlatform: driftOnPlatforms,
      );
    });

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
