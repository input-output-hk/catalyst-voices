import 'package:catalyst_voices_models/src/document_builder/document_node_id.dart';
import 'package:equatable/equatable.dart';

final class Document extends Equatable {
  final Map<String, dynamic> properties;

  const Document({required this.properties});

  /// Retrieves the value of a property located at the specified [nodeId].
  ///
  /// This method traverses the nested structure of the [properties] map using
  /// the paths defined in the [nodeId]. If the specified path exists, the
  /// corresponding property value is returned. If the path is invalid or does
  /// not exist, the method returns `null`.
  Object? getProperty(DocumentNodeId nodeId) {
    Object? object = properties;
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

  @override
  List<Object?> get props => [properties];
}
