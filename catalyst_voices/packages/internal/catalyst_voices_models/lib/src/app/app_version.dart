import 'package:equatable/equatable.dart';

class AppVersion extends Equatable implements Comparable<AppVersion> {
  final String versionNumber;
  final int buildNumber;

  const AppVersion({required this.versionNumber, required this.buildNumber});

  @override
  List<Object?> get props => [versionNumber, buildNumber];

  /// Compares this version to another version.
  ///
  /// Returns:
  /// - Negative value if this version is older than [other]
  /// - Zero if versions are equal
  /// - Positive value if this version is newer than [other]
  ///
  /// Comparison logic:
  /// 1. First compares build numbers
  /// 2. If build numbers are equal, compares semantic version strings
  @override
  int compareTo(AppVersion other) {
    final buildComparison = buildNumber.compareTo(other.buildNumber);
    if (buildComparison != 0) {
      return buildComparison;
    }

    final thisVersion = _parseSemanticVersion(versionNumber);
    final otherVersion = _parseSemanticVersion(other.versionNumber);

    // If parsing fails, assume this version is newer to ensure updates are downloaded
    // (conservative approach - better to download than miss an update)
    // probability that parsing of semantic versioning fails is quite low
    if (thisVersion == null || otherVersion == null) {
      return 1;
    }

    if (thisVersion.major != otherVersion.major) {
      return thisVersion.major.compareTo(otherVersion.major);
    }

    if (thisVersion.minor != otherVersion.minor) {
      return thisVersion.minor.compareTo(otherVersion.minor);
    }

    return thisVersion.patch.compareTo(otherVersion.patch);
  }

  /// Returns true if this version is newer than [other].
  ///
  /// Comparison logic:
  /// 1. First compares build numbers
  /// 2. If build numbers are equal, compares semantic version strings
  bool isNewerThan(AppVersion other) => compareTo(other) > 0;

  /// Parses a semantic version string (e.g., "1.2.3") into components.
  _SemanticVersion? _parseSemanticVersion(String versionString) {
    try {
      final parts = versionString.split('.');
      if (parts.length < 2 || parts.length > 3) {
        return null;
      }

      final major = int.parse(parts[0]);
      final minor = int.parse(parts[1]);
      final patch = parts.length == 3 ? int.parse(parts[2]) : 0;

      return _SemanticVersion(major: major, minor: minor, patch: patch);
    } catch (_) {
      return null;
    }
  }
}

/// Internal class to represent a parsed semantic version.
class _SemanticVersion {
  final int major;
  final int minor;
  final int patch;

  const _SemanticVersion({
    required this.major,
    required this.minor,
    required this.patch,
  });
}
