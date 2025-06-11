import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/builders/types.dart';

/// A builder that constructs the minimal required transaction inputs from a set
/// of inputs using a coin selection algorithm.
///
/// The `InputBuilder` processes a set of transaction inputs and applies
/// a coin selection algorithm to determine the minimal required inputs needed
/// to satisfy the transaction outputs and fees. It produces a new selection
/// result containing:
///
/// - The selected inputs.
/// - Change outputs, if applicable.
/// - The calculated transaction fee.
final class InputBuilder implements CoinSelector {
  /// Strategy used to prioritize the available UTxOs.
  final CoinSelectionStrategy selectionStrategy;

  /// Defines a strategy applied to remaining Ada when planning change outputs.
  final ChangeOutputAdaStrategy changeOutputStrategy;

  /// Creates an [InputBuilder] with the given [selectionStrategy].
  const InputBuilder({
    required this.selectionStrategy,
    required this.changeOutputStrategy,
  });

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

    // Attempt to make input selection without burning any Ada.
    final resultWithoutBurning = _selectInputs(
      builder: builder,
      targetTotal: targetTotal,
      minInputs: minInputs,
      maxInputs: maxInputs,
      canBurnChangeAsFee: false,
    );
    
    if (resultWithoutBurning != null) {
      return resultWithoutBurning;
    }

    // If burning Ada is allowed attempt to make a selection that burns remaining Ada.
    if (changeOutputStrategy == ChangeOutputAdaStrategy.burn) {
      final resultWithBurning = _selectInputs(
        builder: builder,
        targetTotal: targetTotal,
        minInputs: minInputs,
        maxInputs: maxInputs,
        canBurnChangeAsFee: true,
      );

      if (resultWithBurning != null) {
        return resultWithBurning;
      }
    }

    // Throw an exception if the selection process fails to meet the
    // requirements.
    throw InsufficientUtxoBalanceException(
      actualAmount: inputTotal,
      requiredAmount: targetTotal,
    );
  }

  SelectionResult? _selectInputs({
    required TransactionBuilder builder,
    required Balance targetTotal,
    required int minInputs,
    required int maxInputs,
    required bool canBurnChangeAsFee,
  }) {
    final availableInputs = builder.inputs.toSet();

    // Group UTXOs by asset ID for coin selection.
    final assetGroups = buildAssetGroups(targetTotal, availableInputs);

    // Apply the coin selection strategy to prioritize UTXOs within each group.
    selectionStrategy.apply(assetGroups);

    final selector = _InputSelector(
      builder: builder,
      minInputs: minInputs,
      maxInputs: maxInputs,
      availableInputs: availableInputs,
      targetTotal: targetTotal,
      assetGroups: assetGroups,
      canBurnChangeAsFee: canBurnChangeAsFee,
    );

    return selector.selectInputs();
  }
}

class _InputSelector {
  final TransactionBuilder builder;
  final int minInputs;
  final int maxInputs;
  final Set<TransactionUnspentOutput> availableInputs;
  final Balance targetTotal;
  final AssetsGroup assetGroups;
  final bool canBurnChangeAsFee;

  final selectedInputs = <TransactionUnspentOutput>{};
  Balance selectedTotal = const Balance.zero();

  _InputSelector({
    required this.builder,
    required this.minInputs,
    required this.maxInputs,
    required this.availableInputs,
    required this.targetTotal,
    required this.assetGroups,
    required this.canBurnChangeAsFee,
  });

