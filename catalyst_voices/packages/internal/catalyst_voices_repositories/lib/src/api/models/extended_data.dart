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

  factory ExtendedData.fromJson(Map<String, dynamic> json) => _$ExtendedDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExtendedDataToJson(this);
}
