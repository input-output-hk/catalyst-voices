import 'package:catalyst_voices_models/src/common/node_id.dart';

/// The interface that every object in a document should implement,
/// helps to navigate to a certain segment/section/property of the document.
abstract interface class DocumentNode {
  /// The node of the document where an object is located.
  DocumentNodeId get nodeId;
}

/// The unique id of an object in a document for segments/sections/properties
/// in a format of paths from the top-level node down to the nested node.
final class DocumentNodeId extends NodeId {
  /// The top-level node in the document.
  static const DocumentNodeId root = DocumentNodeId._('', paths: []);

  /// The nested paths in a document that lead to an object.
  final List<String> paths;

  /// Creates a [DocumentNodeId] from a formatted string, i.e: "setup.title".
  factory DocumentNodeId.fromString(String value) {
    return DocumentNodeId._(value, paths: value.split('.'));
  }

  /// The default constructor for the [DocumentNodeId].
  ///
  /// From outside this file new nodes must be created by interacting
  /// with [root] node and calling either [child] or [parent] methods.
  const DocumentNodeId._(
    super.value, {
    required this.paths,
  });

  // TODO(damian-molinski): uncomment if we have confirmation about dots in
  // paths
  // List<String> get paths => value.isNotEmpty ? value.split('.') : const [];

  /// Utility constructor which ensure that value always has correct format.
  DocumentNodeId._fromPaths(List<String> paths)
      : this._(
          paths.join('.'),
          paths: paths,
        );

  /// The most nested path id.
  ///
  /// Effectively the string after the last dot.
  String get lastPath => paths.isNotEmpty ? paths.last : '';

  /// Returns a child node at given [path].
  ///
  /// The [path] is appended to the parent's [path].
  @override
  DocumentNodeId child(String path) {
    return DocumentNodeId._fromPaths([
      ...paths,
      path,
    ]);
  }

  /// Returns true if this node id matches the given pattern, supporting '*' as a wildcard for
  /// a single segment.
  bool matchesPattern(DocumentNodeId pattern) {
    if (pattern.paths.length != paths.length) return false;
    for (var i = 0; i < paths.length; i++) {
      if (pattern.paths[i] == '*') continue;
      if (pattern.paths[i] != paths[i]) return false;
    }
    return true;
  }

  /// Returns a parent node.
  ///
  /// For [root] node it returns [root] node as it doesn't have any parent.
  DocumentNodeId parent() {
    if (paths.isEmpty) {
      return this;
    }

    final newPaths = List.of(paths)..removeLast();
    return DocumentNodeId._fromPaths(newPaths);
  }

  @override
  String toString() => value;
}
