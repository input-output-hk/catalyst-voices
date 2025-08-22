import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:equatable/equatable.dart';

/// The chain slot number related configuration.
/// Contains data necessary to calculate an approximate
/// slot number at given timestamp.
///
/// For [systemStartTimestamp] and [systemStartSlot] see: https://github.com/Biglup/cardano-c/blob/2a8399f4c7c6a443b9533e148b54a07077bae4a6/lib/src/time.c#L69-L72
/// For [slotLength] see: https://docs.cardano.org/cardano-testnets/environments.
final class BlockchainSlotNumberConfig extends Equatable {
  /// The datetime when the current chain started.
  final DateTime systemStartTimestamp;

  /// The [SlotBigNum] corresponding to the [systemStartTimestamp].
  final SlotBigNum systemStartSlot;

  /// The duration of a slot.
  final Duration slotLength;

  const BlockchainSlotNumberConfig({
    required this.systemStartTimestamp,
    required this.systemStartSlot,
    required this.slotLength,
  });

  /// The [NetworkId.mainnet] configuration.
  factory BlockchainSlotNumberConfig.mainnet() {
    return BlockchainSlotNumberConfig(
      systemStartTimestamp: DateTime.utc(2020, 7, 29, 21, 44, 51),
      systemStartSlot: const SlotBigNum(4492800),
      slotLength: const Duration(seconds: 1),
    );
  }

  /// The [NetworkId.testnet] configuration.
  factory BlockchainSlotNumberConfig.testnet() {
    return BlockchainSlotNumberConfig(
      systemStartTimestamp: DateTime.utc(2022, 6, 21),
      systemStartSlot: const SlotBigNum(86400),
      slotLength: const Duration(seconds: 1),
    );
  }

  @override
  List<Object?> get props => [
    systemStartTimestamp,
    systemStartSlot,
    slotLength,
  ];

  BlockchainSlotNumberConfig copyWith({
    DateTime? systemStartTimestamp,
    SlotBigNum? systemStartSlot,
    Duration? slotLength,
  }) {
    return BlockchainSlotNumberConfig(
      systemStartTimestamp: systemStartTimestamp ?? this.systemStartTimestamp,
      systemStartSlot: systemStartSlot ?? this.systemStartSlot,
      slotLength: slotLength ?? this.slotLength,
    );
  }
}
