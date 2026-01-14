import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/migration/schema_versions.g.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.drift.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart' hide JsonKey;
import 'package:json_annotation/json_annotation.dart';
import 'package:sqlite3/common.dart' as sqlite3 show jsonb;

part 'from_3_to_4.g.dart';

const _batchSize = 300;
final _logger = Logger('Migration[3-4]');

Future<void> from3To4(Migrator m, Schema4 schema) async {
  await m.database.transaction(() async {
    await m.createAll();

    // Signed documents are dropped in this migration as they require binary representation
    // which is not present.
    await _migrateDrafts(m, schema, batchSize: _batchSize);
    await _migrateFavorites(m, schema, batchSize: _batchSize);

    // Tables are no longer in schema to have to delete them "manually". Indexes are dropped
    // automatically.
    await m.deleteTable('documents');
    await m.deleteTable('documents_metadata');
    await m.deleteTable('documents_favorites');
    await m.deleteTable('drafts');
  });
}

Future<void> _migrateDrafts(
  Migrator m,
  Schema4 schema, {
  required int batchSize,
}) async {
  final localDraftsCount = await _queryCount('drafts', db: m.database);
  var localDraftsOffset = 0;

  while (localDraftsOffset < localDraftsCount) {
    await m.database.batch((batch) async {
      final oldDrafts = await _queryRows('drafts', batchSize, localDraftsOffset, db: m.database);
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

  _logger.info('Finished migrating drafts[$localDraftsOffset], totalCount[$localDraftsCount]');
}

Future<void> _migrateFavorites(
  Migrator m,
  Schema4 schema, {
  required int batchSize,
}) async {
  final favCount = await _queryCount('documents_favorites', db: m.database);
  var favOffset = 0;

  while (favOffset < favCount) {
    await m.database.batch((batch) async {
      final oldFav = await _queryRows('documents_favorites', batchSize, favOffset, db: m.database);
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

  _logger.info('Finished migrating fav[$favOffset], totalCount[$favCount]');
}

Future<int> _queryCount(String tableName, {required GeneratedDatabase db}) {
  return db
      .customSelect('SELECT COUNT(*) FROM $tableName')
      .map((row) => row.read<int>('COUNT(*)'))
      .getSingleOrNull()
      .then((value) => value ?? 0);
}

Future<List<QueryRow>> _queryRows(
  String tableName,
  int limit,
  int offset, {
  required GeneratedDatabase db,
}) {
  return db.customSelect('SELECT * FROM $tableName LIMIT $limit OFFSET $offset').get();
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
    final type = _tryParseDocumentType(json['type']);
    final contentType = type?.contentType ?? DocumentContentType.json;
    modified['contentType'] = DocumentContentType.toJson(contentType);
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

  static DocumentType? _tryParseDocumentType(Object? object) {
    if (object is String) {
      return DocumentType.fromJson(object);
    }

    return null;
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

  Map<String, dynamic> toJson() => _$DocumentRefDtoDbV3ToJson(this);

  DocumentRef toModel() {
    return switch (type) {
      DocumentRefDtoTypeDbV3.signed => SignedDocumentRef(id: id, ver: ver),
      DocumentRefDtoTypeDbV3.draft => DraftRef(id: id, ver: ver),
    };
  }

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
  LocalDocumentDraftEntity toDraftEntity({
    required Map<String, dynamic> content,
  }) {
    final authors = this.authors?.map(CatalystId.tryParse).nonNulls.toList() ?? [];
    final authorsNames = authors.map((e) => e.username).toList();
    final authorsSignificant = authors.map((e) => e.toSignificant()).toList();

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
      collaborators: collaborators?.map(CatalystId.tryParse).nonNulls.toList() ?? [],
      parameters: parameters?.toParameters() ?? const DocumentParameters(),
      authors: authors,
      authorsNames: authorsNames,
      authorsSignificant: authorsSignificant,
      content: DocumentDataContent(content),
    );
  }
}

extension on List<DocumentRefDtoDbV3> {
  DocumentParameters toParameters() {
    final refs = map((e) => e.toModel().toSignedDocumentRef()).toSet();
    return DocumentParameters(refs);
  }
}
