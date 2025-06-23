import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

base class NodeId extends Equatable {
  final String value;

  const NodeId(this.value);

  @override
  @mustCallSuper
  List<Object?> get props => [value];

  NodeId child(String value) => NodeId('${this.value}.$value');

  /// Returns true if this node is a child of [parent] node, false otherwise.
  bool isChildOf(NodeId parent) => value.startsWith(parent.value);

  /// Returns true if this node id matches the given pattern, supporting '*' as a wildcard for
  /// a single segment.
  bool matchesPattern(NodeId pattern) {
    final handler = WildcardPathHandler.fromNodeId(pattern);
    return handler.matches(this);
  }
}
