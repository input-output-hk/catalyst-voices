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
    if ('*'.allMatches(path).length > 1) {
      throw ArgumentError('Path must not contain more than one wildcard');
    }

    if (!hasWildcard) return null;

    final segments = pathSegments;

    for (var i = 0; i < segments.length; i++) {
      if (segments[i] == '*') {
        // Build prefix (everything up to this wildcard)
        final prefixSegments = segments.sublist(0, i);
        final prefixNodeId = NodeId(prefixSegments.join('.'));

        // Get suffix (everything after this wildcard)
        NodeId? suffixNodeId;
        if (i < segments.length - 1) {
          final suffixSegments = segments.sublist(i + 1);
          suffixNodeId = NodeId(suffixSegments.join('.'));
        }

        return (prefix: prefixNodeId, suffix: suffixNodeId);
      }
    }

    return null;
  }

  bool get hasWildcard => pathSegments.contains('*');

  List<String> get pathSegments => path.split('.');

  @override
  List<Object?> get props => [path];

  /// Determines if a given NodeId matches this wildcard pattern
  bool matches(NodeId nodeId) {
    final patternSegments = pathSegments;
    final targetSegments = nodeId.value.split('.');

    if (patternSegments.isNotEmpty && patternSegments.first == '*') {
      final subPattern = patternSegments.sublist(1);
      for (var i = targetSegments.length - subPattern.length; i >= 0; --i) {
        var matches = true;
        for (var j = 0; j < subPattern.length; ++j) {
          if (subPattern[j] != targetSegments[i + j] && subPattern[j] != '*') {
            matches = false;
            break;
          }
        }
        if (matches) return true;
      }
      return false;
    }

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
