import 'package:catalyst_cardano_serialization/src/signature.dart';
import 'package:catalyst_cardano_serialization/src/witness.dart';
import 'package:equatable/equatable.dart';

/// A builder that builds [TransactionWitnessSet].
///
/// Holds transaction witnesses that sign the transaction and prove it is valid.
final class TransactionWitnessSetBuilder extends Equatable {
  /// The map of transaction witnesses.
  final Map<Ed25519PublicKey, VkeyWitness> vkeys;

  /// The default constructor for [TransactionWitnessSetBuilder].
  const TransactionWitnessSetBuilder({
    required this.vkeys,
  });

  @override
  List<Object?> get props => [vkeys];

  /// Adds a [witness] to the set.
  TransactionWitnessSetBuilder addVkey(VkeyWitness witness) {
    final map = Map.of(vkeys);
    map[witness.vkey] = witness;
    return TransactionWitnessSetBuilder(vkeys: map);
  }

  /// Builds the [TransactionWitnessSet].
  TransactionWitnessSet build() {
    return TransactionWitnessSet(
      vkeyWitnesses: vkeys.values.toSet(),
    );
  }

  /// Removes the witness with [vkey] from the set.
  TransactionWitnessSetBuilder removeVkey(Ed25519PublicKey vkey) {
    final map = Map.of(vkeys)..remove(vkey);
    return TransactionWitnessSetBuilder(
      vkeys: map,
    );
  }
}
