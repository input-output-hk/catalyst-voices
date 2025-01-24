import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/builders/types.dart';

/// A builder that constructs the minimal required transaction inputs from a set
/// of inputs using a coin selection algorithm.
///
/// The `InputBuilder` processes a set of transaction inputs and applies
/// a coin selection algorithm to determine the minimal required inputs needed
/// to satisfy the transaction outputs and fees. It produces a new selection
/// result containing:
/// - The selected inputs.
/// - Change outputs, if applicable.
/// - The calculated transaction fee.
///
final class InputBuilder implements CoinSelector {
  /// Strategy used to prioritise the available UTxOs.
  final CoinSelectionStrategy selectionStrategy;

  /// Creates an [InputBuilder] with the given [selectionStrategy].
  InputBuilder({required this.selectionStrategy});

  /// Selects inputs to satisfy transaction outputs and fees.
  ///
  /// Throws:
  /// - An exception if the coin selection algorithm fails to satisfy the
  ///   transaction's requirements.
  @override
  SelectionResult selectInputs({
    required TransactionBuilder builder,
    int minInputs = CoinSelector.minInputs,
    int maxInputs = CoinSelector.maxInputs,
  }) {
    final availableInputs = builder.inputs.toSet();
    final selectedInputs = <TransactionUnspentOutput>{};

    final inputTotal = builder.inputs.fold<Balance>(
      const Balance.zero(),
      (sum, input) => sum + input.output.amount,
    );

    final targetTotal = builder.outputs.fold<Balance>(
      const Balance.zero(),
      (sum, output) => sum + output.amount,
    );

    if (inputTotal.lessThan(targetTotal)) {
      // TODO(ilap): Create proper exception class for multiassets
      throw InsufficientUtxoBalanceException(
        actualAmount: targetTotal.coin,
        requiredAmount: inputTotal.coin,
      );
    }

    /// Build the asset group
    final tokenGroups = buildAssetGroup(targetTotal, availableInputs);
    // Apply the selection strategy on the built group.
    selectionStrategy.apply(tokenGroups);

    var selectedTotal = const Balance.zero();

    for (final entry in tokenGroups) {
      final assetId = entry.key;
      final tokenUtxos = entry.value;

      while (true) {
        if (tokenUtxos.isEmpty || availableInputs.isEmpty) {
          // TODO(ilap): Create proper exception class.
          throw Exception('Insufficient UTxO balance.');
        }

        final utxo = tokenUtxos.removeAt(0);
        if (!availableInputs.remove(utxo)) continue;

        selectedInputs.add(utxo);

        if (selectedInputs.length > maxInputs) {
          // TODO(ilap): Create proper exception class.
          throw Exception('Exceeded maximum input count: $maxInputs');
        }

        selectedTotal += utxo.output.amount;

        /// If a native token requirements have met then we break out to process
        /// the other token.
        if (assetId != CoinSelector.adaAssetId &&
            _getTokenAmount(assetId, selectedTotal) >=
                _getTokenAmount(assetId, targetTotal)) {
          break;

          /// All native tokens have been processed, therefore we can build
          /// change outputs and calculate transaction fee.
        } else {
          final changeAndFee = _getChangeAndFee(
            assetId,
            builder,
            selectedInputs,
            selectedTotal,
            targetTotal,
          );

          if (changeAndFee == null || selectedInputs.length < minInputs) {
            continue;
          }
          final (changeOutputs, totalFee) = changeAndFee;

          return (selectedInputs, changeOutputs, totalFee);
        }
      }
    }

    // TODO(ilap): Create proper exception class.
    throw Exception('Insufficient UTxO balance.');
  }

  /// Groups UTxOs by token, mapping each token to its corresponding UTxOs.
  @override
  AssetsGroup buildAssetGroup(
    Balance requiredBalance,
    Set<TransactionUnspentOutput> inputs,
  ) {
    final tokenMap = <AssetId, List<TransactionUnspentOutput>>{};
    final requiredAssets = requiredBalance.multiAsset?.bundle ?? {};

    for (final input in inputs) {
      final inputBalance = input.output.amount;
      final inputPolicies =
          inputBalance.multiAsset?.bundle.keys ?? <PolicyId>[];

      for (final policy in [CoinSelector.adaPolicy, ...inputPolicies]) {
        if (requiredAssets.containsKey(policy)) {
          final assets = inputBalance.multiAsset!.bundle[policy]!.entries;

          for (final asset in assets) {
            final assetId = (policy, asset.key);
            tokenMap.putIfAbsent(assetId, () => []).add(input);
          }
        } else {
          tokenMap.putIfAbsent(CoinSelector.adaAssetId, () => []).add(input);
        }
      }
    }

    return tokenMap.entries.toList()
      ..sort((a, b) => b.key.$1.hash.compareTo(a.key.$1.hash));
  }

