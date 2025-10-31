import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.steps.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.drift.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:convert/convert.dart' show hex;
import 'package:drift/drift.dart' hide JsonKey;
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sqlite3/common.dart' as sqlite3 show jsonb;

part 'from_3_to_4.g.dart';

const _batchSize = 300;

Future<void> from3To4(Migrator m, Schema4 schema) async {
  await m.createTable(schema.documentsV2);
  await m.createTable(schema.documentsLocalMetadata);
  await m.createTable(schema.localDocumentsDrafts);

  await m.createIndex(schema.idxDocumentsV2TypeId);
  await m.createIndex(schema.idxDocumentsV2TypeIdVer);
  await m.createIndex(schema.idxDocumentsV2TypeRefId);
  await m.createIndex(schema.idxDocumentsV2TypeRefIdVer);
  await m.createIndex(schema.idxDocumentsV2RefIdVer);
  await m.createIndex(schema.idxDocumentsV2TypeCreatedAt);

  // TODO(damian-molinski): created indexes, views and queries.

  await _migrateDocs(m, schema, batchSize: _batchSize);
  await _migrateDrafts(m, schema, batchSize: _batchSize);
  await _migrateFavorites(m, schema, batchSize: _batchSize);

  // TODO(damian-molinski): uncomment when migration is done
  /*await m.drop(schema.documents);
  await m.drop(schema.drafts);
  await m.drop(schema.documentsMetadata);
  await m.drop(schema.documentsFavorites);

  await m.drop(schema.idxDocType);
  await m.drop(schema.idxUniqueVer);
  await m.drop(schema.idxDocMetadataKeyValue);
  await m.drop(schema.idxFavType);
  await m.drop(schema.idxFavUniqueId);
  await m.drop(schema.idxDraftType);*/
}

Future<void> _migrateDocs(
  Migrator m,
  Schema4 schema, {
  required int batchSize,
}) async {
  final docsCount = await schema.documents.count().getSingleOrNull().then((value) => value ?? 0);
  var docsOffset = 0;

  while (docsOffset < docsCount) {
    await m.database.batch((batch) async {
      final query = schema.documents.select()..limit(batchSize, offset: docsOffset);
      final oldDocs = await query.get();

      final rows = <RawValuesInsertable<QueryRow>>[];
      for (final oldDoc in oldDocs) {
        final rawContent = oldDoc.read<Uint8List>('content');
        final content = sqlite3.jsonb.decode(rawContent)! as Map<String, dynamic>;

        final rawMetadata = oldDoc.read<Uint8List>('metadata');
        final encodedMetadata = sqlite3.jsonb.decode(rawMetadata)! as Map<String, dynamic>;
        final metadata = DocumentDataMetadataDtoDbV3.fromJson(encodedMetadata);

        final entity = metadata.toDocEntity(content: content);

        final insertable = RawValuesInsertable<QueryRow>(entity.toColumns(true));

        rows.add(insertable);
      }

      batch.insertAll(schema.documentsV2, rows);
      docsOffset += oldDocs.length;
    });
  }

  if (kDebugMode) {
    print('Finished migrating docs[$docsOffset], totalCount[$docsCount]');
  }
}

Future<void> _migrateDrafts(
  Migrator m,
  Schema4 schema, {
  required int batchSize,
}) async {
  final localDraftsCount = await schema.drafts.count().getSingleOrNull().then(
    (value) => value ?? 0,
  );
  var localDraftsOffset = 0;

  while (localDraftsOffset < localDraftsCount) {
    await m.database.batch((batch) async {
      final query = schema.drafts.select()..limit(batchSize, offset: localDraftsOffset);
      final oldDrafts = await query.get();

      final rows = <RawValuesInsertable<QueryRow>>[];
      for (final oldDoc in oldDrafts) {
        final rawContent = oldDoc.read<Uint8List>('content');
        final content = sqlite3.jsonb.decode(rawContent)! as Map<String, dynamic>;

        final rawMetadata = oldDoc.read<Uint8List>('metadata');
        final encodedMetadata = sqlite3.jsonb.decode(rawMetadata)! as Map<String, dynamic>;
        final metadata = DocumentDataMetadataDtoDbV3.fromJson(encodedMetadata);

        final entity = metadata.toDraftEntity(content: content);

        final insertable = RawValuesInsertable<QueryRow>(entity.toColumns(true));

        rows.add(insertable);
      }

      batch.insertAll(schema.localDocumentsDrafts, rows);
      localDraftsOffset += oldDrafts.length;
    });
  }

  if (kDebugMode) {
    print('Finished migrating drafts[$localDraftsOffset], totalCount[$localDraftsCount]');
  }
}

