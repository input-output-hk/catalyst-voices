import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WildcardPathHandler extends Equatable {
  final String value;

  const WildcardPathHandler(this.value);

  String get asPath {
    if (pathSegments.isEmpty) return r'$';
    final buffer = StringBuffer(r'$');
    for (final segment in pathSegments) {
      buffer.write('.$segment');
    }
    return buffer.toString();
  }

  bool get hasWildcard => pathSegments.contains('*');

  List<String> get pathSegments => value.split('.');

  @override
  @mustCallSuper
  List<Object?> get props => [value];

  /// If the path contains a wildcard, returns the path before the wildcard
  /// and the field after the wildcard. Otherwise returns null.
  /// For example, for 'milestones.milestones.milestone_list.*.title',
  /// returns ('$.milestones.milestones.milestone_list', 'title').
  ({String prefix, String? suffix})? get wildcardPaths {
    if (!hasWildcard) return null;

    final wildcardIndex = pathSegments.indexOf('*');
    if (wildcardIndex == -1) return null;

    final pathBeforeWildcard = StringBuffer(r'$');
    for (var i = 0; i < wildcardIndex; i++) {
      pathBeforeWildcard.write('.${pathSegments[i]}');
    }

    String? fieldAfterWildcard;
    if (wildcardIndex < pathSegments.length - 1) {
      fieldAfterWildcard = pathSegments[wildcardIndex + 1];
    }

    return (prefix: pathBeforeWildcard.toString(), suffix: fieldAfterWildcard);
  }
}
