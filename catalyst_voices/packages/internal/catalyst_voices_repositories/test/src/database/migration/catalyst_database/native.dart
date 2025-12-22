// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/migration/from_3_to_4.dart';
import 'package:catalyst_voices_repositories/src/database/table/converter/document_converters.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../drift_test_platforms.dart';
import '../../jsonb/unsupported.dart'
    if (dart.library.io) '../../jsonb/native.dart'
    if (dart.library.js_interop) '../../jsonb/web.dart';
import 'generated/schema.dart';
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;

/* cSpell:disable */
const _testOrgCatalystIdUri =
    'id.catalyst://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=';

const _testUserCatalystIdUri =
    'id.catalyst://john@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=';

void migrationBody() {
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

    test(
      'from v3 to v4 does not corrupt data',
      () async {
        // 1. Documents are dropped
        final docs = _generateDocuments(10);
        final oldDocumentsData = docs.map((e) => e.v3()).toList();
        final expectedNewDocumentsData = List<v4.DocumentsV2Data>.empty();

        // 2. Document Favorites
        final oldDocumentsFavoritesData = docs
            .mapIndexed(
              (index, e) =>
                  _buildDocFavV3(id: e.id.id, isFavorite: index.isEven),
            )
            .toList();
        final expectedNewDocumentsFavoritesData = docs
            .mapIndexed(
              (index, e) =>
                  _buildDocFavV4(id: e.id.id, isFavorite: index.isEven),
            )
            .toList();

        // 3. Drafts
        final drafts = _generateDocuments(5, isDraft: true);
        final oldDraftsData = drafts.map((e) => e.v3Draft()).toList();
        final expectedNewDraftsData = drafts.map((e) => e.v4Draft()).toList();

        // 4. Authors
        final expectedAuthors = List<v4.DocumentAuthorsData>.empty();
        final expectedParameters = List<v4.DocumentParametersData>.empty();
        final expectedCollaborators =
            List<v4.DocumentCollaboratorsData>.empty();

        await verifier.testWithDataIntegrity(
          oldVersion: 3,
          newVersion: 4,
          createOld: v3.DatabaseAtV3.new,
          createNew: v4.DatabaseAtV4.new,
          openTestedDatabase: DriftCatalystDatabase.new,
          createItems: (batch, oldDb) {
            batch
              ..insertAll(oldDb.documents, oldDocumentsData)
              ..insertAll(
                oldDb.documentsFavorites,
                oldDocumentsFavoritesData,
              )
              ..insertAll(oldDb.drafts, oldDraftsData);
          },
          validateItems: (newDb) async {
            // 1. Documents
            final migratedDocs = await newDb.documentsV2.select().get();
            expect(
              migratedDocs,
              hasLength(expectedNewDocumentsData.length),
              reason: 'Should drop documents',
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
              migratedFavorites,
              hasLength(expectedNewDocumentsFavoritesData.length),
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
              migratedDrafts,
              hasLength(expectedNewDraftsData.length),
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
              authors,
              hasLength(expectedAuthors.length),
              reason: 'Should migrate the same number of authors',
            );
            expect(
              authors,
              orderedEquals(expectedAuthors),
              reason: 'Migrated authors should match expected format and data',
            );

            // 4. Parameters
            final parameters = await newDb.documentParameters.select().get();
            expect(
              parameters,
              hasLength(expectedParameters.length),
              reason: 'Should migrate the same number of parameters',
            );
            expect(
              parameters,
              orderedEquals(expectedParameters),
              reason:
                  'Migrated parameters should match expected format and data',
            );

            // 4. Collaborators
            final collaborators = await newDb.documentCollaborators
                .select()
                .get();
            expect(
              collaborators,
              hasLength(expectedCollaborators.length),
              reason: 'Should migrate the same number of collaborators',
            );
            expect(
              collaborators,
              orderedEquals(expectedCollaborators),
              reason:
                  'Migrated collaborators should '
                  'match expected format and data',
            );
          },
        );
      },
    );
  });
}
/* cSpell:enabled */

