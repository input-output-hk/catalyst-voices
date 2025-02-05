import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

base class NodeId extends Equatable {
  final String value;

  const NodeId(this.value);

  /// Returns true if this node is a child of [parent] node, false otherwise.
  bool isChildOf(NodeId parent) => value.startsWith(parent.value);

  @override
  @mustCallSuper
  List<Object?> get props => [value];
}
