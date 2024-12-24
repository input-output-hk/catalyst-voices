import 'package:equatable/equatable.dart';

/// The unique id of an object in a document for segments/sections/properties
/// in a format of paths from the top-level node down to the nested node.
final class DocumentNodeId extends Equatable {
  /// The top-level node in the document.
  static const DocumentNodeId root = DocumentNodeId._([]);

  /// The nested paths in a document that lead to an object.
  final List<String> paths;

  /// The default constructor for the [DocumentNodeId].
  ///
  /// From outside this file new nodes must be created by interacting
  /// with [root] node and calling either [child] or [parent] methods.
  const DocumentNodeId._(this.paths);

  /// Returns a parent node.
  ///
  /// For [root] node it returns [root] node as it doesn't have any parent.
  DocumentNodeId parent() {
    if (paths.isEmpty) {
      return this;
    }

    final newPaths = List.of(paths)..removeLast();
    return DocumentNodeId._(newPaths);
  }

  /// Returns a child node at given [path].
  ///
  /// The [path] is appended to the parent's [path].
  DocumentNodeId child(String path) {
    return DocumentNodeId._([
      ...paths,
      path,
    ]);
  }

  @override
  List<Object?> get props => paths;

  @override
  String toString() => paths.join('.');
}
