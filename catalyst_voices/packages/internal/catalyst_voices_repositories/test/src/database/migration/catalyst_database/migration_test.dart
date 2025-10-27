// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/migration/from_3_to_4.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/common.dart' as sqlite3 show jsonb;

import 'generated/schema.dart';
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = DriftCatalystDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('migration from v3 to v4 does not corrupt data', () async {
    final oldDocumentsData = List<v3.DocumentsData>.generate(10, (
      index,
    ) {
      return _buildDocV3(
        ref: index.isEven ? DocumentRefFactory.signedDocumentRef() : null,
        reply: index.isOdd ? DocumentRefFactory.signedDocumentRef() : null,
        template: DocumentRefFactory.signedDocumentRef(),
        categoryId: DocumentRefFactory.signedDocumentRef(),
        type: index.isEven
            ? DocumentType.proposalDocument
            : DocumentType.commentDocument,
        authors: [
          'id.catalyst://john@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=',
          if (index.isEven)
            'id.catalyst://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=',
        ],
      );
    });
    final expectedNewDocumentsData = <v4.DocumentsData>[];

    final oldDocumentsMetadataData = <v3.DocumentsMetadataData>[];
    final expectedNewDocumentsMetadataData = <v4.DocumentsMetadataData>[];

    final oldDocumentsFavoritesData = List.generate(
      5,
      (index) => _buildDocFavV3(isFavorite: index.isEven),
    );
    final expectedNewDocumentsFavoritesData = <v4.DocumentsFavoritesData>[];

    final oldDraftsData = List<v3.DraftsData>.generate(10, (
      index,
    ) {
      return _buildDraftV3(
        ref: index.isEven ? DocumentRefFactory.signedDocumentRef() : null,
        reply: index.isOdd ? DocumentRefFactory.signedDocumentRef() : null,
        template: DocumentRefFactory.signedDocumentRef(),
        categoryId: DocumentRefFactory.signedDocumentRef(),
        type: index.isEven
            ? DocumentType.proposalDocument
            : DocumentType.commentDocument,
        authors: [
          'id.catalyst://john@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=',
          if (index.isEven)
            'id.catalyst://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=',
        ],
      );
    });
    final expectedNewDraftsData = <v4.DraftsData>[];

    await verifier.testWithDataIntegrity(
      oldVersion: 3,
      newVersion: 4,
      createOld: v3.DatabaseAtV3.new,
      createNew: v4.DatabaseAtV4.new,
      openTestedDatabase: DriftCatalystDatabase.new,
      createItems: (batch, oldDb) {
        batch
          ..insertAll(oldDb.documents, oldDocumentsData)
          ..insertAll(oldDb.documentsMetadata, oldDocumentsMetadataData)
          ..insertAll(oldDb.documentsFavorites, oldDocumentsFavoritesData)
          ..insertAll(oldDb.drafts, oldDraftsData);
      },
      validateItems: (newDb) async {
        expect(
          oldDocumentsData.length,
          await newDb.documentsV2.count().getSingle(),
        );
        expect(
          oldDocumentsFavoritesData.length,
          await newDb.documentsLocalMetadata.count().getSingle(),
        );
        expect(
          oldDraftsData.length,
          await newDb.localDocumentsDrafts.count().getSingle(),
        );

        // TODO(damian-molinski): remove after migration is done and old tables are dropped
        expect(
          oldDocumentsData.length,
          await newDb.documents.count().getSingle(),
        );
        expect(
          oldDocumentsMetadataData.length,
          await newDb.documentsMetadata.count().getSingle(),
        );
        expect(
          oldDocumentsFavoritesData.length,
          await newDb.documentsFavorites.count().getSingle(),
        );
        expect(
          oldDraftsData.length,
          await newDb.drafts.count().getSingle(),
        );
      },
    );
  });
}

v3.DocumentsFavoritesData _buildDocFavV3({
  String? id,
  String? ver,
  bool? isFavorite,
  DocumentType? type,
}) {
  id ??= DocumentRefFactory.randomUuidV7();
  ver ??= id;
  isFavorite ??= false;
  type ??= DocumentType.proposalDocument;

  final idHiLo = UuidHiLo.from(id);

  return v3.DocumentsFavoritesData(
    idHi: idHiLo.high,
    idLo: idHiLo.low,
    isFavorite: isFavorite,
    type: type.uuid,
  );
}

v3.DocumentsData _buildDocV3({
  String? id,
  String? ver,
  DocumentType? type,
  Map<String, dynamic>? content,
  String? section,
  DocumentRef? ref,
  DocumentRef? reply,
  DocumentRef? template,
  DocumentRef? categoryId,
  List<String>? authors,
}) {
  id ??= DocumentRefFactory.randomUuidV7();
  ver ??= id;
  type ??= DocumentType.proposalDocument;
  content ??= <String, dynamic>{};

  final idHiLo = UuidHiLo.from(id);
  final verHiLo = UuidHiLo.from(ver);

  final metadata = DocumentDataMetadataDtoDbV3(
    type: type.uuid,
    selfRef: DocumentRefDtoDbV3(
      id: id,
      version: ver,
      type: DocumentRefDtoTypeDbV3.signed,
    ),
    section: section,
    ref: ref != null ? DocumentRefDtoDbV3.fromModel(ref) : null,
    reply: reply != null ? DocumentRefDtoDbV3.fromModel(reply) : null,
    template: template != null ? DocumentRefDtoDbV3.fromModel(template) : null,
    categoryId: categoryId != null
        ? DocumentRefDtoDbV3.fromModel(categoryId)
        : null,
    authors: authors,
  );

  return v3.DocumentsData(
    idHi: idHiLo.high,
    idLo: idHiLo.low,
    verHi: verHiLo.high,
    verLo: verHiLo.low,
    content: sqlite3.jsonb.encode(content),
    metadata: sqlite3.jsonb.encode(metadata.toJson()),
    type: type.uuid,
    createdAt: DateTime.now(),
  );
}

v3.DraftsData _buildDraftV3({
  String? id,
  String? ver,
  DocumentType? type,
  Map<String, dynamic>? content,
  String? section,
  DocumentRef? ref,
  DocumentRef? reply,
  DocumentRef? template,
  DocumentRef? categoryId,
  List<String>? authors,
}) {
  id ??= DocumentRefFactory.randomUuidV7();
  ver ??= id;
  type ??= DocumentType.proposalDocument;
  content ??= <String, dynamic>{};

  final idHiLo = UuidHiLo.from(id);
  final verHiLo = UuidHiLo.from(ver);

  final metadata = DocumentDataMetadataDtoDbV3(
    type: type.uuid,
    selfRef: DocumentRefDtoDbV3(
      id: id,
      version: ver,
      type: DocumentRefDtoTypeDbV3.signed,
    ),
    section: section,
    ref: ref != null ? DocumentRefDtoDbV3.fromModel(ref) : null,
    reply: reply != null ? DocumentRefDtoDbV3.fromModel(reply) : null,
    template: template != null ? DocumentRefDtoDbV3.fromModel(template) : null,
    categoryId: categoryId != null
        ? DocumentRefDtoDbV3.fromModel(categoryId)
        : null,
    authors: authors,
  );

  return v3.DraftsData(
    idHi: idHiLo.high,
    idLo: idHiLo.low,
    verHi: verHiLo.high,
    verLo: verHiLo.low,
    content: sqlite3.jsonb.encode(content),
    metadata: sqlite3.jsonb.encode(metadata.toJson()),
    type: type.uuid,
    title: '',
  );
}
