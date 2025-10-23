import 'package:catalyst_voices_repositories/src/api/models/key_type.dart';
import 'package:catalyst_voices_repositories/src/api/models/key_value.dart';
import 'package:catalyst_voices_repositories/src/common/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'key_data.g.dart';

/// A role data key information.
@JsonSerializable()
final class KeyData {
  /// Indicates if the data is persistent or volatile.
  @JsonKey(name: 'is_persistent')
  final bool isPersistent;

  /// A time when the data was added.
  final DateTime time;

  /// Cardano Blockchain Slot Number
  /// A block slot number.
  final int slot;

  /// Transaction Index
  @JsonKey(name: 'txn_index')
  final int txnIndex;

  /// A key type for role data.
  @JsonKey(name: 'key_type')
  final KeyType keyType;

  /// A key value for role data.
  /// A value of the key.
  /// The key was deleted if this field is absent or nil.
  @JsonKey(name: 'key_value')
  final KeyValue? keyValue;

  const KeyData({
    required this.isPersistent,
    required this.time,
    required this.slot,
    required this.txnIndex,
    required this.keyType,
    this.keyValue,
  });

  factory KeyData.fromJson(Json json) => _$KeyDataFromJson(json);

  Json toJson() => _$KeyDataToJson(this);
}
