import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/drafts_dao.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart' show Uint8List;
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_plus/uuid_plus.dart';

import '../../utils/test_factories.dart';
import '../connection/test_connection.dart';
import '../drift_test_platforms.dart';

void main() {
  late DriftCatalystDatabase database;

  setUp(() async {
    final connection = await buildTestConnection();
    database = DriftCatalystDatabase(connection);
  });

  tearDown(() async {
    await database.close();
  });

  group(DriftDraftsDao, () {
    group('query', () {
      test(
        'returns specific version matching exact ref',
        () async {
          // Given
          final drafts = List<DocumentDraftEntity>.generate(
            2,
            (index) => DraftFactory.build(),
          );
          final ref = DraftRef(
            id: drafts.first.metadata.id,
            version: drafts.first.metadata.version,
          );

          // When
          await database.draftsDao.saveAll(drafts);

          // Then
          final entity = await database.draftsDao.query(ref: ref);

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

          final drafts = <DocumentDraftEntity>[
            DraftFactory.build(
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: DraftRef(id: id, version: firstVersionId),
              ),
            ),
            DraftFactory.build(
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: DraftRef(id: id, version: secondVersionId),
              ),
            ),
          ];
          final ref = DraftRef(id: drafts.first.metadata.id);

          // When
          await database.draftsDao.saveAll(drafts);

          // Then
          final entity = await database.draftsDao.query(ref: ref);

          expect(entity, isNotNull);

          expect(entity!.metadata.id, id);
          expect(entity.metadata.version, secondVersionId);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns null when id does not match any id',
        () async {
          // Given
          final drafts = List<DocumentDraftEntity>.generate(
            2,
            (index) => DraftFactory.build(),
          );
          final ref = DraftRef(id: DocumentRefFactory.randomUuidV7());

          // When
          await database.draftsDao.saveAll(drafts);

          // Then
          final entity = await database.draftsDao.query(ref: ref);

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
            (_) => DocumentRefFactory.draftRef(),
          );
          final drafts = refs.map((ref) {
            return DraftFactory.build(
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: ref,
              ),
            );
          });
          final typedRefs = refs.map((e) => e.toTyped(DocumentType.proposalDocument)).toList();

          // When
          await database.draftsDao.saveAll(drafts);

          // Then
          final allRefs = await database.draftsDao.queryAllTypedRefs();

          expect(
            allRefs,
            allOf(hasLength(refs.length), containsAll(typedRefs)),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'authors are correctly extracted',
        () async {
          final authorId1 = CatalystId(host: 'test', role0Key: Uint8List(32));
          final authorId2 = CatalystId(host: 'test1', role0Key: Uint8List(32));

          final ref = DocumentRefFactory.draftRef();
          // Given
          final draft = DraftFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: ref,
              authors: [
                authorId1,
                authorId2,
              ],
            ),
          );

          await database.draftsDao.save(draft);
          final doc = await database.draftsDao.query(ref: ref);
          expect(
            doc?.metadata.authors,
            [
              authorId1,
              authorId2,
            ],
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'when updating proposal author list is not deleted',
        () async {
          final authorId1 = CatalystId(host: 'test', role0Key: Uint8List(32));
          final authorId2 = CatalystId(host: 'test1', role0Key: Uint8List(32));

          final ref = DocumentRefFactory.draftRef();
          // Given
          final draft = DraftFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: ref,
              authors: [
                authorId1,
                authorId2,
              ],
            ),
            content: const DocumentDataContent({
              'title': 'Dev',
            }),
          );

          final updateDraft = draft.copyWith(
            metadata: draft.metadata.copyWith(),
            content: const DocumentDataContent({
              'title': 'Update',
            }),
          );

          await database.draftsDao.save(draft);
          await database.draftsDao.save(updateDraft);

          final updated = await database.draftsDao.query(ref: ref);

          expect(
            updated?.metadata.authors?.length,
            equals(2),
          );
          expect(
            updated?.metadata.authors,
            equals([
              authorId1,
              authorId2,
            ]),
          );
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'all drafts with from same account are returned '
        'even when username changes',
        () async {
          // Given
          final originalId = DummyCatalystIdFactory.create(username: 'damian');
          final updatedId = originalId.copyWith(username: const Optional('dev'));

          final draft1 = DraftFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: DocumentRefFactory.signedDocumentRef(),
              authors: [originalId],
            ),
          );
          final draft2 = DraftFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: DocumentRefFactory.signedDocumentRef(),
              authors: [updatedId],
            ),
          );

          final drafts = [draft1, draft2];
          final refs = drafts.map((e) => e.metadata.selfRef).toList();

          // When
          await database.draftsDao.saveAll(drafts);

          // Then
          final stream = database.draftsDao.watchAll(authorId: updatedId);

          expect(
            stream,
            emitsInOrder([
              allOf(
                hasLength(drafts.length),
                everyElement(
                  predicate<DocumentDraftEntity>((document) {
                    return refs.contains(document.metadata.selfRef);
                  }),
                ),
              ),
            ]),
          );
        },
        onPlatform: driftOnPlatforms,
      );
    });

    group('count', () {
      test(
        'ref without ver includes all versions',
        () async {
          // Given
          final id = DocumentRefFactory.randomUuidV7();
          final drafts = List<DocumentDraftEntity>.generate(
            2,
            (index) {
              return DraftFactory.build(
                metadata: DocumentDataMetadataFactory.proposal(
                  selfRef: DraftRef(
                    id: id,
                    version: DocumentRefFactory.randomUuidV7(),
                  ),
                ),
              );
            },
          );
          final ref = DraftRef(id: id);

          // When
          await database.draftsDao.saveAll(drafts);

          // Then
          final count = await database.draftsDao.count(ref: ref);

          expect(count, drafts.length);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'ref with ver includes only that version',
        () async {
          // Given
          final id = DocumentRefFactory.randomUuidV7();
          final version = DocumentRefFactory.randomUuidV7();
          final drafts = <DocumentDraftEntity>[
            DraftFactory.build(
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: DraftRef(id: id, version: version),
              ),
            ),
            DraftFactory.build(
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: DraftRef.first(id),
              ),
            ),
          ];
          final ref = DraftRef(id: id, version: version);

          // When
          await database.draftsDao.saveAll(drafts);

          // Then
          final count = await database.draftsDao.count(ref: ref);

          expect(count, 1);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'returns 0 whe no matching drafts are found',
        () async {
          // Given
          final drafts = <DocumentDraftEntity>[
            DraftFactory.build(),
            DraftFactory.build(),
          ];

          final ref = DraftRef(id: DocumentRefFactory.randomUuidV7());

          // When
          await database.draftsDao.saveAll(drafts);

          // Then
          final count = await database.draftsDao.count(ref: ref);

          expect(count, 0);
        },
        onPlatform: driftOnPlatforms,
      );
    });

    group('update', () {
      test(
        'replaces content correctly for exact ref',
        () async {
          // Given
          final draft = DraftFactory.build();
          const updatedContent = DocumentDataContent({
            'title': 'Dev final 2',
            'author': 'dev',
          });
          final ref = DraftRef(
            id: draft.metadata.id,
            version: draft.metadata.version,
          );

          // When
          await database.draftsDao.save(draft);
          await database.draftsDao.updateContent(ref: ref, content: updatedContent);

          // Then
          final entity = await database.draftsDao.query(ref: ref);

          expect(entity, isNotNull);
          expect(entity?.content, updatedContent);
        },
        onPlatform: driftOnPlatforms,
      );

      test(
        'replaces content for all matching '
        'ids when ver is not specified',
        () async {
          // Given
          final id = const Uuid().v7();
          final drafts = List.generate(
            5,
            (index) => DraftFactory.build(
              metadata: DocumentDataMetadataFactory.proposal(
                selfRef: DraftRef(id: id, version: const Uuid().v7()),
              ),
            ),
          );
          const updatedContent = DocumentDataContent({
            'title': 'Dev final 2',
            'author': 'dev',
          });
          final ref = DraftRef(id: id);

          // When
          await database.draftsDao.saveAll(drafts);
          await database.draftsDao.updateContent(ref: ref, content: updatedContent);

          // Then
          final entities = await database.draftsDao.queryAll();

          expect(entities, hasLength(drafts.length));
          expect(
            entities.every((element) => element.content == updatedContent),
            isTrue,
          );
        },
        onPlatform: driftOnPlatforms,
      );
    });

    group('delete', () {
      test(
        'inserting and deleting a draft makes the table empty',
        () async {
          // Given
          final ref = DocumentRefFactory.draftRef();

          final draft = DraftFactory.build(
            metadata: DocumentDataMetadataFactory.proposal(
              selfRef: ref,
            ),
          );

          // When
          await database.draftsDao.save(draft);
          await database.draftsDao.deleteWhere(ref: ref);

          // Then
          final entities = await database.draftsDao.queryAll();
          expect(entities, isEmpty);
        },
        onPlatform: driftOnPlatforms,
      );
    });
  });
}
