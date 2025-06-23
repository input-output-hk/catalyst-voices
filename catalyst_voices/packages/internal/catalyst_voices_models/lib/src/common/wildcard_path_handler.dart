import 'package:catalyst_voices_models/src/common/node_id.dart';
import 'package:equatable/equatable.dart';

/// A handler that processes paths with wildcards.
/// This class interprets node paths and provides utilities for working with wildcards.
class WildcardPathHandler extends Equatable {
  final String path;

  const WildcardPathHandler(this.path);

  /// Create a handler from a NodeId
  factory WildcardPathHandler.fromNodeId(NodeId nodeId) => WildcardPathHandler(nodeId.value);

  /// Returns all wildcard path segments in this path.
  /// For each wildcard, returns the NodeId prefix leading to it and the NodeId suffix following it.
  /// Returns null if no wildcards are present.
  ({NodeId prefix, NodeId? suffix})? get getWildcardPaths {
    if (!hasWildcard) return null;

    final segments = path.split('*');
    final prefixSegment = NodeId(segments.first);
    if (segments.length == 1) return (prefix: prefixSegment, suffix: null);
    final suffixSegment = NodeId(segments.last);
    return (prefix: prefixSegment, suffix: suffixSegment);
  }

  bool get hasWildcard => pathSegments.contains('*');

  List<String> get pathSegments => path.split('.');

  @override
  List<Object?> get props => [path];

  /// Determines if a given NodeId matches this wildcard pattern
  bool matches(NodeId nodeId) {
    final patternSegments = pathSegments;
    final targetSegments = nodeId.value.split('.');

    if (patternSegments.length > targetSegments.length) {
      return false; // The pattern can't be longer than the target.
    }

    for (var i = 0; i < patternSegments.length; i++) {
      if (patternSegments[i] == '*') continue; // Wildcard matches any segment.
      if (patternSegments[i] != targetSegments[i]) return false; // Segments must match.
    }

    // Match if the target has been fully checked or only wildcards are left.
    return patternSegments.length == targetSegments.length ||
        (patternSegments.length < targetSegments.length && hasWildcard);
  }
}
