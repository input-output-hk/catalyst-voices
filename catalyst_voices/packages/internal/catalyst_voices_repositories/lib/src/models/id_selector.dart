import 'package:catalyst_voices_repositories/src/common/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'id_selector.g.dart';

/// Either a Single Document ID, or a Range of Document IDs, or Inclusion from the List of IDs
@JsonSerializable(createFactory: false, includeIfNull: false)
final class IdSelector {
  /// Signed Document ID
  /// The exact Document ID to match against.
  final String? eq;

  /// Signed Document ID"
  /// Minimum Document ID to find (inclusive)
  final String? min;

  /// Signed Document ID
  /// Maximum Document ID to find (inclusive)
  final String? max;

  /// Signed Document ID
  /// Unique [Document ID](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id).
  ///
  /// UUIDv7 Formatted 128bit value.
  @JsonKey(name: 'in')
  final List<String>? inside;

  /// A single Document IDs.
  /// The exact Document ID to match against.
  const IdSelector.eq(this.eq) : min = null, max = null, inside = null;

  /// Any Document IDs from the list
  /// Matching any Document IDs from the list
  const IdSelector.inside(List<String> data) : eq = null, min = null, max = null, inside = data;

  /// A range of Document IDs.
  /// Minimum Document ID to find (inclusive)
  const IdSelector.range({
    required this.min,
    required this.max,
  }) : eq = null,
       inside = null;

  Json toJson() => _$IdSelectorToJson(this);
}
