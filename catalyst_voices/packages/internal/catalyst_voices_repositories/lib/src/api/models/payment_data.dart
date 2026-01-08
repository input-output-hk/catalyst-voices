import 'package:json_annotation/json_annotation.dart';

part 'payment_data.g.dart';

/// A role payment address information.
@JsonSerializable()
final class PaymentData {
  /// Indicates if the data is persistent or volatile.
  @JsonKey(name: 'is_persistent')
  final bool isPersistent;

  /// A time when the address was added.
  final DateTime time;

  /// Cardano Blockchain Slot Number
  /// A block slot number.
  final int slot;

  /// Transaction Index
  @JsonKey(name: 'txn_index')
  final int txnIndex;

  /// Cardano Payment Address
  /// An option payment address.
  /// CIP-19 - Cardano Addresses - https://cips.cardano.org/cip/CIP-19
  final String? address;

  const PaymentData({
    required this.isPersistent,
    required this.time,
    required this.slot,
    required this.txnIndex,
    this.address,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) => _$PaymentDataFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDataToJson(this);
}
