import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_ref_dto.g.dart';

@immutable
@JsonSerializable()
final class DocumentRefDto {
  final String id;
  final String? ver;
  @JsonKey(unknownEnumValue: DocumentRefDtoType.signed)
  final DocumentRefDtoType type;

  const DocumentRefDto({
    required this.id,
    this.ver,
    required this.type,
  });

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

  @override
  int get hashCode => Object.hash(id, ver, type);

  // not using Equatable because it's messing up JsonSerializable with props getter
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentRefDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ver == other.ver &&
          type == other.type;

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
