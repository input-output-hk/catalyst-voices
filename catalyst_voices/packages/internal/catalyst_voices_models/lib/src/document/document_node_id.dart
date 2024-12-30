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

  /// Returns true if this node is a child of [parent] node, false otherwise.
  bool isChildOf(DocumentNodeId parent) {
    if (parent.paths.length >= paths.length) {
      return false;
    }

    for (var i = 0; i < parent.paths.length; i++) {
      if (parent.paths[i] != paths[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  List<Object?> get props => paths;

  @override
  String toString() => paths.join('.');
}

/// The interface that every object in a document should implement,
/// helps to navigate to a certain segment/section/property of the document.
abstract interface class DocumentNode {
  /// The node of the document where an object is located.
  DocumentNodeId get nodeId;
}
