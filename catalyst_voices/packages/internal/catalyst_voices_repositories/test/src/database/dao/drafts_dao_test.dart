import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/drafts_dao.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_plus/uuid_plus.dart';

import '../../utils/test_factories.dart';

void main() {
  late DriftCatalystDatabase database;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    database = DriftCatalystDatabase(inMemory);
  });

  tearDown(() async {
    await database.close();
  });

  group(DriftDraftsDao, () {
    group('query', () {
      test('returns specific version matching exact ref', () async {
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
      });

      test('returns newest version when ver is not specified', () async {
        // Given
        final id = const Uuid().v7();
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
            metadata: DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              selfRef: DraftRef(id: id, version: firstVersionId),
            ),
          ),
          DraftFactory.build(
            metadata: DocumentDataMetadata(
              type: DocumentType.proposalDocument,
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
      });

      test('returns null when id does not match any id', () async {
        // Given
        final drafts = List<DocumentDraftEntity>.generate(
          2,
          (index) => DraftFactory.build(),
        );
        final ref = DraftRef(id: const Uuid().v7());

        // When
        await database.draftsDao.saveAll(drafts);

        // Then
        final entity = await database.draftsDao.query(ref: ref);

        expect(entity, isNull);
      });

      test('all refs return as expected', () async {
        // Given
        final refs = List.generate(10, (_) => DocumentRefFactory.buildDraft());
        final drafts = refs.map((ref) {
          return DraftFactory.build(
            metadata: DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              selfRef: ref,
            ),
          );
        });

        // When
        await database.draftsDao.saveAll(drafts);

        // Then
        final allRefs = await database.draftsDao.queryAllRefs();

        expect(
          allRefs,
          allOf(hasLength(refs.length), containsAll(refs)),
        );
      });

      test('stream emits data that contains correct catalystId', () async {
        final catalystId1 = CatalystId(host: 'test', role0Key: Uint8List(32));
        final catalystId2 = CatalystId(host: 'test1', role0Key: Uint8List(32));
        final catalystId3 = CatalystId(host: 'test3', role0Key: Uint8List(32));
        // Given
        final draft = DraftFactory.build(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            selfRef: DraftRef.generateFirstRef(),
            signers: [
              catalystId1.toString(),
              catalystId2.toString(),
            ],
          ),
        );

        // When
        final documentsStream =
            database.draftsDao.watchAll(catalystId: catalystId2);
        final invalidCatalystIdStream =
            database.draftsDao.watchAll(catalystId: catalystId3);

        await database.draftsDao.save(draft);

        // Then
        expect(
          documentsStream,
          emitsInOrder([
            equals([draft]),
          ]),
        );

        expect(
          invalidCatalystIdStream,
          emitsInOrder([
            equals([]),
          ]),
        );
      });
    });

    group('count', () {
      test('ref without ver includes all versions', () async {
        // Given
        final id = const Uuid().v7();
        final drafts = List<DocumentDraftEntity>.generate(
          2,
          (index) {
            return DraftFactory.build(
              metadata: DocumentDataMetadata(
                type: DocumentType.proposalDocument,
                selfRef: DocumentRefFactory.buildDraft(id: id),
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
      });

      test('ref with ver includes only that version', () async {
        // Given
        final id = const Uuid().v7();
        final version = const Uuid().v7();
        final drafts = <DocumentDraftEntity>[
          DraftFactory.build(
            metadata: DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              selfRef: DocumentRefFactory.buildDraft(id: id, version: version),
            ),
          ),
          DraftFactory.build(
            metadata: DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              selfRef: DocumentRefFactory.buildDraft(id: id),
            ),
          ),
        ];
        final ref = DraftRef(id: id, version: version);

        // When
        await database.draftsDao.saveAll(drafts);

        // Then
        final count = await database.draftsDao.count(ref: ref);

        expect(count, 1);
      });

      test('returns 0 whe no matching drafts are found', () async {
        // Given
        final drafts = <DocumentDraftEntity>[
          DraftFactory.build(),
          DraftFactory.build(),
        ];
        final ref = DraftRef(id: const Uuid().v7());

        // When
        await database.draftsDao.saveAll(drafts);

        // Then
        final count = await database.draftsDao.count(ref: ref);

        expect(count, 0);
      });
    });

    group('update', () {
      test('replaces content correctly for exact ref', () async {
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
        await database.draftsDao
            .updateContent(ref: ref, content: updatedContent);

        // Then
        final entity = await database.draftsDao.query(ref: ref);

        expect(entity, isNotNull);
        expect(entity?.content, updatedContent);
      });

      test(
          'replaces content for all matching '
          'ids when ver is not specified', () async {
        // Given
        final id = const Uuid().v7();
        final drafts = List.generate(
          5,
          (index) => DraftFactory.build(
            metadata: DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              selfRef: DocumentRefFactory.buildDraft(id: id),
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
        await database.draftsDao
            .updateContent(ref: ref, content: updatedContent);

        // Then
        final entities = await database.draftsDao.queryAll();

        expect(entities, hasLength(drafts.length));
        expect(
          entities.every((element) => element.content == updatedContent),
          isTrue,
        );
      });
    });

    group('delete', () {
      test('inserting and deleting a draft makes the table empty', () async {
        // Given
        final ref = DraftRef.generateFirstRef();

        final draft = DraftFactory.build(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            selfRef: ref,
          ),
        );

        // When
        await database.draftsDao.save(draft);
        await database.draftsDao.deleteWhere(ref: ref);

        // Then
        final entities = await database.draftsDao.queryAll();
        expect(entities, isEmpty);
      });
    });
  });
}
