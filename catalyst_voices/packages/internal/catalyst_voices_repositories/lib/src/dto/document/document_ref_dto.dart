import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_ref_dto.g.dart';

@JsonSerializable()
final class DocumentRefDto {
  /// The separator used for flattened string representation.
  /// Using '|' to avoid conflicts with UUIDs which contain hyphens.
  static const _flattenSeparator = '|';

  final String id;
  final String? ver;
  @JsonKey(unknownEnumValue: DocumentRefDtoType.signed)
  final DocumentRefDtoType type;

  const DocumentRefDto({
    required this.id,
    this.ver,
    required this.type,
  });

  factory DocumentRefDto.fromFlatten(String data) {
    final parts = data.split(_flattenSeparator);
    if (parts.length != 3) {
      throw const FormatException('Flatten data does not have 3 parts');
    }

    final id = parts[0];

    // Convert empty string back to null, otherwise keep the value
    final ver = parts[1].isEmpty ? null : parts[1];

    final typeName = parts[2];
    final type = DocumentRefDtoType.values.asNameMap()[typeName];

    if (type == null) {
      throw FormatException('Unknown type part ($typeName)');
    }

    return DocumentRefDto(id: id, ver: ver, type: type);
  }

  factory DocumentRefDto.fromJson(Map<String, dynamic> json) {
    final migrated = migrateJson1(json);

    return _$DocumentRefDtoFromJson(migrated);
  }

  factory DocumentRefDto.fromModel(DocumentRef data) {
    final type = switch (data) {
      SignedDocumentRef() => DocumentRefDtoType.signed,
      DraftRef() => DocumentRefDtoType.draft,
    };

    return DocumentRefDto(
      id: data.id,
      ver: data.ver,
      type: type,
    );
  }

  String toFlatten() {
    // Convert null to empty string to ensure 3 parts exist
    final verStr = ver ?? '';
    return '$id$_flattenSeparator$verStr$_flattenSeparator${type.name}';
  }

  Map<String, dynamic> toJson() => _$DocumentRefDtoToJson(this);

  DocumentRef toModel() {
    return switch (type) {
      DocumentRefDtoType.signed => SignedDocumentRef(id: id, ver: ver),
      DocumentRefDtoType.draft => DraftRef(id: id, ver: ver),
    };
  }

  @visibleForTesting
  static Map<String, dynamic> migrateJson1(Map<String, dynamic> json) {
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

enum DocumentRefDtoType { signed, draft }
