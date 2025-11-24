// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/migration/from_3_to_4.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/common.dart' as sqlite3 show jsonb;

import '../../drift_test_platforms.dart';
import 'generated/schema.dart';
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('database migrations', () {
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test(
            'to $toVersion',
            () async {
              final schema = await verifier.schemaAt(fromVersion);
              final db = DriftCatalystDatabase(schema.newConnection());
              await verifier.migrateAndValidate(db, toVersion);
              await db.close();
            },
            onPlatform: driftOnPlatforms,
          );
        }
      });
    }
  });

  test(
    'migration from v3 to v4 does not corrupt data',
    () async {
      // 1. Documents
      final docs = _generateDocuments(10);
      final oldDocumentsData = docs.map((e) => e.v3()).toList();
      final expectedNewDocumentsData = docs.map((e) => e.v4()).toList();

      // 2. Document Favorites
      final oldDocumentsFavoritesData = docs
          .mapIndexed(
            (index, e) => _buildDocFavV3(id: e.id, isFavorite: index.isEven),
          )
          .toList();
      final expectedNewDocumentsFavoritesData = docs
          .mapIndexed(
            (index, e) => _buildDocFavV4(id: e.id, isFavorite: index.isEven),
          )
          .toList();

      // 3. Drafts
      final drafts = _generateDocuments(5, isDraft: true);
      final oldDraftsData = drafts.map((e) => e.v3Draft()).toList();
      final expectedNewDraftsData = drafts.map((e) => e.v4Draft()).toList();

      // 4. Authors
      final expectedAuthors = docs.map((e) => e.v4Authors()).flattened.toList();

      await verifier.testWithDataIntegrity(
        oldVersion: 3,
        newVersion: 4,
        createOld: v3.DatabaseAtV3.new,
        createNew: v4.DatabaseAtV4.new,
        openTestedDatabase: DriftCatalystDatabase.new,
        createItems: (batch, oldDb) {
          batch
            ..insertAll(oldDb.documents, oldDocumentsData)
            ..insertAll(oldDb.documentsFavorites, oldDocumentsFavoritesData)
            ..insertAll(oldDb.drafts, oldDraftsData);
        },
        validateItems: (newDb) async {
          // 1. Documents
          final migratedDocs = await newDb.documentsV2.select().get();
          expect(
            migratedDocs.length,
            expectedNewDocumentsData.length,
            reason: 'Should migrate the same number of documents',
          );
          // Using a collection matcher for a more readable assertion
          expect(
            migratedDocs,
            orderedEquals(expectedNewDocumentsData),
            reason:
                'Migrated documents should match expected '
                'format and data in the correct order',
          );

          // 2. LocalMetadata (eg. fav)
          final migratedFavorites = await newDb.documentsLocalMetadata
              .select()
              .get();
          expect(
            migratedFavorites.length,
            expectedNewDocumentsFavoritesData.length,
            reason: 'Should migrate the same number of favorites',
          );
          expect(
            migratedFavorites,
            // Use unorderedEquals if the insertion order is not guaranteed
            unorderedEquals(expectedNewDocumentsFavoritesData),
            reason: 'All favorites should be migrated correctly',
          );

          // 3. Local drafts
          final migratedDrafts = await newDb.localDocumentsDrafts
              .select()
              .get();
          expect(
            migratedDrafts.length,
            expectedNewDraftsData.length,
            reason: 'Should migrate the same number of drafts',
          );
          expect(
            migratedDrafts,
            orderedEquals(expectedNewDraftsData),
            reason: 'Migrated drafts should match expected format and data',
          );

          // 4. Authors
          final authors = await newDb.documentAuthors.select().get();
          expect(
            authors.length,
            expectedAuthors.length,
            reason: 'Should migrate the same number of authors',
          );
          expect(
            authors,
            orderedEquals(expectedAuthors),
            reason: 'Migrated authors should match expected format and data',
          );
        },
      );
    },
    onPlatform: driftOnPlatforms,
  );
}

/* cSpell:disable */
const _testOrgCatalystIdUri =
    'id.catalyst://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=';

const _testUserCatalystIdUri =
    'id.catalyst://john@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=';
/* cSpell:enable */

DocumentData _buildDoc({
  String? id,
  String? ver,
  DocumentType type = DocumentType.proposalDocument,
  Map<String, dynamic> content = const <String, dynamic>{},
  String? section,
  DocumentRef? ref,
  SignedDocumentRef? reply,
  SignedDocumentRef? template,
  SignedDocumentRef? categoryId,
  List<CatalystId>? authors,
  bool isDraft = false,
}) {
  id ??= DocumentRefFactory.randomUuidV7();
  ver ??= id;

  final metadata = DocumentDataMetadata(
    type: type,
    selfRef: DocumentRef.build(id: id, ver: ver, isDraft: isDraft),
    section: section,
    ref: ref,
    reply: reply,
    template: template,
    categoryId: categoryId,
    authors: authors,
  );

  return DocumentData(
    content: DocumentDataContent(content),
    metadata: metadata,
  );
}

v3.DocumentsFavoritesData _buildDocFavV3({
  required String id,
  required bool isFavorite,
}) {
  final idHiLo = UuidHiLo.from(id);

  return v3.DocumentsFavoritesData(
    idHi: idHiLo.high,
    idLo: idHiLo.low,
    isFavorite: isFavorite,
    type: DocumentType.proposalDocument.uuid,
  );
}

