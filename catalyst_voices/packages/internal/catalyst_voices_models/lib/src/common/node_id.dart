import 'package:catalyst_voices_models/src/common/wildcard_path_handler.dart';

base class NodeId extends WildcardPathHandler {
  const NodeId(super.value);

  NodeId child(String value) => NodeId('${this.value}.$value');

  /// Returns true if this node is a child of [parent] node, false otherwise.
  bool isChildOf(NodeId parent) => value.startsWith(parent.value);
}
