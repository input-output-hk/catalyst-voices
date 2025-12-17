import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/document/document_repository.dart';
import 'package:catalyst_voices_repositories/src/dto/document_data_with_ref_dat.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixture/signed_document/signed_document_test_data.dart';
import '../../fixture/voices_document_templates.dart';
import '../database/connection/test_connection.dart';
import '../database/drift_test_platforms.dart';
import '../utils/test_factories.dart';

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
          metadata: DocumentDataMetadataFactory.proposalTemplate(selfRef: templateRef),
          content: DocumentDataContent(templateData),
        );
        final proposal = DocumentDataFactory.build(
          metadata: DocumentDataMetadataFactory.proposal(
            selfRef: SignedDocumentRef.first(DocumentRefFactory.randomUuidV7()),
            template: templateRef,
          ),
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
          metadata: DocumentDataMetadataFactory.proposal(
            template: templateRef,
          ),
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
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: SignedDocumentRef(id: id, version: version),
            ),
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
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: SignedDocumentRef(id: id, version: version),
            ),
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
            metadata: DocumentDataMetadataFactory.proposalTemplate(selfRef: templateRef),
          );
          final proposal = DocumentDataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(template: templateRef),
          );

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
            metadata: DocumentDataMetadataFactory.proposalTemplate(
              selfRef: templateRef,
            ),
          );
          final proposal1 = DocumentDataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(template: templateRef),
          );
          final proposal2 = DocumentDataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(template: templateRef),
          );

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

    group('insertDocument', () {
      test(
        'draft document data is saved',
        () async {
          // Given
          final documentDataToSave = DocumentDataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: DocumentRefFactory.draftRef(),
            ),
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
    });

    group('getAllDocumentsRefs', () {
      test(
        'duplicated refs are filtered out',
        () async {
          // Given
          const categoryType = DocumentType.categoryParametersDocument;
          final refs = List.generate(
            10,
            (_) => DocumentRefFactory.signedDocumentRef().toTyped(DocumentType.proposalDocument),
          );
          final remoteRefs = [...refs, ...refs];
          final expectedRefs = <TypedDocumentRef>[
            ...constantDocumentRefsPerCampaign(Campaign.f14Ref).expand(
              (e) {
                return e.allTyped.where((element) => element.type != categoryType);
              },
            ),
            ...refs,
          ];

          when(
            () => remoteDocuments.index(campaign: Campaign.f14()),
          ).thenAnswer((_) => Future.value(remoteRefs));

          // When
          final allRefs = await repository.getAllDocumentsRefs(campaign: Campaign.f14());

          // Then
          expect(
            allRefs,
            allOf(hasLength(expectedRefs.length), containsAll(expectedRefs)),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'does not call get latest version when '
        'all refs are exact',
        () async {
          // Given
          final refs = List.generate(
            10,
            (_) => DocumentRefFactory.signedDocumentRef().toTyped(DocumentType.proposalDocument),
          );

          // When
          when(
            () => remoteDocuments.index(campaign: Campaign.f14()),
          ).thenAnswer((_) => Future.value(refs));

          await repository.getAllDocumentsRefs(campaign: Campaign.f14());

          // Then
          verifyNever(() => remoteDocuments.getLatestVersion(any()));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'loose refs are are specified to latest version',
        () async {
          // Given
          final exactRefs = List.generate(
            10,
            (_) => DocumentRefFactory.signedDocumentRef().toTyped(DocumentType.proposalDocument),
          );
          final looseRefs = List.generate(
            10,
            (_) => SignedDocumentRef.loose(
              id: DocumentRefFactory.randomUuidV7(),
            ).toTyped(DocumentType.proposalDocument),
          );
          final refs = [...exactRefs, ...looseRefs];

          // When
          when(
            () => remoteDocuments.index(campaign: Campaign.f14()),
          ).thenAnswer((_) => Future.value(refs));
          when(
            () => remoteDocuments.getLatestVersion(any()),
          ).thenAnswer((_) => Future(DocumentRefFactory.randomUuidV7));

          final allRefs = await repository.getAllDocumentsRefs(campaign: Campaign.f14());

          // Then
          verify(() => remoteDocuments.getLatestVersion(any())).called(looseRefs.length);

          expect(allRefs.every((element) => element.ref.isExact), isTrue);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'remote loose refs to const documents are removed',
        () async {
          // Given
          final constTemplatesRefs = constantDocumentRefsPerCampaign(Campaign.f14Ref)
              .expand(
                (element) => [
                  element.proposal?.toTyped(DocumentType.proposalTemplate),
                ],
              )
              .nonNulls
              .toList();

          final docsRefs = List.generate(
            10,
            (_) => DocumentRefFactory.signedDocumentRef().toTyped(DocumentType.proposalDocument),
          );
          final looseTemplatesRefs = constTemplatesRefs
              .map((e) => e.copyWith(ref: e.ref.toLoose()))
              .toList();
          final refs = [
            ...docsRefs,
            ...looseTemplatesRefs,
          ];

          // When
          when(
            () => remoteDocuments.index(campaign: Campaign.f14()),
          ).thenAnswer((_) => Future.value(refs));

          final allRefs = await repository.getAllDocumentsRefs(campaign: Campaign.f14());

          // Then
          if (constTemplatesRefs.isNotEmpty) {
            expect(allRefs, isNot(containsAll(looseTemplatesRefs)));
            expect(allRefs, containsAll(constTemplatesRefs));
          }

          verifyNever(() => remoteDocuments.getLatestVersion(any()));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'categories refs are filtered out',
        () async {
          // Given
          final categoriesRefs = constantDocumentRefsPerCampaign(Campaign.f14Ref)
              .expand(
                (element) => [
                  element.category.toTyped(DocumentType.categoryParametersDocument),
                ],
              )
              .toList();
          final categoriesIds = categoriesRefs.map((e) => e.ref.id).toList();

          final docsRefs = List.generate(
            10,
            (_) => DocumentRefFactory.signedDocumentRef().toTyped(DocumentType.proposalDocument),
          );
          final looseCategoriesRefs = categoriesRefs.map((e) => e.copyWith(ref: e.ref.toLoose()));
          final refs = [
            ...docsRefs,
            ...looseCategoriesRefs,
          ];

          // When
          when(
            () => remoteDocuments.index(campaign: Campaign.f14()),
          ).thenAnswer((_) => Future.value(refs));

          final allRefs = await repository.getAllDocumentsRefs(campaign: Campaign.f14());

          // Then
          expect(allRefs, isNot(containsAll(categoriesRefs)));
          expect(allRefs.none((e) => categoriesIds.contains(e.ref.id)), isTrue);

          verifyNever(() => remoteDocuments.getLatestVersion(any()));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'unknown ref types are removed if same ref found if not unknown type',
        () async {
          // Given
          const categoryType = DocumentType.categoryParametersDocument;

          final ref = DocumentRefFactory.signedDocumentRef();
          final docsRefs = <TypedDocumentRef>[
            TypedDocumentRef(ref: ref, type: DocumentType.proposalDocument),
            TypedDocumentRef(ref: ref, type: DocumentType.unknown),
          ];
          final expectedRefs = <TypedDocumentRef>[
            ...constantDocumentRefsPerCampaign(Campaign.f14Ref).expand(
              (refs) => refs.allTyped.where((e) => e.type != categoryType),
            ),
            TypedDocumentRef(ref: ref, type: DocumentType.proposalDocument),
          ];

          // When
          when(
            () => remoteDocuments.index(campaign: Campaign.f14()),
          ).thenAnswer((_) => Future.value(docsRefs));

          final allRefs = await repository.getAllDocumentsRefs(campaign: Campaign.f14());

          // Then
          expect(allRefs, containsAll(expectedRefs));

          verifyNever(() => remoteDocuments.getLatestVersion(any()));
        },
        onPlatform: driftOnPlatforms,
      );
    });

    test(
      'updating proposal draft '
      'should emit changes',
      () async {
        // Given
        const updatedContent = DocumentDataContent({'title': 'My proposal'});

        final templateRef = DocumentRefFactory.signedDocumentRef();
        final templateData = DocumentDataFactory.build(
          metadata: DocumentDataMetadataFactory.proposalTemplate(selfRef: templateRef),
        );

        final draftRef = DocumentRefFactory.draftRef();
        final draftData = DocumentDataFactory.build(
          metadata: DocumentDataMetadataFactory.proposal(
            selfRef: draftRef,
            template: templateRef,
          ),
        );

        final updatedData = DocumentDataFactory.build(
          metadata: DocumentDataMetadataFactory.proposal(
            selfRef: draftRef,
            template: templateRef,
          ),
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
      onPlatform: driftOnPlatforms,
    );

    test(
      'watchProposalsDocuments returns correct model',
      () async {
        final templateRef = DocumentRefFactory.signedDocumentRef();
        final templateData = DocumentDataFactory.build(
          metadata: DocumentDataMetadataFactory.proposalTemplate(selfRef: templateRef),
        );

        const publicDraftContent = DocumentDataContent({'title': 'My proposal'});
        final publicDraftRef = DocumentRefFactory.signedDocumentRef();
        final publicDraftData = DocumentDataFactory.build(
          metadata: DocumentDataMetadataFactory.proposal(
            selfRef: publicDraftRef,
            template: templateRef,
          ),
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
