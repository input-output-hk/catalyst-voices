import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Utility structure for traversing a json map using [DocumentNodeId]'s.
final class DocumentPropertiesDto {
  final Map<String, dynamic> json;

  const DocumentPropertiesDto.fromJson(this.json);

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
      } else if (object is List) {
        final index = int.tryParse(path);
        if (index == null) {
          // index must be a number
          return null;
        }
        object = object[index];
      } else {
        return null;
      }
    }

    return object;
  }
}
