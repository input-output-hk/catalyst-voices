import 'package:json_annotation/json_annotation.dart';

part 'ver_selector.g.dart';

/// Document or Range of Documents
///
/// Either a Single Document Version, or a Range of Document Versions
@JsonSerializable(createFactory: false, includeIfNull: false)
final class VerSelector {
  /// Signed Document Version
  /// The exact Document ID to match against.
  final String? eq;

  /// Signed Document Version
  /// Minimum Document Version to find (inclusive)
  final String? min;

  /// Signed Document Version
  /// Maximum Document Version to find (inclusive)
  final String? max;

  /// Signed Document Version
  /// Document versions from the list.
  @JsonKey(name: 'in')
  final List<String>? inside;

  /// Version Equals
  /// A specific single
  /// [Document Version](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver).
  const VerSelector.eq(String this.eq) : min = null, max = null, inside = null;

  /// Document versions from the list.
  /// A list of
  /// [Document IDs](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#id).
  const VerSelector.inside(List<String> this.inside) : eq = null, min = null, max = null;

  /// Version Range
  ///
  /// A range of
  /// [Document Version](https://input-output-hk.github.io/catalyst-libs/architecture/08_concepts/signed_doc/spec/#ver).
  const VerSelector.range({
    required String this.min,
    required String this.max,
  }) : eq = null,
       inside = null;

  Map<String, dynamic> toJson() => _$VerSelectorToJson(this);
}
