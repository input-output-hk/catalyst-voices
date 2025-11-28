import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/migration/schema_versions.g.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.drift.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart' hide JsonKey;
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sqlite3/common.dart' as sqlite3 show jsonb;

part 'from_3_to_4.g.dart';

const _batchSize = 300;
final _logger = Logger('Migration[3-4]');

Future<void> from3To4(Migrator m, Schema4 schema) async {
  await m.database.transaction(() async {
    await m.createTable(schema.documentsV2);
    await m.createTable(schema.documentAuthors);
    await m.createTable(schema.documentsLocalMetadata);
    await m.createTable(schema.localDocumentsDrafts);

    await m.createIndex(schema.idxDocumentsV2TypeId);
    await m.createIndex(schema.idxDocumentsV2TypeIdVer);
    await m.createIndex(schema.idxDocumentsV2TypeRefId);
    await m.createIndex(schema.idxDocumentsV2TypeRefIdVer);
    await m.createIndex(schema.idxDocumentsV2RefIdVer);
    await m.createIndex(schema.idxDocumentsV2TypeIdCreatedAt);
    await m.createIndex(schema.idxDocumentsV2TypeCategoryId);
    await m.createIndex(schema.idxDocumentsV2TypeRefIdRefVer);
    await m.createIndex(schema.idxDocumentAuthorsComposite);
    await m.createIndex(schema.idxDocumentAuthorsIdentity);
    await m.createIndex(schema.idxDocumentAuthorsUsername);

    await _migrateDocs(m, schema, batchSize: _batchSize);
    await _migrateDrafts(m, schema, batchSize: _batchSize);
    await _migrateFavorites(m, schema, batchSize: _batchSize);

    await m.drop(schema.documents);
    await m.drop(schema.drafts);
    await m.drop(schema.documentsMetadata);
    await m.drop(schema.documentsFavorites);

    await m.drop(schema.idxDocType);
    await m.drop(schema.idxUniqueVer);
    await m.drop(schema.idxDocMetadataKeyValue);
    await m.drop(schema.idxFavType);
    await m.drop(schema.idxFavUniqueId);
    await m.drop(schema.idxDraftType);
  });
}

