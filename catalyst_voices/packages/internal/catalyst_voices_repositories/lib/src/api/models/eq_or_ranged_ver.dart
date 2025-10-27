import 'package:json_annotation/json_annotation.dart';

part 'eq_or_ranged_ver.g.dart';

/// Document or Range of Documents
///
/// Either a Single Document Version, or a Range of Document Versions
@JsonSerializable(createFactory: false, includeIfNull: false)
final class EqOrRangedVer {
  /// Signed Document Version
  /// The exact Document ID to match against.
  final String? eq;

  /// Signed Document Version
  /// Minimum Document Version to find (inclusive)
  final String? min;

  /// Signed Document Version
  /// Maximum Document Version to find (inclusive)
  final String? max;

  /// A single Document IDs.
  /// The exact Document ID to match against.
  const EqOrRangedVer.eq(String this.eq) : min = null, max = null;

  /// Version Range
  ///
  /// A Range of document versions from minimum to maximum inclusive.
  const EqOrRangedVer.range({
    required String this.min,
    required String this.max,
  }) : eq = null;

  Map<String, dynamic> toJson() => _$EqOrRangedVerToJson(this);
}
