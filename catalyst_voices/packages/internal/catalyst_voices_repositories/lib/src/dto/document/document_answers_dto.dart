import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Utility structure for traversing a json map using [DocumentNodeId]'s.
final class DocumentAnswersDto {
  final Map<String, dynamic> json;

  String get schemaUrl => json[r'$schema'] as String;

  const DocumentAnswersDto.fromJson(this.json);

  factory DocumentAnswersDto.fromDocument({
    required String schemaUrl,
    required Iterable<Map<String, dynamic>> segments,
  }) {
    return DocumentAnswersDto.fromJson({
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