Future<void> _migrateDocs(
  Migrator m,
  Schema4 schema, {
  required int batchSize,
}) async {
  final docsCount = await schema.documents.count().getSingleOrNull().then((e) => e ?? 0);
  var docsOffset = 0;

  while (docsOffset < docsCount) {
    await m.database.batch((batch) async {
      final query = schema.documents.select()..limit(batchSize, offset: docsOffset);
      final oldDocs = await query.get();

      final rows = <RawValuesInsertable<QueryRow>>[];
      final authors = <RawValuesInsertable<QueryRow>>[];
      for (final oldDoc in oldDocs) {
        final rawContent = oldDoc.read<Uint8List>('content');
        final content = sqlite3.jsonb.decode(rawContent)! as Map<String, dynamic>;

        final rawMetadata = oldDoc.read<Uint8List>('metadata');
        final encodedMetadata = sqlite3.jsonb.decode(rawMetadata)! as Map<String, dynamic>;
        final metadata = DocumentDataMetadataDtoDbV3.fromJson(encodedMetadata);

        final entity = metadata.toDocEntity(content: content);

        final insertable = RawValuesInsertable<QueryRow>(entity.toColumns(true));

        rows.add(insertable);

        final authorsInjectable = metadata.toAuthorEntity().map(
          (entity) => RawValuesInsertable<QueryRow>(entity.toColumns(true)),
        );

        authors.addAll(authorsInjectable);
      }

      batch
        ..insertAll(schema.documentsV2, rows)
        ..insertAll(schema.documentAuthors, authors);

      docsOffset += oldDocs.length;
    });
  }

  _logger.info('Finished migrating docs[$docsOffset], totalCount[$docsCount]');
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
  final String contentType;
  final String type;
  final DocumentRefDtoDbV3 id;
  final DocumentRefDtoDbV3? ref;
  final DocumentRefDtoDbV3? template;
  final DocumentRefDtoDbV3? reply;
  final String? section;
  final List<String>? collaborators;
  final List<DocumentRefDtoDbV3>? parameters;
  final List<String>? authors;

  DocumentDataMetadataDtoDbV3({
    required this.contentType,
    required this.type,
    required this.id,
    this.ref,
    this.template,
    this.reply,
    this.section,
    this.collaborators,
    this.parameters,
    this.authors,
  });

  factory DocumentDataMetadataDtoDbV3.fromJson(Map<String, dynamic> json) {
    var migrated = _migrateJson1(json);
    migrated = _migrateJson2(migrated);
    migrated = _migrateJson3(migrated);
    migrated = _migrateJson4(migrated);
    migrated = _migrateJson5(migrated);

    return _$DocumentDataMetadataDtoDbV3FromJson(migrated);
  }

  DocumentDataMetadataDtoDbV3.fromModel(DocumentDataMetadata data)
    : this(
        contentType: data.contentType.value,
        type: data.type.uuid,
        id: data.id.toDto(),
        ref: data.ref?.toDto(),
        template: data.template?.toDto(),
        reply: data.reply?.toDto(),
        section: data.section,
        collaborators: data.collaborators?.map((e) => e.toString()).toList(),
        parameters: data.parameters.set.map((e) => e.toDto()).toList(),
        authors: data.authors?.map((e) => e.toString()).toList(),
      );

  Map<String, dynamic> toJson() => _$DocumentDataMetadataDtoDbV3ToJson(this);

  static Map<String, dynamic> _migrateJson1(Map<String, dynamic> json) {
    final needsMigration = json.containsKey('id') && json.containsKey('version');
    if (!needsMigration) {
      return json;
    }

    final modified = Map.of(json);

    if (needsMigration) {
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
    final needsMigration = json['brandId'] is String || json['campaignId'] is String;
    if (!needsMigration) {
      return json;
    }

    final modified = Map.of(json);

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

  static Map<String, dynamic> _migrateJson3(Map<String, dynamic> json) {
    final parametersKeys = ['brandId', 'campaignId', 'categoryId'];
    final needsMigration = parametersKeys.any(json.containsKey);
    if (!needsMigration) {
      return json;
    }

    final modified = Map.of(json);
    final parameters = <DocumentRefDto>[];

    for (final key in parametersKeys) {
      final value = modified.remove(key);
      if (value is Map<String, dynamic>) {
        parameters.add(DocumentRefDto.fromJson(value));
      }
    }

    modified['parameters'] = parameters.map((e) => e.toJson()).toList();
    return modified;
  }

  static Map<String, dynamic> _migrateJson4(Map<String, dynamic> json) {
    final needsMigration = !json.containsKey('contentType');
    if (!needsMigration) {
      return json;
    }

    final modified = Map.of(json);

    modified['contentType'] = DocumentContentType.toJson(DocumentContentType.json);

    return modified;
  }

  static Map<String, dynamic> _migrateJson5(Map<String, dynamic> json) {
    final needsMigration = json.containsKey('selfRef');
    if (!needsMigration) {
      return json;
    }

    final modified = Map.of(json);

    if (modified.containsKey('selfRef')) {
      modified['id'] = modified.remove('selfRef');
    }

    return modified;
  }
}

@JsonSerializable()
final class DocumentRefDtoDbV3 {
  final String id;
  final String? ver;
  @JsonKey(unknownEnumValue: DocumentRefDtoTypeDbV3.signed)
  final DocumentRefDtoTypeDbV3 type;

  const DocumentRefDtoDbV3({
    required this.id,
    this.ver,
    required this.type,
  });

  factory DocumentRefDtoDbV3.fromFlatten(String data) {
    final parts = data.split('-');
    if (parts.length != 3) {
      throw const FormatException('Flatten data do not have 3 parts');
    }

    final id = parts[0];
    final ver = parts[1];
    final type = DocumentRefDtoTypeDbV3.values.asNameMap()[parts[2]];

    if (type == null) {
      throw FormatException('Unknown type part (${parts[2]})');
    }

    return DocumentRefDtoDbV3(id: id, ver: ver, type: type);
  }

  factory DocumentRefDtoDbV3.fromJson(Map<String, dynamic> json) {
    final migrated = _migrateJson1(json);

    return _$DocumentRefDtoDbV3FromJson(migrated);
  }

  factory DocumentRefDtoDbV3.fromModel(DocumentRef data) {
    final type = switch (data) {
      SignedDocumentRef() => DocumentRefDtoTypeDbV3.signed,
      DraftRef() => DocumentRefDtoTypeDbV3.draft,
    };

    return DocumentRefDtoDbV3(
      id: data.id,
      ver: data.ver,
      type: type,
    );
  }

  String toFlatten() => '$id-$ver-${type.name}';

  Map<String, dynamic> toJson() => _$DocumentRefDtoDbV3ToJson(this);

  static Map<String, dynamic> _migrateJson1(Map<String, dynamic> json) {
    final needsMigration = json.containsKey('version') && !json.containsKey('ver');
    if (!needsMigration) {
      return json;
    }

    final modified = Map.of(json);

    if (modified.containsKey('version') && !modified.containsKey('ver')) {
      modified['ver'] = modified.remove('version');
    }

    return modified;
  }
}

enum DocumentRefDtoTypeDbV3 { signed, draft }

extension on DocumentRef {
  DocumentRefDtoDbV3 toDto() => DocumentRefDtoDbV3.fromModel(this);
}

extension on DocumentDataMetadataDtoDbV3 {
  List<DocumentAuthorEntity> toAuthorEntity() {
    return (authors ?? const []).map(CatalystId.parse).map((catId) {
      return DocumentAuthorEntity(
        documentId: id.id,
        documentVer: id.ver!,
        accountId: catId.toUri().toString(),
        accountSignificantId: catId.toSignificant().toUri().toString(),
        username: catId.username,
      );
    }).toList();
  }

  DocumentEntityV2 toDocEntity({
    required Map<String, dynamic> content,
  }) {
    return DocumentEntityV2(
      contentType: contentType,
      id: id.id,
      ver: id.ver!,
      type: DocumentType.fromJson(type),
      createdAt: id.ver!.dateTime,
      refId: ref?.id,
      refVer: ref?.ver,
      replyId: reply?.id,
      replyVer: reply?.ver,
      section: section,
      templateId: template?.id,
      templateVer: template?.ver,
      collaborators: collaborators?.join(',') ?? '',
      parameters: parameters?.map((e) => e.toFlatten()).join(',') ?? '',
      authors: authors?.join(',') ?? '',
      content: DocumentDataContent(content),
    );
  }

  LocalDocumentDraftEntity toDraftEntity({
    required Map<String, dynamic> content,
  }) {
    return LocalDocumentDraftEntity(
      contentType: contentType,
      id: id.id,
      ver: id.ver!,
      type: DocumentType.fromJson(type),
      createdAt: id.ver!.dateTime,
      refId: ref?.id,
      refVer: ref?.ver,
      replyId: reply?.id,
      replyVer: reply?.ver,
      section: section,
      templateId: template?.id,
      templateVer: template?.ver,
      collaborators: collaborators?.join(',') ?? '',
      parameters: parameters?.map((e) => e.toFlatten()).join(',') ?? '',
      authors: authors?.join(',') ?? '',
      content: DocumentDataContent(content),
    );
  }
}
