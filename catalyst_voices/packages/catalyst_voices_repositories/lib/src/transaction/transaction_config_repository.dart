import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';

/// Manages the [TransactionBuilderConfig].
class TransactionConfigRepository {
  /// Returns the current [TransactionBuilderConfig] for given [network].
  ///
  /// In the future this might communicate with a blockchain
  /// to obtain the parameters, for now they are hardcoded.
  Future<TransactionBuilderConfig> fetch(NetworkId network) async {
    return const TransactionBuilderConfig(
      feeAlgo: TieredFee(
        constant: 155381,
        coefficient: 44,
        refScriptByteCost: 15,
      ),
      maxTxSize: 16384,
      maxValueSize: 5000,
      coinsPerUtxoByte: Coin(4310),
    );
  }
}
