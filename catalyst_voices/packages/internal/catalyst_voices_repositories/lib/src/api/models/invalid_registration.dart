import 'package:catalyst_voices_repositories/src/common/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invalid_registration.g.dart';

/// An invalid RBAC registration.
@JsonSerializable()
final class InvalidRegistration {
  /// A time of the registration transaction.
  final DateTime time;

  /// Transaction Id/Hash
  /// A transaction identifier (hash).
  @JsonKey(name: 'txn_id')
  final String txnId;

  /// Cardano Blockchain Slot Number
  /// A block slot number.
  final int slot;

  /// Transaction Index
  @JsonKey(name: 'txn_index')
  final int txnIndex;

  /// Error Message
  /// A problem report.
  final String report;

  /// Transaction Id/Hash
  /// A previous transaction ID.
  @JsonKey(name: 'previous_txn')
  final String? previousTxn;

  /// UUIDv4
  /// A registration purpose.
  final String? purpose;

  const InvalidRegistration({
    required this.time,
    required this.txnId,
    required this.slot,
    required this.txnIndex,
    required this.report,
    this.previousTxn,
    this.purpose,
  });

  factory InvalidRegistration.fromJson(Json json) => _$InvalidRegistrationFromJson(json);

  Json toJson() => _$InvalidRegistrationToJson(this);
}
