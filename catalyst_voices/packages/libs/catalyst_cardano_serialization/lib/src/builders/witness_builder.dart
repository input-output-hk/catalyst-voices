import 'package:catalyst_cardano_serialization/src/exceptions.dart';
import 'package:catalyst_cardano_serialization/src/signature.dart';
import 'package:catalyst_cardano_serialization/src/witness.dart';
import 'package:equatable/equatable.dart';

/// A builder that builds [TransactionWitnessSet].
///
/// Holds transaction witnesses that sign the transaction and prove it is valid.
final class TransactionWitnessSetBuilder extends Equatable {
  /// The map of transaction witnesses.
  final Map<Ed25519PublicKey, VkeyWitness> vkeys;

  /// The expected amount of [vkeys] that should be added via [addVkey]
  /// before it is possible to call [build] method.
  ///
  /// The caller should know in advance how many witnesses there will
  /// be in order to calculate the correct transaction fee before the
  /// transaction is signed.
  final int vkeysCount;

  /// The default constructor for [TransactionWitnessSetBuilder].
  const TransactionWitnessSetBuilder({
    required this.vkeys,
    required this.vkeysCount,
  });

  /// Adds a [witness] to the set.
  TransactionWitnessSetBuilder addVkey(VkeyWitness witness) {
    final map = Map.of(vkeys);
    map[witness.vkey] = witness;
    return TransactionWitnessSetBuilder(
      vkeys: map,
      vkeysCount: vkeysCount,
    );
  }

  /// Removes the witness with [vkey] from the set.
  TransactionWitnessSetBuilder removeVkey(Ed25519PublicKey vkey) {
    final map = Map.of(vkeys)..remove(vkey);
    return TransactionWitnessSetBuilder(
      vkeys: map,
      vkeysCount: vkeysCount,
    );
  }

  /// Builds the [TransactionWitnessSet]. Before calling this method make
  /// sure that [vkeysCount] amount of witnesses have been added via [addVkey].
  TransactionWitnessSet build() {
    if (vkeysCount != vkeys.values.length) {
      throw const InvalidTransactionWitnessesException();
    }

    return TransactionWitnessSet(
      vkeyWitnesses: vkeys.values.toSet(),
    );
  }

  /// Builds the fake [TransactionWitnessSet] that is needed to reserve
  /// enough bytes in the transaction for the future witnesses which
  /// will sign the transaction.
  TransactionWitnessSet buildFake() {
    return TransactionWitnessSet(
      vkeyWitnesses: {
        for (int i = 0; i < vkeysCount; i++) VkeyWitness.seeded(i),
      },
    );
  }

  @override
  List<Object?> get props => [vkeys, vkeysCount];
}
