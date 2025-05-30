import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/builders/types.dart';
import 'package:cbor/cbor.dart';

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
  /// Strategy used to prioritize the available UTxOs.
  final CoinSelectionStrategy selectionStrategy;

  /// Creates an [InputBuilder] with the given [selectionStrategy].
  const InputBuilder({required this.selectionStrategy});

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
    // Cap max inputs limit to prevent transaction size explosion
    // Each input adds 40 to 50 bytes + witness overhead, so 50 inputs is a large transaction
    maxInputs = maxInputs.clamp(1, 50);
    final availableInputs = builder.inputs.toSet();
    final selectedInputs = <TransactionUnspentOutput>{};

    final inputTotal = CoinSelector.sumAmounts(
      builder.inputs,
      (input) => input.output.amount,
    );
    final targetTotal = CoinSelector.sumAmounts(
      builder.outputs,
      (output) => output.amount,
    );

    // Exit early if the available inputs cannot cover the required outputs.
    if (inputTotal.lessThan(targetTotal)) {
      throw InsufficientUtxoBalanceException(
        actualAmount: inputTotal,
        requiredAmount: targetTotal,
      );
    }

    // Group UTXOs by asset ID for coin selection.
    final assetGroups = buildAssetGroups(targetTotal, availableInputs);

    // Apply the coin selection strategy to prioritize UTXOs within each group.
    selectionStrategy.apply(assetGroups);

    final groupCount = assetGroups.length;
    var selectedTotal = const Balance.zero();

    // Iterate through each asset group (native tokens + ADA as the last group).
    for (final entry in assetGroups) {
      final assetId = entry.key;
      final assetUtxos = entry.value;

      // Determine if change should be calculated for the current asset group.
      final shouldCalculateChange =
          assetId == CoinSelector.adaAssetId || assetGroups[groupCount - 2].key == assetId;

      while (assetUtxos.isNotEmpty) {
        // Check if there are no more available inputs or if the maximum number
        // of inputs has been exceeded.
        if (availableInputs.isEmpty || selectedInputs.length > maxInputs) {
          throw InsufficientUtxoBalanceException(
            actualAmount: selectedTotal,
            requiredAmount: targetTotal,
          );
        }

        // Select the first available UTXO from the list of asset UTXOs.
        final utxo = assetUtxos.removeAt(0);

        // Check if the UTXO is still available for selection.
        if (!availableInputs.remove(utxo)) continue;

        // Add the UTXO to the selected inputs and update the selected total.
        selectedInputs.add(utxo);
        selectedTotal += utxo.output.amount;

        // Check if the requirements have met.
        if (_getAssetAmount(assetId, selectedTotal) < _getAssetAmount(assetId, targetTotal)) {
          if (assetUtxos.isEmpty) {
            throw InsufficientUtxoBalanceException(
              actualAmount: selectedTotal,
              requiredAmount: targetTotal,
            );
          } else {
            continue;
          }
        }

        if (shouldCalculateChange && selectedInputs.length >= minInputs) {
          final changeAndFee = _getChangeAndFee(
            assetId,
            builder,
            selectedInputs,
            selectedTotal,
            targetTotal,
          );

          // Return the selection result if change and fees are successfully
          // calculated.
          if (changeAndFee != null) {
            final (changeOutputs, totalFee) = changeAndFee;
            return (selectedInputs, changeOutputs, totalFee);
          }
        }
      }
    }

    // Throw an exception if the selection process fails to meet the
    // requirements.
    throw InsufficientUtxoBalanceException(
      actualAmount: selectedTotal,
      requiredAmount: targetTotal,
    );
  }

  /// Groups UTxOs by token, mapping each token to its corresponding UTxOs.
  @override
  AssetsGroup buildAssetGroups(
    Balance requiredBalance,
    Set<TransactionUnspentOutput> inputs,
  ) {
    final assetMap = <AssetId, List<TransactionUnspentOutput>>{};
    final requiredAssets = requiredBalance.multiAsset?.bundle ?? {};

    for (final input in inputs) {
      final inputBalance = input.output.amount;
      final inputPolicies = inputBalance.multiAsset?.bundle.keys ?? <PolicyId>[];

      for (final policy in [CoinSelector.adaPolicy, ...inputPolicies]) {
        if (requiredAssets.containsKey(policy)) {
          final inputAssets = inputBalance.multiAsset!.bundle[policy]!.entries;

          for (final asset in inputAssets) {
            final assetId = (policy, asset.key);
            if (requiredAssets[policy]!.containsKey(asset.key)) {
              assetMap.putIfAbsent(assetId, () => []).add(input);
            } else {
              assetMap.putIfAbsent(CoinSelector.adaAssetId, () => []).add(input);
            }
          }
        } else {
          assetMap.putIfAbsent(CoinSelector.adaAssetId, () => []).add(input);
        }
      }
    }

    return assetMap.entries.toList()..sort((a, b) => b.key.$1.hash.compareTo(a.key.$1.hash));
  }

  /// Retrieves the change outputs and the total transaction fee, if applicable.
  ///
  /// This method calculates whether there is sufficient balance to cover the
  /// required amount and associated fees, then retrieves the pre-constructed
  /// change outputs and the total transaction fee.
  ///
  /// - Parameters:
  ///   - [assetId]: The identifier for which the change is being calculated.
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
  /// Calculates change outputs and the exact total fee using iterative approach.
  /// Returns `(changeOutputs, totalFee)` or `null` if funds are insufficient.
  (List<ShelleyMultiAssetTransactionOutput>, Coin)? _getChangeAndFee(
    AssetId assetId,
    TransactionBuilder builder,
    Set<TransactionUnspentOutput> selectedInputs,
    Balance selectedTotal,
    Balance targetTotal,
  ) {
    if (builder.changeAddress == null) {
      throw ArgumentError('Change address is required for fee calculation');
    }

    var currentBuilder = builder.copyWith(inputs: selectedInputs);
    var estimatedFee = currentBuilder.minFee(useWitnesses: true);
    
    // Add a dynamic buffer based on input complexity
    // More inputs = higher buffer
    // Testing showed more inputs required higher buffer
    final inputCount = selectedInputs.length;
    final bufferFactor = inputCount <= 5 
        ? 1.03  // 3% 
        : inputCount <= 20 
            ? 1.05  // 5%
            : 1.08; // 8%
            
    estimatedFee = Coin((estimatedFee.value * bufferFactor).ceil());
        final minimumRequired = targetTotal + Balance(coin: estimatedFee);
    if (selectedTotal.lessThan(minimumRequired)) {
      return null;
    }
    
    var remainingBalance = selectedTotal - minimumRequired;
    
     final maxIterations = inputCount <= 10 ? 3 : 5;
     for (var iteration = 0; iteration < maxIterations; iteration++) {
      final (changeOutputs, _) = _buildChangeOutputs(
        currentBuilder,
        remainingBalance,
        estimatedFee,
      );
      final completeBuilder = currentBuilder.copyWith(
        outputs: [...currentBuilder.outputs, ...changeOutputs],
      );
      
      final actualFee = completeBuilder.minFee(useWitnesses: true);
      
       if ((actualFee.value - estimatedFee.value).abs() < 500) {
         final bufferedFinalFee = Coin((actualFee.value * bufferFactor).ceil());
         
         final finalTotal = targetTotal + Balance(coin: bufferedFinalFee);
         if (selectedTotal.lessThan(finalTotal)) {
           return null;
         }
         
         final finalChange = selectedTotal - finalTotal;
         final (finalOutputs, _) = _buildChangeOutputs(
           currentBuilder,
           finalChange,
           bufferedFinalFee,
         );
         
         return (finalOutputs, bufferedFinalFee);
       }
      
      estimatedFee = actualFee;
      final newMinimum = targetTotal + Balance(coin: estimatedFee);
      if (selectedTotal.lessThan(newMinimum)) {
        return null;
      }
      remainingBalance = selectedTotal - newMinimum;
    }
    
     final bufferedFallbackFee = Coin((estimatedFee.value * bufferFactor).ceil());
     final finalTotal = targetTotal + Balance(coin: bufferedFallbackFee);
     if (selectedTotal.lessThan(finalTotal)) {
       return null;
     }
     
     final finalChange = selectedTotal - finalTotal;
     final (finalOutputs, _) = _buildChangeOutputs(
       currentBuilder,
       finalChange,
       bufferedFallbackFee,
     );
     
     return (finalOutputs, bufferedFallbackFee);
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
  (List<ShelleyMultiAssetTransactionOutput>, Coin) _buildChangeOutputs(
    TransactionBuilder builder,
    Balance remainingBalance,
    Coin fee,
  ) {
    // If no change, return empty outputs and the fee
    if (remainingBalance.isZero || remainingBalance.coin.value <= 0) {
      return ([], fee);
    }
    
    // Make sure we have a change address
    if (builder.changeAddress == null) {
      throw ArgumentError('Change address required for non-zero balance.');
    }
    final normalizedBalance =
        remainingBalance.hasMultiAssets() ? remainingBalance : Balance(coin: remainingBalance.coin);

    final output = PreBabbageTransactionOutput(
      address: builder.changeAddress!,
      amount: normalizedBalance,
    );
    final minAda = TransactionOutputBuilder.minimumAdaForOutput(
      output,
      builder.config.coinsPerUtxoByte,
    );

    // minimum ADA requirements
    if (normalizedBalance.coin >= minAda) {
      return ([output], fee);
    } else {
      return ([], fee);
    }
  }

  /// Retrieves the amount of a specific asset in a balance or zero amount.
  Coin _getAssetAmount(AssetId assetId, Balance balance) {
    final (policy, assetName) = assetId;
    return assetId == CoinSelector.adaAssetId
        ? balance.coin
        : balance.multiAsset?.bundle[policy]?[assetName] ?? const Coin(0);
  }
}
