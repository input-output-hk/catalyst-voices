import 'package:catalyst_voices_models/src/node_id.dart';

/// The unique id of an object in a document for segments/sections/properties
/// in a format of paths from the top-level node down to the nested node.
final class DocumentNodeId extends NodeId {
  /// The top-level node in the document.
  static const DocumentNodeId root = DocumentNodeId._('');

  /// The default constructor for the [DocumentNodeId].
  ///
  /// From outside this file new nodes must be created by interacting
  /// with [root] node and calling either [child] or [parent] methods.
  const DocumentNodeId._(super.value);

  /// The nested paths in a document that lead to an object.
  List<String> get paths => value.split('.');

  /// Utility constructor which ensure that value always has correct format.
  DocumentNodeId._fromPaths(List<String> paths) : this._(paths.join('.'));

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

  /// Returns a child node at given [path].
  ///
  /// The [path] is appended to the parent's [path].
  DocumentNodeId child(String path) {
    return DocumentNodeId._fromPaths([
      ...paths,
      path,
    ]);
  }

  @override
  String toString() => value;
}

/// The interface that every object in a document should implement,
/// helps to navigate to a certain segment/section/property of the document.
abstract interface class DocumentNode {
  /// The node of the document where an object is located.
  DocumentNodeId get nodeId;
}
