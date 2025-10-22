import 'package:catalyst_voices_repositories/src/common/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'eq_or_ranged_id.g.dart';

/// Either a Single Document ID, or a Range of Document IDs
@JsonSerializable(createFactory: false, includeIfNull: false)
final class EqOrRangedId {
  /// Signed Document ID
  /// The exact Document ID to match against.
  final String? eq;

  /// Signed Document ID
  /// Minimum Document ID to find (inclusive)
  final String? min;

  /// Signed Document ID
  /// Maximum Document ID to find (inclusive)
  final String? max;

  /// A single Document IDs.
  const EqOrRangedId.eq(String this.eq) : min = null, max = null;

  /// A range of Document IDs.
  const EqOrRangedId.range({
    required String this.min,
    required String this.max,
  }) : eq = null;

  Json toJson() => _$EqOrRangedIdToJson(this);
}
