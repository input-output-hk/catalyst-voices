import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';
import 'package:collection/collection.dart';

final class DocumentDefinitionsDto {
  final Map<String, DocumentPropertySchemaDto> _definitions;

  const DocumentDefinitionsDto(this._definitions);

  factory DocumentDefinitionsDto.fromJson(Map<String, dynamic> json) {
    final map = json.map(
      (key, value) {
        return MapEntry(
          key,
          DocumentPropertySchemaDto.fromJson(value as Map<String, dynamic>),
        );
      },
    );

    return DocumentDefinitionsDto(map);
  }

  Map<String, dynamic> toJson() {
    return _definitions.map((key, value) => MapEntry(key, value.toJson()));
  }

  DocumentPropertySchemaDto? getDefinition(String? ref) {
    if (ref == null) {
      return null;
    }

    return _definitions.entries
        .firstWhereOrNull((def) => ref.contains(def.key))
        ?.value;
  }
}