DocumentData _buildDoc({
  String? id,
  String? ver,
  DocumentType type = DocumentType.proposalDocument,
  Map<String, dynamic> content = const <String, dynamic>{},
  String? section,
  DocumentRef? ref,
  SignedDocumentRef? reply,
  SignedDocumentRef? template,
  List<CatalystId>? collaborators,
  List<DocumentRef>? parameters,
  List<CatalystId>? authors,
  bool isDraft = false,
}) {
  id ??= DocumentRefFactory.randomUuidV7();
  ver ??= id;

  final metadata = DocumentDataMetadata(
    type: type,
    contentType: DocumentContentType.json,
    id: DocumentRef.build(id: id, ver: ver, isDraft: isDraft),
    section: section,
    ref: ref,
    reply: reply,
    template: template,
    collaborators: collaborators,
    parameters: DocumentParameters(
      (parameters ?? []).map((e) => e.toSignedDocumentRef()).toSet(),
    ),
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
      parameters: [DocumentRefFactory.signedDocumentRef()],
      type: index.isEven
          ? DocumentType.proposalDocument
          : DocumentType.commentDocument,

      authors: [
        CatalystId.parse(_testUserCatalystIdUri),
        if (index.isEven) CatalystId.parse(_testOrgCatalystIdUri),
      ],
    );
  });
}

typedef _NewDraftData = v4.LocalDocumentsDraftsData;

typedef _OldDocumentData = v3.DocumentsData;

typedef _OldDraftData = v3.DraftsData;

extension on DocumentData {
  _OldDocumentData v3() {
    final idHiLo = UuidHiLo.from(metadata.id.id);
    final verHiLo = UuidHiLo.from(metadata.id.ver!);

    final metadataJson = DocumentDataMetadataDtoDbV3.fromModel(
      metadata,
    ).toJson();

    return _OldDocumentData(
      idHi: idHiLo.high,
      idLo: idHiLo.low,
      verHi: verHiLo.high,
      verLo: verHiLo.low,
      content: jsonb().encode(content.data),
      metadata: jsonb().encode(metadataJson),
      type: metadata.type.uuid,
      createdAt: metadata.id.ver!.tryDateTime ?? DateTime.timestamp(),
    );
  }

  _OldDraftData v3Draft() {
    final idHiLo = UuidHiLo.from(metadata.id.id);
    final verHiLo = UuidHiLo.from(metadata.id.ver!);

    final metadataJson = DocumentDataMetadataDtoDbV3.fromModel(
      metadata,
    ).toJson();

    return _OldDraftData(
      idHi: idHiLo.high,
      idLo: idHiLo.low,
      verHi: verHiLo.high,
      verLo: verHiLo.low,
      content: jsonb().encode(content.data),
      metadata: jsonb().encode(metadataJson),
      type: metadata.type.uuid,
      title: '',
    );
  }

  _NewDraftData v4Draft() {
    final idHiLo = UuidHiLo.from(metadata.id.id);
    final verHiLo = UuidHiLo.from(metadata.id.ver!);

    final metadataJson = DocumentDataMetadataDtoDbV3.fromModel(
      metadata,
    ).toJson();

    final authors = metadata.authors ?? <CatalystId>[];
    final authorsNames = authors.map((e) => e.username).toList();
    final authorsSignificant = authors.map((e) => e.toSignificant()).toList();

    return _NewDraftData(
      contentType: metadata.contentType.value,
      content: jsonb().encode(content.data),
      id: metadata.id.id,
      type: metadata.type.uuid,
      ver: metadata.id.ver!,
      authors: DocumentConverters.catId.toSql(authors),
      authorsNames: DocumentConverters.strings.toSql(authorsNames),
      authorsSignificant: DocumentConverters.catId.toSql(authorsSignificant),
      refId: metadata.ref?.id,
      refVer: metadata.ref?.ver,
      replyId: metadata.reply?.id,
      replyVer: metadata.reply?.ver,
      section: metadata.section,
      templateId: metadata.template?.id,
      templateVer: metadata.template?.ver,
      collaborators: DocumentConverters.catId.toSql(
        metadata.collaborators ?? [],
      ),
      parameters: DocumentConverters.parameters.toSql(metadata.parameters),
      createdAt: metadata.id.ver!.tryDateTime ?? DateTime.timestamp(),
    );
  }
}