Future<void> _migrateFavorites(
  Migrator m,
  Schema4 schema, {
  required int batchSize,
}) async {
  final favCount = await schema.documentsFavorites.count().getSingleOrNull().then(
    (value) => value ?? 0,
  );
  var favOffset = 0;

  while (favOffset < favCount) {
    await m.database.batch((batch) async {
      final query = schema.documentsFavorites.select()..limit(batchSize, offset: favOffset);
      final oldFav = await query.get();

      final rows = <RawValuesInsertable<QueryRow>>[];

      for (final oldDoc in oldFav) {
        final idHi = oldDoc.read<BigInt>('id_hi');
        final idLo = oldDoc.read<BigInt>('id_lo');
        final isFavorite = oldDoc.read<bool>('is_favorite');

        final id = UuidHiLo(high: idHi, low: idLo).uuid;

        final entity = DocumentLocalMetadataEntity(
          id: id,
          isFavorite: isFavorite,
        );

        final insertable = RawValuesInsertable<QueryRow>(entity.toColumns(true));

        rows.add(insertable);
      }

      batch.insertAll(schema.documentsLocalMetadata, rows);
      favOffset += oldFav.length;
    });
  }

  if (kDebugMode) {
    print('Finished migrating fav[$favOffset], totalCount[$favCount]');
  }
}

@JsonSerializable()
class DocumentDataMetadataDtoDbV3 {
  final String type;
  final DocumentRefDtoDbV3 selfRef;
  final DocumentRefDtoDbV3? ref;
  final SecuredDocumentRefDtoDbV3? refHash;
  final DocumentRefDtoDbV3? template;
  final DocumentRefDtoDbV3? reply;
  final String? section;
  final DocumentRefDtoDbV3? brandId;
  final DocumentRefDtoDbV3? campaignId;
  final String? electionId;
  final DocumentRefDtoDbV3? categoryId;
  final List<String>? authors;

  DocumentDataMetadataDtoDbV3({
    required this.type,
    required this.selfRef,
    this.ref,
    this.refHash,
    this.template,
    this.reply,
    this.section,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
    this.authors,
  });

  factory DocumentDataMetadataDtoDbV3.fromJson(Map<String, dynamic> json) {
    var migrated = _migrateJson1(json);
    migrated = _migrateJson2(migrated);

    return _$DocumentDataMetadataDtoDbV3FromJson(migrated);
  }

  DocumentDataMetadataDtoDbV3.fromModel(DocumentDataMetadata data)
    : this(
        type: data.type.uuid,
        selfRef: data.selfRef.toDto(),
        ref: data.ref?.toDto(),
        refHash: data.refHash?.toDto(),
        template: data.template?.toDto(),
        reply: data.reply?.toDto(),
        section: data.section,
        brandId: data.brandId?.toDto(),
        campaignId: data.campaignId?.toDto(),
        electionId: data.electionId,
        categoryId: data.categoryId?.toDto(),
        authors: data.authors?.map((e) => e.toString()).toList(),
      );

  Map<String, dynamic> toJson() => _$DocumentDataMetadataDtoDbV3ToJson(this);

  static Map<String, dynamic> _migrateJson1(Map<String, dynamic> json) {
    final modified = Map<String, dynamic>.from(json);

    if (modified.containsKey('id') && modified.containsKey('version')) {
      final id = modified.remove('id') as String;
      final version = modified.remove('version') as String;

      modified['selfRef'] = {
        'id': id,
        'version': version,
        'type': DocumentRefDtoTypeDbV3.signed.name,
      };
    }

    return modified;
  }

