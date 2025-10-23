import 'package:catalyst_voices_repositories/src/common/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'extended_data.g.dart';

/// A role extended data.
@JsonSerializable()
final class ExtendedData {
  /// Extended data key
  final int key;

  /// Extended data value
  final String value;

  const ExtendedData({
    required this.key,
    required this.value,
  });

  factory ExtendedData.fromJson(Json json) => _$ExtendedDataFromJson(json);

  Json toJson() => _$ExtendedDataToJson(this);
}
