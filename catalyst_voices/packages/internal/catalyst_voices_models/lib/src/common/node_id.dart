import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Node is abstract term which can be used for common UI patterns such as navigation
/// in tree view or documents content value.
///
/// Nested [value]'s have to separated by dots.
///
/// See:
/// - [DocumentNodeId]
base class NodeId extends Equatable {
  final String value;

  const NodeId(this.value);

  @override
  @mustCallSuper
  List<Object?> get props => [value];

  /// Appends [value] with dot separator.
  NodeId child(String value) => NodeId('${this.value}.$value');

  /// Returns true if this node is a child of [parent] node, false otherwise.
  bool isChildOf(NodeId parent) => value.startsWith(parent.value);
}
