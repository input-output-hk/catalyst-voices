import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Utility structure for traversing a json map using [DocumentNodeId]'s.
final class DocumentDataDto {
  final Map<String, dynamic> json;

  String get schemaUrl => json[r'$schema'] as String;

  const DocumentDataDto.fromJson(this.json);

  factory DocumentDataDto.fromDocument({
    required String schemaUrl,
    required Iterable<Map<String, dynamic>> segments,
  }) {
    return DocumentDataDto.fromJson({
      r'$schema': schemaUrl,
      for (final segment in segments) ...segment,
    });
  }

  /// Retrieves the value of a property located at the specified [nodeId].
  ///
  /// This method traverses the nested structure of the [json] using
  /// the paths defined in the [nodeId]. If the specified path exists, the
  /// corresponding property value is returned. If the path is invalid or does
  /// not exist, the method returns `null`.
  Object? getProperty(DocumentNodeId nodeId) {
    Object? object = json;
    for (final path in nodeId.paths) {
      if (object is Map<String, dynamic>) {
        object = object[path];
      } else {
        // invalid path
        return null;
      }
    }

    return object;
  }
}
