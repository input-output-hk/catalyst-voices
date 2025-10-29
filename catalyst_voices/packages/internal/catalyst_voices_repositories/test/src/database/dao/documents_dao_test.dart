import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_dao.dart';
import 'package:catalyst_voices_repositories/src/database/database.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_plus/uuid_plus.dart';

import '../../utils/test_factories.dart';
import '../connection/test_connection.dart';
import '../drift_test_platforms.dart';

void main() {
  late DriftCatalystDatabase database;

  // ignore: unnecessary_lambdas
  setUpAll(() {
    DummyCatalystIdFactory.registerDummyKeyFactory();
  });

  setUp(() async {
    final connection = await buildTestConnection();
    database = DriftCatalystDatabase(connection);
  });

  tearDown(() async {
    await database.close();
  });

  group(DocumentsDao, () {
    group('save all', () {
      test(
        'documents can be queried back correctly',
        () async {
          // Given
          final documentsWithMetadata = _generateDocumentEntitiesWithMetadata(10);
          final expectedDocuments = documentsWithMetadata.map((e) => e.document);

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final documents = await database.documentsDao.queryAll();

          expect(documents, expectedDocuments);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'conflicting documents are ignored',
        () async {
          // Given
          final documentsWithMetadata = _generateDocumentEntitiesWithMetadata(20);
          final expectedDocuments = documentsWithMetadata.map((e) => e.document);

          // When
          final firstBatch = documentsWithMetadata.sublist(0, 10);
          final secondBatch = documentsWithMetadata.sublist(5);

          await database.documentsDao.saveAll(firstBatch);
          await database.documentsDao.saveAll(secondBatch);

          // Then
          final documents = await database.documentsDao.queryAll();

          expect(documents, expectedDocuments);
        },
        onPlatform: driftOnPlatforms,
      );
    });

    group('query', () {
      test(
        'stream emits data when new entities are saved',
        () async {
          // Given
          final documentsWithMetadata = _generateDocumentEntitiesWithMetadata(1);
          final expectedDocuments = documentsWithMetadata.map((e) => e.document).toList();

          // When
          final documentsStream = database.documentsDao.watchAll();

          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          expect(
            documentsStream,
            emitsInOrder([
              // later we inserting documents
              equals(expectedDocuments),
            ]),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns specific version matching exact ref',
        () async {
          // Given
          final documentsWithMetadata = _generateDocumentEntitiesWithMetadata(2);
          final document = documentsWithMetadata.first.document;
          final ref = SignedDocumentRef(
            id: document.metadata.id,
            version: document.metadata.version,
          );

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final entity = await database.documentsDao.query(ref: ref);

          expect(entity, isNotNull);

          final id = UuidHiLo(high: entity!.idHi, low: entity.idLo);
          final ver = UuidHiLo(high: entity.verHi, low: entity.verLo);

          expect(id.uuid, ref.id);
          expect(ver.uuid, ref.version);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns newest version when ver is not specified',
        () async {
          // Given
          final id = DocumentRefFactory.randomUuidV7();
          final firstVersionId = const Uuid().v7(
            config: V7Options(
              DateTime(2025, 2, 10).millisecondsSinceEpoch,
              null,
            ),
          );
          final secondVersionId = const Uuid().v7(
            config: V7Options(
              DateTime(2025, 2, 11).millisecondsSinceEpoch,
              null,
            ),
          );

          const secondContent = DocumentDataContent({'title': 'Dev'});
          final documentsWithMetadata = <DocumentEntityWithMetadata>[
            DocumentWithMetadataFactory.build(
              content: const DocumentDataContent({'title': 'D'}),
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: SignedDocumentRef(
                  id: id,
                  version: firstVersionId,
                ),
              ),
            ),
            DocumentWithMetadataFactory.build(
              content: secondContent,
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: SignedDocumentRef(
                  id: id,
                  version: secondVersionId,
                ),
              ),
            ),
          ];
          final document = documentsWithMetadata.first.document;
          final ref = SignedDocumentRef(id: document.metadata.id);

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final entity = await database.documentsDao.query(ref: ref);

          expect(entity, isNotNull);

          expect(entity!.metadata.id, id);
          expect(entity.metadata.version, secondVersionId);
          expect(entity.content, secondContent);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns null when id does not match any id',
        () async {
          // Given
          final documentsWithMetadata = _generateDocumentEntitiesWithMetadata(2);
          final ref = SignedDocumentRef(id: DocumentRefFactory.randomUuidV7());

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final entity = await database.documentsDao.query(ref: ref);

          expect(entity, isNull);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'all refs return as expected',
        () async {
          // Given
          final refs = List.generate(
            10,
            (_) => DocumentRefFactory.signedDocumentRef(),
          );

          final documentsWithMetadata = refs.map((ref) {
            return DocumentWithMetadataFactory.build(
              metadata: DocumentDataMetadataFactory.proposal(selfRef: ref),
            );
          });
          final typedRefs = refs.map((e) => e.toTyped(DocumentType.proposalDocument)).toList();

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final allRefs = await database.documentsDao.queryAllTypedRefs();

          expect(
            allRefs,
            allOf(hasLength(refs.length), containsAll(typedRefs)),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'Return latest unique documents',
        () async {
          final id = DocumentRefFactory.randomUuidV7();
          final version = DocumentRefFactory.randomUuidV7();
          final version2 = DocumentRefFactory.randomUuidV7();

          final document = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: SignedDocumentRef(id: id, version: version),
            ),
          );
          final document2 = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: SignedDocumentRef(id: id, version: version2),
            ),
          );
          final documentsStream = database.documentsDao.watchAll(unique: true).asBroadcastStream();

          await database.documentsDao.saveAll([document]);
          final firstEmission = await documentsStream.first;
          await database.documentsDao.saveAll([document2]);
          final secondEmission = await documentsStream.first;

          expect(firstEmission, equals([document.document]));
          expect(secondEmission, equals([document2.document]));
          expect(secondEmission.length, equals(1));
          expect(
            secondEmission.first.metadata.selfRef.version,
            equals(version2),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'Returns latest document limited by quantity if provided',
        () async {
          // Given
          final documentsWithMetadata = _generateDocumentEntitiesWithMetadata(20);

          final expectedDocuments =
              documentsWithMetadata
                  .map((e) => e.document)
                  .groupListsBy((doc) => '${doc.idHi}-${doc.idLo}')
                  .values
                  .map(
                    (versions) => versions.reduce((a, b) {
                      // Compare versions (higher version wins)
                      final compareHi = b.verHi.compareTo(a.verHi);
                      if (compareHi != 0) return compareHi > 0 ? b : a;
                      return b.verLo.compareTo(a.verLo) > 0 ? b : a;
                    }),
                  )
                  .toList()
                ..sort((a, b) {
                  // Sort by version descending
                  final compareHi = b.verHi.compareTo(a.verHi);
                  if (compareHi != 0) return compareHi;
                  return b.verLo.compareTo(a.verLo);
                });

          final limitedExpectedDocuments = expectedDocuments.take(7).toList();

          // When
          final documentsStream = database.documentsDao.watchAll(limit: 7, unique: true);

          await database.documentsDao.saveAll(documentsWithMetadata.reversed);

          // Then
          expect(
            documentsStream,
            emitsInOrder([
              equals(limitedExpectedDocuments),
            ]),
          );

          expect(
            limitedExpectedDocuments.length,
            equals(7),
            reason: 'should have 7 documents',
          );

          final uniqueIds = limitedExpectedDocuments.map((d) => '${d.idHi}-${d.idLo}').toSet();
          expect(
            uniqueIds.length,
            equals(limitedExpectedDocuments.length),
            reason: 'should have unique document IDs',
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns latest version when document has more than 1 version',
        () async {
          final id = DocumentRefFactory.randomUuidV7();
          final v1 = DocumentRefFactory.randomUuidV7();
          final v2 = DocumentRefFactory.randomUuidV7();

          final documentsWithMetadata = [v1, v2].map((version) {
            final metadata = DocumentDataMetadataFactory.proposal(
              selfRef: SignedDocumentRef(
                id: id,
                version: version,
              ),
            );
            return DocumentWithMetadataFactory.build(metadata: metadata);
          }).toList();

          // When
          final documentsStream = database.documentsDao.watchAll(limit: 7, unique: true);

          await database.documentsDao.saveAll(documentsWithMetadata);
          // Then
          expect(
            documentsStream,
            emitsInOrder([
              predicate<List<DocumentEntity>>(
                (documents) {
                  if (documents.length != 1) return false;
                  final doc = documents.first;
                  return doc.metadata.version == v2;
                },
                'should return document with version $v2',
              ),
            ]),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'emits new version of recent document',
        () async {
          // Generate base ID
          final id = DocumentRefFactory.randomUuidV7();

          // Create versions with enforced order (v2 is newer than v1)
          final v1 = DocumentRefFactory.randomUuidV7();
          final v2 = DocumentRefFactory.randomUuidV7();

          final documentsWithMetadata = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: SignedDocumentRef(
                id: id,
                version: v1,
              ),
            ),
          );

          final newVersion = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: SignedDocumentRef(
                id: id,
                version: v2,
              ),
            ),
          );

          // When
          final documentsStream = database.documentsDao
              .watchAll(limit: 7, unique: true)
              .asBroadcastStream();

          // Save first version and wait for emission
          await database.documentsDao.saveAll([documentsWithMetadata]);
          final firstEmission = await documentsStream.first;

          // Save second version and wait for emission
          await database.documentsDao.saveAll([newVersion]);
          final secondEmission = await documentsStream.first;

          // Then verify both emissions
          expect(firstEmission, equals([documentsWithMetadata.document]));
          expect(secondEmission, equals([newVersion.document]));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'emits new document when is inserted',
        () async {
          // Generate base ID
          final id1 = DocumentRefFactory.randomUuidV7();

          // Create versions with enforced order (v2 is newer than v1)
          final v1 = DocumentRefFactory.randomUuidV7();

          final id2 = DocumentRefFactory.randomUuidV7();
          final v2 = DocumentRefFactory.randomUuidV7();

          final document1 = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: SignedDocumentRef(
                id: id1,
                version: v1,
              ),
            ),
          );

          final document2 = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: SignedDocumentRef(
                id: id2,
                version: v2,
              ),
            ),
          );

          // When
          final documentsStream = database.documentsDao
              .watchAll(limit: 1, unique: true)
              .asBroadcastStream();

          await database.documentsDao.saveAll([document1]);
          final firstEmission = await documentsStream.first;

          await database.documentsDao.saveAll([document2]);
          final secondEmission = await documentsStream.first;

          // Then verify both emissions
          expect(firstEmission, equals([document1.document]));
          expect(
            secondEmission,
            equals([document2.document]),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'all documents with from same account are returned '
        'even when username changes',
        () async {
          // Given
          final originalId = DummyCatalystIdFactory.create(username: 'damian');
          final updatedId = originalId.copyWith(username: const Optional('dev'));

          final document1 = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              authors: [originalId],
            ),
          );

          final document2 = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              authors: [updatedId],
            ),
          );

          final docs = [document1, document2];
          final refs = docs.map((e) => e.document.metadata.selfRef).toList();

          // When
          await database.documentsDao.saveAll(docs);

          // Then
          final stream = database.documentsDao.watchAll(authorId: updatedId);

          expect(
            stream,
            emitsInOrder([
              allOf(
                hasLength(docs.length),
                everyElement(
                  predicate<DocumentEntity>((document) {
                    return refs.contains(document.metadata.selfRef);
                  }),
                ),
              ),
            ]),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'queryRefToDocumentData returns correct document',
        () async {
          final document1 = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(),
          );
          final document2 = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.comment(
              proposalRef: document1.document.metadata.selfRef as SignedDocumentRef,
              parameters: document1.document.metadata.parameters,
            ),
          );

          await database.documentsDao.saveAll([document1, document2]);

          final document = await database.documentsDao.queryRefToDocumentData(
            refTo: document1.document.metadata.selfRef,
            type: DocumentType.commentDocument,
          );

          expect(
            document?.metadata.selfRef,
            document2.document.metadata.selfRef,
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'watchRefToDocumentData emits correct document and updates',
        () async {
          // Given
          final baseDocument = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(),
          );

          final referencingDocument = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.comment(
              selfRef: DocumentRefFactory.signedDocumentRef(),
              proposalRef: baseDocument.document.metadata.selfRef as SignedDocumentRef,
            ),
          );

          final newerVersion = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.comment(
              selfRef: SignedDocumentRef(
                id: referencingDocument.document.metadata.id,
                version: DocumentRefFactory.randomUuidV7(),
              ),
              proposalRef: baseDocument.document.metadata.selfRef as SignedDocumentRef,
            ),
          );

          // When
          final documentsStream = database.documentsDao
              .watchRefToDocumentData(
                refTo: baseDocument.document.metadata.selfRef,
                type: DocumentType.commentDocument,
              )
              .asBroadcastStream();

          await database.documentsDao.saveAll([baseDocument, referencingDocument]);
          final firstEmission = await documentsStream.first;

          await database.documentsDao.saveAll([newerVersion]);
          final secondEmission = await documentsStream.first;

          // Then
          expect(
            firstEmission?.metadata.selfRef,
            referencingDocument.document.metadata.selfRef,
          );
          expect(
            secondEmission?.metadata.selfRef,
            newerVersion.document.metadata.selfRef,
          );
          expect(
            secondEmission?.metadata.id,
            referencingDocument.document.metadata.id,
          );
        },
        onPlatform: driftOnPlatforms,
      );
      group('wildcard support', () {
        test(
          'can query documents by matched DocumentNodeId value with wildcard',
          () async {
            final templateRef = DocumentRefFactory.randomUuidV7();

            final proposalRef1 = DocumentRefFactory.randomUuidV7();
            final proposalRef2 = DocumentRefFactory.randomUuidV7();

            const content1 = DocumentDataContent({
              'setup': {
                'title': {
                  'title': 'Milestone 2',
                },
              },
              'milestones': {
                'milestones': {
                  'milestone_list': [
                    {
                      'title': 'Milestone 1',
                      'cost': 100,
                    },
                    {
                      'title': 'Milestone 2',
                      'cost': 200,
                    },
                  ],
                },
              },
            });

            const content2 = DocumentDataContent({
              'setup': {
                'title': {
                  'title': 'Milestone 2',
                },
              },
              'milestones': {
                'milestones': {
                  'milestone_list': [
                    {
                      'title': 'Milestone 1',
                      'cost': 100,
                    },
                    {
                      'title': 'Milestone 1',
                      'outputs': 'Milestone 2',
                      'cost': 200,
                    },
                  ],
                },
              },
            });

            final ref1 = SignedDocumentRef(id: proposalRef1, version: proposalRef1);
            final ref2 = SignedDocumentRef(id: proposalRef2, version: proposalRef2);

            final doc1 = DocumentWithMetadataFactory.build(
              content: content1,
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: ref1,
                template: SignedDocumentRef(id: templateRef, version: templateRef),
              ),
            );

            final doc2 = DocumentWithMetadataFactory.build(
              content: content2,
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: ref2,
                template: SignedDocumentRef(id: templateRef, version: templateRef),
              ),
            );

            await database.documentsDao.saveAll([doc1, doc2]);

            // When: query for documents with milestone_list.*.title == 'Milestone 2'
            final results = await (database.documentsDao as DriftDocumentsDao)
                .queryDocumentsByMatchedDocumentNodeIdValue(
                  nodeId: DocumentNodeId.fromString('milestones.milestones.milestone_list.*.title'),
                  value: 'Milestone 2',
                  type: DocumentType.proposalDocument,
                  content: 'content',
                );

            // Then: only doc1 should be returned
            final refs = results.map((e) => e.metadata.selfRef).toList();
            expect(refs, contains(ref1));
            expect(refs, isNot(contains(ref2)));
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'can query documents by matched DocumentNodeId value without wildcard',
          () async {
            final templateRef = DocumentRefFactory.randomUuidV7();

            final proposalRef1 = DocumentRefFactory.randomUuidV7();

            const content1 = DocumentDataContent({
              'setup': {
                'proposer': {
                  'applicant': 'John Doe',
                },
                'title': {
                  'title': 'Milestone 2',
                },
              },
              'milestones': {
                'milestones': {
                  'milestone_list': [
                    {
                      'title': 'Milestone 1',
                      'cost': 100,
                    },
                    {
                      'title': 'Milestone 2',
                      'cost': 200,
                    },
                  ],
                },
              },
            });

            final ref1 = SignedDocumentRef(id: proposalRef1, version: proposalRef1);

            final doc1 = DocumentWithMetadataFactory.build(
              content: content1,
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: ref1,
                template: SignedDocumentRef(id: templateRef, version: templateRef),
              ),
            );

            await database.documentsDao.saveAll([doc1]);

            final results = await (database.documentsDao as DriftDocumentsDao)
                .queryDocumentsByMatchedDocumentNodeIdValue(
                  nodeId: ProposalDocument.authorNameNodeId,
                  value: 'John Doe',
                  type: DocumentType.proposalDocument,
                  content: 'content',
                );

            final refs = results.map((e) => e.metadata.selfRef).toList();
            expect(refs, contains(ref1));
          },
          onPlatform: driftOnPlatforms,
        );

        test(
          'can query documents by matched DocumentNodeId value with wildcard at the beginning',
          () async {
            final templateRef = DocumentRefFactory.randomUuidV7();

            final proposalRef1 = DocumentRefFactory.randomUuidV7();
            final proposalRef2 = DocumentRefFactory.randomUuidV7();

            const content1 = DocumentDataContent({
              'setup': {
                'title': {
                  'title': 'Milestone 2',
                  'subtitle': 'Subtitle',
                },
              },
              'milestones': {
                'milestones': {
                  'milestone_list': [
                    {
                      'title': 'Milestone 1',
                      'cost': 100,
                    },
                    {
                      'title': 'Milestone 2',
                      'cost': 200,
                    },
                  ],
                },
              },
            });

            const content2 = DocumentDataContent({
              'setup': {
                'title': {
                  'title': 'Milestone 2',
                },
              },
              'milestones': {
                'milestones': {
                  'milestone_list': [
                    {
                      'title': 'Milestone 1',
                      'cost': 100,
                    },
                    {
                      'title': 'Milestone 1',
                      'outputs': 'Milestone 2',
                      'cost': 200,
                    },
                  ],
                },
              },
            });

            final ref1 = SignedDocumentRef(id: proposalRef1, version: proposalRef1);
            final ref2 = SignedDocumentRef(id: proposalRef2, version: proposalRef2);

            final doc1 = DocumentWithMetadataFactory.build(
              content: content1,
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: ref1,
                template: SignedDocumentRef(id: templateRef, version: templateRef),
              ),
            );

            final doc2 = DocumentWithMetadataFactory.build(
              content: content2,
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: ref2,
                template: SignedDocumentRef(id: templateRef, version: templateRef),
              ),
            );

            await database.documentsDao.saveAll([doc1, doc2]);

            // When: query for documents with milestone_list.*.title == 'Milestone 2'
            final results = await (database.documentsDao as DriftDocumentsDao)
                .queryDocumentsByMatchedDocumentNodeIdValue(
                  nodeId: DocumentNodeId.fromString('*.subtitle'),
                  value: 'Subtitle',
                  type: DocumentType.proposalDocument,
                  content: 'content',
                );

            // Then: only doc1 should be returned
            final refs = results.map((e) => e.metadata.selfRef).toList();
            expect(refs, contains(ref1));
            expect(refs, isNot(contains(ref2)));
          },
          onPlatform: driftOnPlatforms,
        );
      });
    });

    group('count', () {
      test(
        'document returns expected number',
        () async {
          // Given
          final dateTime = DateTimeExt.now();

          final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
            20,
            (index) => DocumentWithMetadataFactory.build(
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: _buildRefAt(dateTime.add(Duration(seconds: index))),
              ),
            ),
          );

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final count = await database.documentsDao.countDocuments();

          expect(count, documentsWithMetadata.length);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'two versions of same document will be counted as one',
        () async {
          // Given
          final id = DocumentRefFactory.randomUuidV7();
          final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
            2,
            (index) {
              final metadata = DocumentDataMetadataFactory.proposal(
                selfRef: SignedDocumentRef(id: id, version: DocumentRefFactory.randomUuidV7()),
              );
              return DocumentWithMetadataFactory.build(metadata: metadata);
            },
          );

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final count = await database.documentsDao.countDocuments();

          expect(count, 1);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'where without ver counts all versions',
        () async {
          // Given
          final id = DocumentRefFactory.randomUuidV7();
          final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
            2,
            (index) {
              final metadata = DocumentDataMetadataFactory.proposal(
                selfRef: SignedDocumentRef(id: id, version: DocumentRefFactory.randomUuidV7()),
              );
              return DocumentWithMetadataFactory.build(metadata: metadata);
            },
          );

          final expectedCount = documentsWithMetadata.length;
          final ref = SignedDocumentRef(id: id);

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final count = await database.documentsDao.count(ref: ref);

          expect(count, expectedCount);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'where with ver counts only matching results',
        () async {
          // Given
          final id = DocumentRefFactory.randomUuidV7();
          final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
            2,
            (index) {
              final metadata = DocumentDataMetadataFactory.proposal(
                selfRef: SignedDocumentRef(id: id, version: DocumentRefFactory.randomUuidV7()),
              );
              return DocumentWithMetadataFactory.build(metadata: metadata);
            },
          );
          final version = documentsWithMetadata.first.document.metadata.version;
          final ref = SignedDocumentRef(id: id, version: version);

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final count = await database.documentsDao.count(ref: ref);

          expect(count, 1);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'where returns correct value when '
        'many different documents are found',
        () async {
          // Given
          final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
            10,
            (index) {
              final metadata = DocumentDataMetadataFactory.proposal();
              return DocumentWithMetadataFactory.build(metadata: metadata);
            },
          );
          final document = documentsWithMetadata.last.document;
          final id = document.metadata.id;
          final version = document.metadata.version;
          final ref = SignedDocumentRef(id: id, version: version);

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final count = await database.documentsDao.count(ref: ref);

          expect(count, 1);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'Counts comments for specific proposal document version',
        () async {
          final proposalId = DocumentRefFactory.randomUuidV7();
          final versionId = DocumentRefFactory.randomUuidV7();
          final proposalRef = SignedDocumentRef(
            id: proposalId,
            version: versionId,
          );
          final proposal = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: proposalRef,
            ),
          );

          await database.documentsDao.saveAll([proposal]);

          final comments = List.generate(
            10,
            (index) => DocumentWithMetadataFactory.build(
              metadata: DocumentDataMetadataFactory.comment(
                selfRef: DocumentRefFactory.signedDocumentRef(),
                proposalRef: proposalRef,
              ),
            ),
          );
          final otherComments = List.generate(
            5,
            (index) => DocumentWithMetadataFactory.build(
              metadata: DocumentDataMetadataFactory.comment(
                selfRef: DocumentRefFactory.signedDocumentRef(),
                proposalRef: DocumentRefFactory.signedDocumentRef(),
              ),
            ),
          );
          await database.documentsDao.saveAll([...comments, ...otherComments]);

          final count = await database.documentsDao.countRefDocumentByType(
            ref: proposalRef,
            type: DocumentType.commentDocument,
          );

          expect(count, equals(10));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'Count versions of specific document',
        () async {
          final proposalId = DocumentRefFactory.randomUuidV7();
          final versionId = DocumentRefFactory.randomUuidV7();
          final proposalRef = SignedDocumentRef(
            id: proposalId,
            version: versionId,
          );
          final proposal = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: proposalRef,
            ),
          );

          await database.documentsDao.saveAll([proposal]);

          final versions = List.generate(
            10,
            (index) {
              return DocumentWithMetadataFactory.build(
                metadata: DocumentDataMetadataFactory.proposal(
                  selfRef: SignedDocumentRef(
                    id: proposalId,
                    version: DocumentRefFactory.randomUuidV7(),
                  ),
                ),
              );
            },
          );

          await database.documentsDao.saveAll(versions);

          final ids = await database.documentsDao.queryVersionsOfId(
            id: proposalId,
          );

          expect(ids.length, equals(11));
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'Watches comments count',
        () async {
          final proposalId = DocumentRefFactory.randomUuidV7();
          final versionId = DocumentRefFactory.randomUuidV7();
          final proposalId2 = DocumentRefFactory.randomUuidV7();

          final proposalRef = SignedDocumentRef(
            id: proposalId,
            version: versionId,
          );
          final proposal = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: proposalRef,
            ),
          );

          final proposalRef2 = SignedDocumentRef(
            id: proposalId2,
            version: versionId,
          );

          await database.documentsDao.saveAll([proposal]);

          final comments = List.generate(2, (index) {
            return DocumentWithMetadataFactory.build(
              metadata: DocumentDataMetadataFactory.comment(
                selfRef: DocumentRefFactory.signedDocumentRef(),
                proposalRef: proposalRef,
              ),
            );
          });

          final otherComment = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.comment(
              selfRef: DocumentRefFactory.signedDocumentRef(),
              proposalRef: proposalRef2,
            ),
          );

          await database.documentsDao.saveAll([comments.first, otherComment]);

          final documentCount = database.documentsDao
              .watchCount(
                refTo: proposalRef,
                type: DocumentType.commentDocument,
              )
              .asBroadcastStream();

          final firstEmission = await documentCount.first;

          expect(firstEmission, equals(1));

          await database.documentsDao.saveAll([comments.last]);
          final secondEmission = await documentCount.first;
          expect(secondEmission, equals(2));
        },
        onPlatform: driftOnPlatforms,
      );
    });

    group('delete all', () {
      test(
        'removes all documents',
        () async {
          // Given
          final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
            5,
            (index) => DocumentWithMetadataFactory.build(),
          );

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final countBefore = await database.documentsDao.countDocuments();
          expect(countBefore, isNonZero);

          await database.documentsDao.deleteAll();

          final countAfter = await database.documentsDao.countDocuments();
          expect(countAfter, isZero);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'cascades metadata',
        () async {
          // Given
          final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
            5,
            (index) => DocumentWithMetadataFactory.build(),
          );

          // When
          await database.documentsDao.saveAll(documentsWithMetadata);

          // Then
          final before = await database.documentsDao.countDocumentsMetadata();
          expect(before, isNonZero);

          await database.documentsDao.deleteAll();

          final after = await database.documentsDao.countDocumentsMetadata();
          expect(after, isZero);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'templates used in local drafts are kept when flat is true',
        () async {
          // Given
          final template = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(),
          );

          final localDraft = DraftFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: DocumentRefFactory.draftRef(),
              template: template.document.metadata.selfRef as SignedDocumentRef,
            ),
          );

          final randomDocuments = List<DocumentEntityWithMetadata>.generate(
            10,
            (index) => DocumentWithMetadataFactory.build(),
          );

          final allDocuments = [
            template,
            ...randomDocuments,
          ];

          final allDrafts = [
            localDraft,
          ];

          // When
          await database.documentsDao.saveAll(allDocuments);
          await database.draftsDao.saveAll(allDrafts);

          // Then
          await database.documentsDao.deleteAll(keepTemplatesForLocalDrafts: true);

          final documentsCount = await database.documentsDao.count();
          final draftsCount = await database.draftsDao.count();

          expect(documentsCount, 1);
          expect(draftsCount, 1);
        },
        onPlatform: driftOnPlatforms,
      );
    });
  });
}

SignedDocumentRef _buildRefAt(DateTime dateTime) {
  final config = V7Options(dateTime.millisecondsSinceEpoch, null);
  final val = const Uuid().v7(config: config);
  return SignedDocumentRef.first(val);
}

List<DocumentEntityWithMetadata> _generateDocumentEntitiesWithMetadata(int count) {
  return List.generate(
    count,
    (index) => DocumentWithMetadataFactory.build(),
  );
}
