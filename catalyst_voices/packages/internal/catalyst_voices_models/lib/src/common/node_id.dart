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
  /// A separator in the [value] which separates segments.
  static const String separator = '.';

  /// A path consisting of segments separated by [separator].
  ///
  /// Examples:
  /// - proposer
  /// - proposer.name
  final String value;

  const NodeId(this.value);

  @override
  @mustCallSuper
  List<Object?> get props => [value];

  /// Appends [value] with dot separator.
  NodeId child(String value) => NodeId('${this.value}.$value');

  /// Returns true if this node is a child of [parent] node, false otherwise.
  ///
  /// Disambiguation:
  /// - `proposer.requestedFundsUsd` is not a child of `proposer.requestedFunds`.
  /// - `proposer.requestedFundsUsd` is a child of `proposer`.
  bool isChildOf(NodeId parent) {
    return value.startsWith(parent.value) &&
        value.length > parent.value.length &&
        value[parent.value.length] == separator;
  }

  /// Returns true if this node id matches the given pattern, supporting '*' as a wildcard for
  /// a single segment.
  bool matchesPattern(NodeId pattern) {
    final handler = WildcardPathHandler.fromNodeId(pattern);
    return handler.matches(this);
  }
}