v4.DocumentsLocalMetadataData _buildDocFavV4({
  required String id,
  required bool isFavorite,
}) {
  return v4.DocumentsLocalMetadataData(
    id: id,
    isFavorite: isFavorite,
  );
}

List<DocumentData> _generateDocuments(
  int count, {
  bool isDraft = false,
}) {
  return List<DocumentData>.generate(count, (index) {
    return _buildDoc(
      isDraft: isDraft,
      ref: index.isEven ? DocumentRefFactory.signedDocumentRef() : null,
      reply: index.isOdd ? DocumentRefFactory.signedDocumentRef() : null,
      template: DocumentRefFactory.signedDocumentRef(),
      categoryId: DocumentRefFactory.signedDocumentRef(),
      type: index.isEven
          ? DocumentType.proposalDocument
          : DocumentType.commentDocument,
      /* cSpell:disable */
      authors: [
        CatalystId.parse(_testUserCatalystIdUri),
        if (index.isEven) CatalystId.parse(_testOrgCatalystIdUri),
      ],
      /* cSpell:enable */
    );
  });
}

typedef _NewDocumentAuthor = v4.DocumentAuthorsData;

typedef _NewDocumentData = v4.DocumentsV2Data;

typedef _NewDraftData = v4.LocalDocumentsDraftsData;

typedef _OldDocumentData = v3.DocumentsData;

typedef _OldDraftData = v3.DraftsData;

extension on DocumentData {
  String get id => metadata.id;
}

extension on DocumentData {
  _OldDocumentData v3() {
    final idHiLo = UuidHiLo.from(metadata.id);
    final verHiLo = UuidHiLo.from(metadata.version);

    final metadataJson = DocumentDataMetadataDtoDbV3.fromModel(
      metadata,
    ).toJson();

    return _OldDocumentData(
      idHi: idHiLo.high,
      idLo: idHiLo.low,
      verHi: verHiLo.high,
      verLo: verHiLo.low,
      content: sqlite3.jsonb.encode(content.data),
      metadata: sqlite3.jsonb.encode(metadataJson),
      type: metadata.type.uuid,
      createdAt: metadata.version.tryDateTime ?? DateTime.timestamp(),
    );
  }

  _OldDraftData v3Draft() {
    final idHiLo = UuidHiLo.from(metadata.id);
    final verHiLo = UuidHiLo.from(metadata.version);

    final metadataJson = DocumentDataMetadataDtoDbV3.fromModel(
      metadata,
    ).toJson();

    return _OldDraftData(
      idHi: idHiLo.high,
      idLo: idHiLo.low,
      verHi: verHiLo.high,
      verLo: verHiLo.low,
      content: sqlite3.jsonb.encode(content.data),
      metadata: sqlite3.jsonb.encode(metadataJson),
      type: metadata.type.uuid,
      title: '',
    );
  }

  _NewDocumentData v4() {
    return _NewDocumentData(
      content: sqlite3.jsonb.encode(content.data),
      id: metadata.id,
      type: metadata.type.uuid,
      ver: metadata.version,
      authors:
          metadata.authors?.map((e) => e.toUri().toString()).join(',') ?? '',
      refId: metadata.ref?.id,
      refVer: metadata.ref?.ver,
      replyId: metadata.reply?.id,
      replyVer: metadata.reply?.ver,
      section: metadata.section,
      templateId: metadata.template?.id,
      templateVer: metadata.template?.ver,
      categoryId: metadata.categoryId?.id,
      categoryVer: metadata.categoryId?.ver,
      createdAt: metadata.version.tryDateTime ?? DateTime.timestamp(),
    );
  }

  List<_NewDocumentAuthor> v4Authors() {
    final documentId = metadata.selfRef.id;
    final documentVer = metadata.selfRef.ver!;

    return (metadata.authors ?? []).map(
      (catId) {
        return _NewDocumentAuthor(
          documentId: documentId,
          documentVer: documentVer,
          authorId: catId.toUri().toString(),
          authorIdSignificant: catId.toSignificant().toUri().toString(),
          authorUsername: catId.username,
        );
      },
    ).toList();
  }

  _NewDraftData v4Draft() {
    final idHiLo = UuidHiLo.from(metadata.id);
    final verHiLo = UuidHiLo.from(metadata.version);

    final metadataJson = DocumentDataMetadataDtoDbV3.fromModel(
      metadata,
    ).toJson();

    return _NewDraftData(
      content: sqlite3.jsonb.encode(content.data),
      id: metadata.id,
      type: metadata.type.uuid,
      ver: metadata.version,
      authors:
          metadata.authors?.map((e) => e.toUri().toString()).join(',') ?? '',
      refId: metadata.ref?.id,
      refVer: metadata.ref?.ver,
      replyId: metadata.reply?.id,
      replyVer: metadata.reply?.ver,
      section: metadata.section,
      templateId: metadata.template?.id,
      templateVer: metadata.template?.ver,
      categoryId: metadata.categoryId?.id,
      categoryVer: metadata.categoryId?.ver,
      createdAt: metadata.version.tryDateTime ?? DateTime.timestamp(),
    );
  }
}