  static Map<String, dynamic> _migrateJson2(Map<String, dynamic> json) {
    final modified = Map<String, dynamic>.from(json);

    if (modified['brandId'] is String) {
      final id = modified.remove('brandId') as String;
      final dto = DocumentRefDtoDbV3(
        id: id,
        type: DocumentRefDtoTypeDbV3.signed,
      );
      modified['brandId'] = dto.toJson();
    }
    if (modified['campaignId'] is String) {
      final id = modified.remove('campaignId') as String;
      final dto = DocumentRefDtoDbV3(
        id: id,
        type: DocumentRefDtoTypeDbV3.signed,
      );
      modified['campaignId'] = dto.toJson();
    }

    return modified;
  }
}

@JsonSerializable()
final class DocumentRefDtoDbV3 {
  final String id;
  final String? version;
  @JsonKey(unknownEnumValue: DocumentRefDtoTypeDbV3.signed)
  final DocumentRefDtoTypeDbV3 type;

  const DocumentRefDtoDbV3({
    required this.id,
    this.version,
    required this.type,
  });

  factory DocumentRefDtoDbV3.fromJson(Map<String, dynamic> json) {
    return _$DocumentRefDtoDbV3FromJson(json);
  }

  factory DocumentRefDtoDbV3.fromModel(DocumentRef data) {
    final type = switch (data) {
      SignedDocumentRef() => DocumentRefDtoTypeDbV3.signed,
      DraftRef() => DocumentRefDtoTypeDbV3.draft,
    };

    return DocumentRefDtoDbV3(
      id: data.id,
      version: data.version,
      type: type,
    );
  }

  Map<String, dynamic> toJson() => _$DocumentRefDtoDbV3ToJson(this);
}

enum DocumentRefDtoTypeDbV3 { signed, draft }

@JsonSerializable()
final class SecuredDocumentRefDtoDbV3 {
  final DocumentRefDtoDbV3 ref;
  final String hash;

  const SecuredDocumentRefDtoDbV3({
    required this.ref,
    required this.hash,
  });

  factory SecuredDocumentRefDtoDbV3.fromJson(Map<String, dynamic> json) {
    return _$SecuredDocumentRefDtoDbV3FromJson(json);
  }

  SecuredDocumentRefDtoDbV3.fromModel(SecuredDocumentRef data)
    : this(
        ref: DocumentRefDtoDbV3.fromModel(data.ref),
        hash: hex.encode(data.hash),
      );

  Map<String, dynamic> toJson() => _$SecuredDocumentRefDtoDbV3ToJson(this);
}

extension on DocumentRef {
  DocumentRefDtoDbV3 toDto() => DocumentRefDtoDbV3.fromModel(this);
}

extension on SecuredDocumentRef {
  SecuredDocumentRefDtoDbV3 toDto() {
    return SecuredDocumentRefDtoDbV3.fromModel(this);
  }
}

extension on DocumentDataMetadataDtoDbV3 {
  DocumentEntityV2 toDocEntity({
    required Map<String, dynamic> content,
  }) {
    return DocumentEntityV2(
      id: selfRef.id,
      ver: selfRef.version!,
      type: DocumentType.fromJson(type),
      createdAt: selfRef.version!.dateTime,
      refId: ref?.id,
      refVer: ref?.version,
      replyId: reply?.id,
      replyVer: reply?.version,
      section: section,
      categoryId: categoryId?.id,
      categoryVer: categoryId?.version,
      templateId: template?.id,
      templateVer: template?.version,
      authors: authors?.join(',') ?? '',
      content: DocumentDataContent(content),
    );
  }

  LocalDocumentDraftEntity toDraftEntity({
    required Map<String, dynamic> content,
  }) {
    return LocalDocumentDraftEntity(
      id: selfRef.id,
      ver: selfRef.version!,
      type: DocumentType.fromJson(type),
      createdAt: selfRef.version!.dateTime,
      refId: ref?.id,
      refVer: ref?.version,
      replyId: reply?.id,
      replyVer: reply?.version,
      section: section,
      categoryId: categoryId?.id,
      categoryVer: categoryId?.version,
      templateId: template?.id,
      templateVer: template?.version,
      authors: authors?.join(',') ?? '',
      content: DocumentDataContent(content),
    );
  }
}