  SelectionResult? selectInputs() {
    final postOutputsResult = _selectInputsToSatisfyOutputs();
    if (postOutputsResult != null) {
      return postOutputsResult;
    }

    final postChangeOutputsResult = _selectInputsToSatisfyChangeOutputsAndFee();
    if (postChangeOutputsResult != null) {
      return postChangeOutputsResult;
    }

    final result = _getSelectionResultSatisfyingOutputsAndFee();
    if (result != null) {
      return result;
    }

    return null;
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
  (List<ShelleyMultiAssetTransactionOutput>, Coin)? _buildChangeOutputs(
    TransactionBuilder builder,
    Balance remainingBalance,
  ) {
    try {
      if (remainingBalance.isZero) return ([], const Coin(0));

      final builderWithChangeOutputs = builder.withChangeIfNeeded(burnAsFee: canBurnChangeAsFee);
      final deltaOutputs = List.of(builderWithChangeOutputs.outputs)..removeAll(builder.outputs);
      final deltaFee = builderWithChangeOutputs.fee! - builder.minFee();

      return (deltaOutputs, deltaFee);
    } on InsufficientUtxoBalanceException {
      return null;
    } on InsufficientAdaForAssetsException {
      return null;
    } on InsufficientAdaForChangeOutputException {
      return null;
    }
  }

  /// Retrieves the amount of a specific asset in a balance or zero amount.
  Coin _getAssetAmount(AssetId assetId, Balance balance) {
    final (policy, assetName) = assetId;
    return assetId == CoinSelector.adaAssetId
        ? balance.coin
        : balance.multiAsset?.bundle[policy]?[assetName] ?? const Coin(0);
  }

  /// Retrieves the change outputs and the total transaction fee, if applicable.
  ///
  /// This method calculates whether there is sufficient balance to cover the
  /// required amount and associated fees, then retrieves the pre-constructed
  /// change outputs and the total transaction fee.
  ///
  /// - Parameters:
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
  (List<ShelleyMultiAssetTransactionOutput>, Coin)? _getChangeAndFee(
    TransactionBuilder builder,
    Set<TransactionUnspentOutput> selectedInputs,
    Balance selectedTotal,
    Balance targetTotal,
  ) {
    final builderWithInputs = builder.copyWith(inputs: selectedInputs);
    final minFee = builderWithInputs.minFee();
    final minimumRequired = targetTotal + Balance(coin: minFee);

    if (selectedTotal.lessThan(minimumRequired)) return null;

    // Calculate the change to be returned, as the selected total is guaranteed
    // to be larger.
    final changeTotal = selectedTotal - minimumRequired;

    final record = _buildChangeOutputs(builderWithInputs, changeTotal);
    if (record == null) {
      return null;
    }

    final (changeOutputs, changeFee) = record;
    final requiredFee = minFee + changeFee;
    if (selectedTotal.lessThan(targetTotal + Balance(coin: requiredFee))) {
      return null;
    }

    return (changeOutputs, requiredFee);
  }

  /// Tries to build a valid [SelectionResult] from the current input selection,
  /// ensuring output and fee requirements are met.
  ///
  /// Returns null if the requirements are not met.
  SelectionResult? _getSelectionResultSatisfyingOutputsAndFee() {
    if (selectedInputs.length < minInputs || selectedInputs.length > maxInputs) {
      return null;
    }

    // Return the selection result if change and fees are successfully calculated.
    final changeAndFee = _getChangeAndFee(builder, selectedInputs, selectedTotal, targetTotal);
    if (changeAndFee != null) {
      final (changeOutputs, totalFee) = changeAndFee;
      return (selectedInputs, changeOutputs, totalFee);
    }

    return null;
  }

  /// Attempts to select just enough Ada inputs (UTXOs) to satisfy both the required
  /// change outputs and the transaction fee.
  ///
  /// This method iterates through available Ada UTXOs and selectively includes them
  /// into the input set until:
  ///
  /// - The selected inputs can fully satisfy the outputs, including generating any
  ///   required change outputs.
  /// - The transaction fee requirements are met.
  SelectionResult? _selectInputsToSatisfyChangeOutputsAndFee() {
    final adaAssetGroup =
        assetGroups.where((e) => e.key == CoinSelector.adaAssetId).firstOrNull?.value ?? [];

    while (availableInputs.isNotEmpty && adaAssetGroup.isNotEmpty) {
      // Select the first available UTXO from the list of asset UTXOs.
      final utxo = adaAssetGroup.removeAt(0);
      final utxoAvailable = _selectUtxoIfStillAvailable(utxo);
      if (!utxoAvailable) continue;

      final result = _getSelectionResultSatisfyingOutputsAndFee();
      if (result != null) {
        return result;
      }
    }

    return _getSelectionResultSatisfyingOutputsAndFee();
  }

  /// Selects the minimum number of UTxOs required to satisfy the [targetTotal] amounts
  /// for each asset group, including Ada and native tokens.
  ///
  /// This method:
  /// - Iterates over each asset group needed in the transaction (e.g., Ada, native tokens).
  /// - Selects UTxOs for each asset until the selected input total meets or exceeds
  ///   the required output amount for that asset.
  SelectionResult? _selectInputsToSatisfyOutputs() {
    // Iterate through each asset group (native tokens + ADA as the last group).
    for (final entry in assetGroups) {
      final assetId = entry.key;
      final assetUtxos = entry.value;

      if (_getAssetAmount(assetId, selectedTotal) >= _getAssetAmount(assetId, targetTotal)) {
        // Already selected enough utxos for given asset.
        continue;
      }

      while (assetUtxos.isNotEmpty) {
        // Check if there are no more available inputs or if the maximum number
        // of inputs has been exceeded.
        if (availableInputs.isEmpty) {
          throw InsufficientUtxoBalanceException(
            actualAmount: selectedTotal,
            requiredAmount: targetTotal,
          );
        }

        // Select the first available UTXO from the list of asset UTXOs.
        final utxo = assetUtxos.removeAt(0);
        final utxoAvailable = _selectUtxoIfStillAvailable(utxo);
        if (!utxoAvailable) continue;

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

        final result = _getSelectionResultSatisfyingOutputsAndFee();
        if (result != null) {
          return result;
        }
      }
    }

    return _getSelectionResultSatisfyingOutputsAndFee();
  }

  bool _selectUtxoIfStillAvailable(TransactionUnspentOutput utxo) {
    if (selectedInputs.length >= maxInputs) {
      throw InsufficientUtxoBalanceException(
        actualAmount: selectedTotal,
        requiredAmount: targetTotal,
      );
    } else if (!availableInputs.remove(utxo)) {
      return false;
    } else {
      selectedInputs.add(utxo);
      selectedTotal += utxo.output.amount;
      return true;
    }
  }
}

extension<T> on List<T> {
  void removeAll(List<T> elements) {
    for (final element in elements) {
      remove(element);
    }
  }
}