  /// Retrieves the change outputs and the total transaction fee, if applicable.
  ///
  /// This method calculates whether there is sufficient balance to cover the
  /// required amount and associated fees, then retrieves the pre-constructed
  /// change outputs and the total transaction fee.
  ///
  /// - Parameters:
  ///   - [assetId]: The token identifier for which the change is being 
  ///     calculated.
  ///   - [builder]: The transaction builder used to create the transaction.
  ///   - [selectedInputs]: The set of selected UTxOs to fund the transaction.
  ///   - [selectedTotal]: The total balance accumulated from selected inputs.
  ///   - [targetTotal]: The balance required to satisfy the transaction's
  ///     outputs and minimum ADA requirements.
  ///
  /// - Returns:
  ///   A tuple containing:
  ///   - [List<TransactionOutput>]: The list of change outputs.
  ///   - [Coin]: The total transaction fee, including the fee for the change
  ///     outputs.
  ///   Returns `null` if the accumulated balance is insufficient to cover the
  ///   required amount and fees.
  ///
  /// - Notes:
  ///   - This method ensures the transaction remains valid by confirming that
  ///     the accumulated balance exceeds or equals the required amount plus 
  ///     fees.
  (List<TransactionOutput>, Coin)? _getChangeAndFee(
    AssetId assetId,
    TransactionBuilder builder,
    Set<TransactionUnspentOutput> selectedInputs,
    Balance selectedTotal,
    Balance targetTotal,
  ) {
    final minFee =
        builder.copyWith(inputs: selectedInputs).minFee(useWitnesses: true);
    
    final minimumRequired = targetTotal + Balance(coin: minFee);

    if (selectedTotal.lessThan(minimumRequired)) return null;

    final changeTotal = selectedTotal - minimumRequired;
    final (changeOutputs, changeFee) = _buildChangeOutputs(
      builder,
      changeTotal,
      minFee,
    );

    final requiredFee = minFee + changeFee;
    if (selectedTotal
        .lessThan(targetTotal + Balance(coin: requiredFee))) {
      return null;
    }

    return (changeOutputs, requiredFee);
  }

  /// Constructs the change outputs and calculates their associated fees.
  ///
  /// This method generates the necessary change outputs based on the remaining
  /// balance after covering the required amount and transaction fees. It also
  /// calculates the additional fee incurred by the change outputs.
  ///
  /// - Parameters:
  ///   - [builder]: The transaction builder used to create the transaction.
  ///   - [remainingBalance]: The balance remaining after deducting the required
  ///     amount and initial fees.
  ///   - [minFee]: The minimum fee for the transaction before considering 
  ///     change outputs.
  ///
  /// - Returns:
  ///   A tuple containing:
  ///   - [List<TransactionOutput>]: The list of change outputs.
  ///   - [Coin]: The additional fee incurred by the change outputs.
  ///
  /// - Notes:
  ///   - If the remaining balance is zero, no change outputs are created, and
  ///     the fee remains unchanged.
  ///   - This method handles multi-asset balances and ensures they are included
  ///     in the change outputs, if applicable.
  (List<TransactionOutput>, Coin) _buildChangeOutputs(
    TransactionBuilder builder,
    Balance remainingBalance,
    Coin minFee,
  ) {
    if (remainingBalance.isZero) return ([], const Coin(0));

    if (builder.changeAddress == null) {
      throw Exception('Change address required for non-zero balance.');
    }

    final changeOutputs = <TransactionOutput>[];
    final output = TransactionOutput(
      address: builder.changeAddress!,
      amount: remainingBalance,
    );
    final changeFee = TransactionOutputBuilder.feeForOutput(
      builder.config,
      output,
    );
    final minAda = TransactionOutputBuilder.minimumAdaForOutput(
      output,
      builder.config.coinsPerUtxoByte,
    );

    if (remainingBalance.coin >= minAda + changeFee) {
      changeOutputs.add(
        output.copyWith(amount: remainingBalance - Balance(coin: changeFee)),
      );
      return (changeOutputs, changeFee);
    } else {
      return ([], minAda + changeFee);
    }
  }

  /// Retrieves the amount of a specific token in a balance or zero amount.
  Coin _getTokenAmount(AssetId assetId, Balance balance) {
    final (policy, assetName) = assetId;
    return assetId == CoinSelector.adaAssetId
        ? balance.coin
        : balance.multiAsset?.bundle[policy]?[assetName] ?? const Coin(0);
  }
}
