import 'package:json_annotation/json_annotation.dart';

part 'id_selector.g.dart';

/// Either a Single Document ID, or a Range of Document IDs
@JsonSerializable(createFactory: false, includeIfNull: false)
final class IdSelector {
  /// Signed Document ID
  /// The exact Document ID to match against.
  final String? eq;

  /// Signed Document ID
  /// Minimum Document ID to find (inclusive)
  final String? min;

  /// Signed Document ID
  /// Maximum Document ID to find (inclusive)
  final String? max;

  /// Signed Document ID
  /// Document IDs from the list.
  @JsonKey(name: 'in')
  final List<String>? inside;

  /// A specific single
  /// [Document ID](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id).
  const IdSelector.eq(String this.eq) : min = null, max = null, inside = null;

  /// Document IDs from the list.
  /// A list of
  /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id).
  const IdSelector.inside(List<String> this.inside) : eq = null, min = null, max = null;

  /// A range of
  /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id).
  const IdSelector.range({
    required String this.min,
    required String this.max,
  }) : eq = null,
       inside = null;

  Map<String, dynamic> toJson() => _$IdSelectorToJson(this);
}
