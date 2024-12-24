/// The unique id of an object in a document for segments/sections/elements
/// in a format of paths from the top-level node down to the nested node.
extension type const DocumentNodeId._(List<String> paths) {
  /// The top-level node in the document.
  static const DocumentNodeId root = DocumentNodeId._([]);

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
}
