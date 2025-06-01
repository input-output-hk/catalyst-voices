import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/builders/input_builder.dart';
import 'package:catalyst_cardano_serialization/src/builders/types.dart';
import 'package:catalyst_cardano_serialization/src/utils/cbor.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// A builder which helps to create the [TransactionBody].
///
/// The class collects the [inputs], [outputs], calculates the [fee]
/// and adds a change address if some UTXOs are not fully spent.
///
/// Algorithms inspired by [cardano-multiplatform-lib](https://github.com/dcSpark/cardano-multiplatform-lib/blob/255500b3c683618849fb38107896170ea09c95dc/chain/rust/src/builders/tx_builder.rs#L380) implementation.
final class TransactionBuilder extends Equatable {
  /// Contains the protocol parameters for Cardano blockchain.
  final TransactionBuilderConfig config;

  /// The list of transaction outputs from previous transactions
  /// that will be spent in the next transaction.
  ///
  /// Enough [inputs] must be provided to be greater or equal
  /// the amount of [outputs] + [fee].
  final Set<TransactionUnspentOutput> inputs;

  /// The list of transaction outputs which describes which address
  /// will receive what amount of [Coin].
  final List<ShelleyMultiAssetTransactionOutput> outputs;

  /// The amount of lovelaces that will be charged as the fee
  /// for adding the transaction to the blockchain.
  ///
  /// If left null then it will be auto calculated,
  /// set explicitly with [withFee] to specify a custom fee.
  final Coin? fee;

  /// The absolute slot value before the tx becomes invalid.
  final SlotBigNum? ttl;

  /// The transaction metadata as a list of key-value pairs (a map).
  final AuxiliaryData? auxiliaryData;

  /// Validity interval start as integer.
  final SlotBigNum? validityStart;

  /// Mint as a non-zero uint64 multiasset.
  final MultiAsset? mint;

  /// The transaction metadata as a list of key-value pairs (a map).
  final ScriptData? scriptData;

  /// Collateral inputs as nonempty set.
  final Set<TransactionInput>? collateralInputs;

  /// The list of public key hashes of addresses that are required to sign the
  /// transaction. A nonempty set of addr key hashes.
  final Set<Ed25519PublicKeyHash>? requiredSigners;

  /// Specifies on which network the code will run.
  final NetworkId? networkId;

  /// Collateral return's transaction output.
  final ShelleyMultiAssetTransactionOutput? collateralReturn;

  /// Total collateral as coin (uint64).
  final Coin? totalCollateral;

  /// Reference inputs as nonempty set of transaction inputs.
  final Set<TransactionUnspentOutput>? referenceInputs;

  /// The builder that builds the witness set of the transaction.
  ///
  /// The caller must know in advance how many witnesses there will be to
  /// reserve a correct amount of bytes in the transaction as it influences
  /// the fee.
  final TransactionWitnessSetBuilder witnessBuilder;

  /// The address to receive any remaining change from the transaction.
  ///
  /// Coin selection typically results in a total input value that exceeds the
  /// total output value plus transaction fees. If provided, any remaining
  /// balance is sent to this [changeAddress]. When omitted and a remaining
  /// balance exists, an exception will be thrown, as change must be properly
  /// handled.
  ///
  /// If the leftover amount is below the minimum ADA required for a UTXO, it
  /// will be added to the transaction fee. However, if the leftover balance
  /// includes multi-assets, an exception will occur, as change with
  /// multi-assets cannot be treated as transaction fees.
  ///
  /// - Optional: If omitted, the transaction must have no leftover funds.
  final ShelleyAddress? changeAddress;

  /// The default constructor for [TransactionBuilder].
  const TransactionBuilder({
    required this.config,
    required this.inputs,
    this.outputs = const [],
    this.fee,
    this.ttl,
    this.auxiliaryData,
    this.validityStart,
    this.mint,
    this.scriptData,
    this.collateralInputs,
    this.requiredSigners,
    this.networkId,
    this.collateralReturn,
    this.totalCollateral,
    this.referenceInputs,
    this.witnessBuilder = const TransactionWitnessSetBuilder(vkeys: {}),
    this.changeAddress,
  });

  @override
  List<Object?> get props => [
        config,
        inputs,
        outputs,
        fee,
        ttl,
        auxiliaryData,
        validityStart,
        mint,
        scriptData,
        collateralInputs,
        requiredSigners,
        networkId,
        collateralReturn,
        totalCollateral,
        referenceInputs,
        witnessBuilder,
      ];

  /// Applies coin selection to the transaction and updates its state.
  ///
  /// This method selects inputs and calculates change outputs and fees using
  /// the provided [CoinSelectionStrategy]. It returns a new
  /// [TransactionBuilder] instance with the updated inputs, outputs, and fee.
  ///
  /// Parameters:
  /// - [strategy]: The coin selection strategy to use.
  /// - [minInputs]: The minimum number of inputs to include.
  /// - [maxInputs]: The maximum number of inputs to include.
  ///
  /// Returns:
  /// - A new [TransactionBuilder] instance with the updated state.
  TransactionBuilder applySelection({
    CoinSelectionStrategy strategy = const GreedySelectionStrategy(),
    int minInputs = CoinSelector.minInputs,
    int maxInputs = CoinSelector.maxInputs,
  }) {
    final (selectedInputs, changes, totalFee) = selectInputs(
      strategy: strategy,
      minInputs: minInputs,
      maxInputs: maxInputs,
    );

    return copyWith(
      inputs: selectedInputs,
      outputs: [...outputs, ...changes],
      fee: totalFee,
    );
  }

  /// Returns the body of the new transaction.
  ///
  /// Throws [MaxTxSizeExceededException] if maximum transaction
  /// size is reached.
  TransactionBody buildBody() {
    final (body, fullTxSize) = _buildAndSize();

    _validateOutputsValueAndSize(outputs);
    _validateInputsMatchOutputsAndFee(
      inputs: inputs,
      outputs: outputs,
      fee: body.fee,
    );
    _validateMinTxFee(
      body: body,
      inputs: inputs,
      referenceInputs: referenceInputs,
    );
    _validateMaxTxSize(fullTxSize);

    return body;
  }

  /// Constructs a placeholder [Transaction] using fake witness data.
  ///
  /// This method generates a [Transaction] for estimating the final size by
  /// creating fake witness data of the appropriate length.
  /// It generates a witness set based on the unique input addresses and required signers.
  ///
  /// Parameters:
  /// - [txBody]: The body of the transaction being constructed.
  ///
  /// Returns:
  /// - A proper [Transaction] with a body, placeholder witness set, and
  ///   auxiliary data.
  Transaction buildFakeTransaction(TransactionBody txBody) {
    return Transaction(
      body: txBody,
      witnessSet: generateFakeWitnessSet(inputs, requiredSigners),
      isValid: true,
      auxiliaryData: auxiliaryData,
    );
  }

  /// Creates a copy of this transaction builder with modified fields.
  ///
  /// Only the specified parameters will be updated; all other fields
  /// remain unchanged.
  TransactionBuilder copyWith({
    Set<TransactionUnspentOutput>? inputs,
    List<ShelleyMultiAssetTransactionOutput>? outputs,
    Coin? fee,
    TransactionWitnessSetBuilder? witnessBuilder,
  }) {
    return TransactionBuilder(
      config: config,
      inputs: inputs ?? this.inputs,
      outputs: outputs ?? this.outputs,
      fee: fee ?? this.fee,
      ttl: ttl,
      auxiliaryData: auxiliaryData,
      validityStart: validityStart,
      mint: mint,
      scriptData: scriptData,
      collateralInputs: collateralInputs,
      requiredSigners: requiredSigners,
      networkId: networkId,
      collateralReturn: collateralReturn,
      totalCollateral: totalCollateral,
      referenceInputs: referenceInputs,
      witnessBuilder: witnessBuilder ?? this.witnessBuilder,
      changeAddress: changeAddress,
    );
  }

  /// Returns the size of the full transaction in bytes.
  int fullSize() {
    return _buildAndSize().$2;
  }

  /// Calculates the minimum fee for the transaction.
  ///
  /// This method calculates the minimum fee required for the transaction,
  /// optionally considering the witnesses based on the inputs' addresses.
  ///
  /// Returns:
  /// - A [Coin] representing the minimum fee required for the transaction.
  Coin minFee() {
    final txBody = copyWith(fee: Coin(config.feeAlgo.constant))._buildBody();
    final fullTx = buildFakeTransaction(txBody);

    return config.feeAlgo.minFee(fullTx, {...inputs, ...?referenceInputs});
  }

  /// Selects UTXO inputs for the transaction based on the given strategy.
  ///
  /// This method uses the provided [CoinSelectionStrategy] to select the
  /// optimal set of inputs for the transaction. It also allows specifying the
  /// minimum and maximum number of inputs to be considered during selection.
  ///
  /// Parameters:
  /// - [strategy]: The coin selection strategy to use.
  /// - [minInputs]: The minimum number of inputs to include.
  /// - [maxInputs]: The maximum number of inputs to include.
  ///
  /// Returns:
  /// - A [SelectionResult] containing the selected inputs, change outputs, and
  ///   the total (witnesses included) transaction fee.
  ///
  SelectionResult selectInputs({
    CoinSelectionStrategy strategy = const GreedySelectionStrategy(),
    int minInputs = CoinSelector.minInputs,
    int maxInputs = CoinSelector.maxInputs,
  }) {
    final selector = InputBuilder(
      selectionStrategy: strategy,
    );

    return selector.selectInputs(
      builder: this,
      minInputs: minInputs,
      maxInputs: maxInputs,
    );
  }

  /// Returns a copy of this [TransactionBuilder] with extra [address] used
  /// to spend any remaining change from the transaction, if it is needed.
  ///
  /// Since in a Cardano transaction the input amount must match the output
  /// amount plus fee, the method must ensure that there are no unspent utxos.
  ///
  /// The algorithm first tries to create a [ShelleyMultiAssetTransactionOutput]
  /// which will transfer any remaining [Coin] back to the [address].
  /// The [address] should be the change address of the wallet initiating the
  /// transaction.
  ///
  /// If creating an extra [ShelleyMultiAssetTransactionOutput] is not possible
  /// because i.e. the remaining change is too small to cover for extra fee that
  /// such extra output would generate then the transaction fee is increased to
  ///  burn any remaining change.
  ///
  /// Follows code style of Cardano Multiplatform Lib to make patching easy.
  TransactionBuilder withChangeAddressIfNeeded(ShelleyAddress address) {
    if (this.fee != null) {
      // generating the change output involves changing the fee
      return this;
    }

    final fee = minFee();

    final inputTotal = inputs.map((e) => e.output.amount).reduce((a, b) => a + b);
    final outputTotal = outputs.isNotEmpty
        ? outputs.map((e) => e.amount).reduce((a, b) => a + b)
        : const Balance.zero();
    final outputTotalPlusFee = outputTotal + Balance(coin: fee);

    if (outputTotalPlusFee.coin == inputTotal.coin) {
      return withFee(fee);
    } else if (outputTotalPlusFee.coin > inputTotal.coin) {
      throw InsufficientUtxoBalanceException(
        actualAmount: inputTotal,
        requiredAmount: outputTotalPlusFee,
      );
    } else {
      final changeEstimator = inputTotal - outputTotal;
      if (changeEstimator.hasMultiAssets()) {
        return _withChangeAddressIfNeededWithMultiAssets(
          address: address,
          fee: fee,
          changeEstimator: changeEstimator,
        );
      } else {
        return _withChangeAddressIfNeededWithoutMultiAssets(
          address: address,
          fee: fee,
          changeEstimator: changeEstimator,
        );
      }
    }
  }

  /// Returns a copy of this [TransactionBuilder] with the [fee].
  TransactionBuilder withFee(Coin fee) {
    return copyWith(fee: fee);
  }

  /// Returns a copy of this [TransactionBuilder] with extra [output].
  TransactionBuilder withOutput(ShelleyMultiAssetTransactionOutput output) {
    return copyWith(outputs: [...outputs, output]);
  }

  /// Returns a copy of this [TransactionBuilder] with extra [vkeyWitness].
  TransactionBuilder withWitnessVkey(VkeyWitness vkeyWitness) {
    final builder = witnessBuilder.addVkey(vkeyWitness);
    return copyWith(witnessBuilder: builder);
  }

  /// Removes the last transaction output and inserts a new one with extra [change].
  /// Updates the [fee] to accommodate a possibly larger new transaction output.
  TransactionBuilder _addChangeToLastOutput({
    required Balance change,
  }) {
    final newOutputs = List.of(outputs);
    var changeLeft = change;
    var newFee = fee!;

    // remove old output
    final lastOutput = newOutputs.removeLast();
    final lastOutputFee = TransactionOutputBuilder.feeForOutput(config, lastOutput);
    newFee -= lastOutputFee;
    changeLeft += Balance(coin: lastOutputFee);

    // create new output with remaining change
    final newOutput = lastOutput.copyWith(amount: lastOutput.amount + changeLeft);
    final newOutputFee = TransactionOutputBuilder.feeForOutput(config, newOutput);

    // subtract the fee for the new output from it
    final newOutputMinusFee = newOutput.copyWith(
      amount: newOutput.amount - Balance(coin: newOutputFee),
    );
    newFee += newOutputFee;
    changeLeft -= Balance(coin: newFee);

    // add new output and modify the fee
    return copyWith(outputs: newOutputs).withOutput(newOutputMinusFee).withFee(newFee);
  }

  /// Builds a [TransactionBody] and measures the final transaction size
  /// that will be submitted to the blockchain.
  ///
  /// Knowing the final transaction size is very important as it influences
  /// the [fee] the wallet must pay for the transaction.
  ///
  /// Since the transaction body is signed before all
  (TransactionBody, int) _buildAndSize() {
    final built = _buildBody();

    // we must build a tx with fake data (of correct size)
    // to check the final transaction size
    final fullTx = buildFakeTransaction(built);
    final fullTxSize = cbor.encode(fullTx.toCbor()).length;
    return (fullTx.body, fullTxSize);
  }

  TransactionBody _buildBody() {
    final fee = this.fee;
    if (fee == null) {
      throw const TxFeeNotSpecifiedException();
    }

    return TransactionBody(
      inputs: inputs.map((e) => e.input).toSet(),
      outputs: outputs,
      fee: fee,
      ttl: ttl,
      auxiliaryDataHash:
          auxiliaryData != null ? AuxiliaryDataHash.fromAuxiliaryData(auxiliaryData!) : null,
      validityStart: validityStart,
      mint: mint,
      scriptDataHash: scriptData != null ? ScriptDataHash.fromScriptData(scriptData!) : null,
      collateralInputs: collateralInputs,
      requiredSigners: requiredSigners,
      networkId: networkId,
      collateralReturn: collateralReturn,
      totalCollateral: totalCollateral,
      referenceInputs: referenceInputs?.map((utxo) => utxo.input).toSet(),
    );
  }

  /// Splits the native assets into multiple [MultiAsset]
  /// if they don't fit into one transaction output.
  List<MultiAsset> _packNftsForChange({
    required ShelleyAddress changeAddress,
    required Balance changeEstimator,
  }) {
    final baseMultiAsset = changeEstimator.multiAsset;
    if (baseMultiAsset == null) return [];

    final changeAssets = <MultiAsset>[];
    var baseCoin = Balance(coin: changeEstimator.coin);
    var output = TransactionOutput(address: changeAddress, amount: baseCoin);

    for (final policy in baseMultiAsset.bundle.entries) {
      var oldAmount = output.amount;
      var val = const Balance.zero();
      var nextNft = const MultiAsset(bundle: {});
      var rebuiltAssets = <AssetName, Coin>{};

      for (final asset in policy.value.entries) {
        if (_willAddingAssetMakeOutputOverflow(
          output: output,
          currentAssets: rebuiltAssets,
          assetToAdd: (policy.key, asset.key, asset.value),
        )) {
          // if we got here, this means we will run into a overflow error,
          // so we want to split into multiple outputs, for that we...

          // 1. insert the current assets as they are, as this won't overflow
          nextNft = MultiAsset(
            bundle: {
              ...nextNft.bundle,
              policy.key: rebuiltAssets,
            },
          );

          val = val.copyWith(multiAsset: nextNft);
          output = output.copyWith(amount: output.amount + val);
          changeAssets.add(output.amount.multiAsset!);

          // 2. create a new output with the base coin value as zero
          baseCoin = const Balance.zero();
          output = TransactionOutput(
            address: changeAddress,
            amount: baseCoin,
          );

          // 3. continue building the new output from the asset we stopped
          oldAmount = output.amount;
          val = const Balance.zero();
          nextNft = const MultiAsset(bundle: {});
          rebuiltAssets = {};
        }

        rebuiltAssets[asset.key] = asset.value;
      }

      nextNft = MultiAsset(
        bundle: {
          ...nextNft.bundle,
          policy.key: rebuiltAssets,
        },
      );
      val = val.copyWith(multiAsset: nextNft);
      output = output.copyWith(amount: output.amount + val);

      final outputCopy = output.copyWith(amount: val);
      final minAda = TransactionOutputBuilder.minimumAdaForOutput(
        outputCopy,
        config.coinsPerUtxoByte,
      );

      final amountCopy = output.amount.copyWith(coin: minAda);
      final bytes = cbor.encode(amountCopy.toCbor());
      if (bytes.length > config.maxValueSize) {
        output = output.copyWith(amount: oldAmount);
        break;
      }
    }

    changeAssets.add(output.amount.multiAsset!);
    return changeAssets;
  }

  void _validateInputsMatchOutputsAndFee({
    required Set<TransactionUnspentOutput> inputs,
    required List<ShelleyMultiAssetTransactionOutput> outputs,
    required Coin fee,
  }) {
    final inputsTotal =
        inputs.map((e) => e.output.amount).fold(const Balance(coin: Coin(0)), (a, b) => a + b);
    final outputsTotal =
        outputs.map((e) => e.amount).fold(const Balance(coin: Coin(0)), (a, b) => a + b);

    if (inputsTotal != outputsTotal + Balance(coin: fee)) {
      throw TxBalanceMismatchException(
        inputs: inputsTotal,
        outputs: outputsTotal,
        fee: fee,
      );
    }
  }

  void _validateMaxTxSize(int fullTxSize) {
    if (fullTxSize > config.maxTxSize) {
      throw MaxTxSizeExceededException(
        maxTxSize: config.maxTxSize,
        actualTxSize: fullTxSize,
      );
    }
  }

  void _validateMinTxFee({
    required TransactionBody body,
    required Set<TransactionUnspentOutput> inputs,
    required Set<TransactionUnspentOutput>? referenceInputs,
  }) {
    final transaction = buildFakeTransaction(body);
    final minFee = config.feeAlgo.minFee(transaction, {
      ...inputs,
      ...?referenceInputs,
    });

    if (body.fee < minFee) {
      throw TxFeeTooSmallException(
        actualFee: body.fee,
        minFee: minFee,
      );
    }
  }

  void _validateOutputsValueAndSize(List<ShelleyMultiAssetTransactionOutput> outputs) {
    for (final output in outputs) {
      if (!TransactionOutputBuilder.isOutputSizeValid(
        output,
        config.maxValueSize,
      )) {
        final valueSize = cbor.encode(output.amount.toCbor()).length;

        throw TxValueSizeExceededException(
          actualValueSize: valueSize,
          maxValueSize: config.maxValueSize,
        );
      }

      final minAdaPerUtxoEntry = TransactionOutputBuilder.minimumAdaForOutput(
        output,
        config.coinsPerUtxoByte,
      );

      if (output.amount.coin < minAdaPerUtxoEntry) {
        throw TxValueBelowMinUtxoValueException(
          actualAmount: output.amount.coin,
          requiredAmount: minAdaPerUtxoEntry,
        );
      }
    }
  }

  /// Returns true if adding additional [assetToAdd] to [currentAssets]
  /// will trigger size overflow in [output].
  ///
  /// The function is used to split native assets into
  /// multiple outputs if they don't fit in one output.
  bool _willAddingAssetMakeOutputOverflow({
    required ShelleyMultiAssetTransactionOutput output,
    required Map<AssetName, Coin> currentAssets,
    required (PolicyId, AssetName, Coin) assetToAdd,
  }) {
    final (policy, assetName, value) = assetToAdd;

    final valueWithExtraMultiAssets = Balance(
      coin: const Coin(0),
      multiAsset: MultiAsset(
        bundle: {
          policy: {
            ...currentAssets,
            assetName: value,
          },
        },
      ),
    );

    final outputWithExtraMultiAssets = TransactionOutput(
      address: output.address,
      amount: output.amount + valueWithExtraMultiAssets,
    );

    final minAdaForExtraOutput = TransactionOutputBuilder.minimumAdaForOutput(
      outputWithExtraMultiAssets,
      config.coinsPerUtxoByte,
    );

    final valueWithExtraAmountAndMultiAssets = Balance(
      coin: minAdaForExtraOutput,
      multiAsset: outputWithExtraMultiAssets.amount.multiAsset,
    );

    final bytes = cbor.encode(valueWithExtraAmountAndMultiAssets.toCbor());
    return bytes.length > config.maxValueSize;
  }

  TransactionBuilder _withChangeAddressIfNeededWithMultiAssets({
    required ShelleyAddress address,
    required Coin fee,
    required Balance changeEstimator,
  }) {
    var builder = this;
    var changeLeft = changeEstimator;
    var newFee = fee;

    while (changeLeft.hasMultiAssets()) {
      final nftChanges = _packNftsForChange(
        changeAddress: address,
        changeEstimator: changeLeft,
      );

      for (final nftChange in nftChanges) {
        final changeOutput = TransactionOutputBuilder.withAssetAndMinRequiredCoin(
          address: address,
          multiAsset: nftChange,
          coinsPerUtxoByte: config.coinsPerUtxoByte,
        );

        final feeForChange = TransactionOutputBuilder.feeForOutput(
          config,
          changeOutput,
        );

        newFee += feeForChange;

        final changeAdaPlusFee = changeOutput.amount.coin + newFee;
        if (changeLeft.coin < changeAdaPlusFee) {
          throw const InsufficientAdaForAssetsException();
        }

        changeLeft -= changeOutput.amount;
        builder = builder.withOutput(changeOutput);
      }
    }

    changeLeft -= Balance(coin: newFee);
    builder = builder.withFee(newFee);

    if (!changeLeft.isZero) {
      // No new transaction output needed at this stage,
      // since the method is only called when multi assets exist
      // then at least one transaction output for them is created
      // which we can reuse here for the remaining change.
      builder = builder._addChangeToLastOutput(change: changeLeft);
    }

    return builder;
  }

  TransactionBuilder _withChangeAddressIfNeededWithoutMultiAssets({
    required ShelleyAddress address,
    required Coin fee,
    required Balance changeEstimator,
  }) {
    final changeOutput = PreBabbageTransactionOutput(
      address: address,
      amount: changeEstimator,
    );

    final minAda = TransactionOutputBuilder.minimumAdaForOutput(
      changeOutput,
      config.coinsPerUtxoByte,
    );

    switch (changeEstimator.coin >= minAda) {
      case false:
        // burn remaining change as fee
        return withFee(changeEstimator.coin);
      case true:
        final feeForChange = TransactionOutputBuilder.feeForOutput(config, changeOutput);
        final newFee = fee + feeForChange;

        switch (changeEstimator.coin >= minAda) {
          case false:
            // burn remaining change as fee
            return withFee(changeEstimator.coin);
          case true:
            return withFee(newFee).withOutput(
              PreBabbageTransactionOutput(
                address: address,
                amount: changeEstimator - Balance(coin: newFee),
              ),
            );
        }
    }
  }

  /// Generates a fake `TransactionWitnessSet` for accurate transaction fee
  /// calculation, ensuring the correct number of VKey witnesses based on
  /// the builder's unique input addresses and required signers.
  static TransactionWitnessSet generateFakeWitnessSet(
    Set<TransactionUnspentOutput> inputs,
    Set<Ed25519PublicKeyHash>? requiredSigners,
  ) {
    final uniqueAddresses = inputs.map((input) => input.output.address.publicKeyHash).toSet()
      ..addAll(requiredSigners ?? {});

    return TransactionWitnessSet(
      vkeyWitnesses: {
        for (var i = 0; i < uniqueAddresses.length; i++) VkeyWitness.seeded(i),
      },
    );
  }
}

/// A configuration for the [TransactionBuilder] which holds
/// protocol parameters and other constants.
final class TransactionBuilderConfig extends Equatable {
  /// The protocol parameter which describes the transaction fee algorithm.
  final TieredFee feeAlgo;

  /// The protocol parameter which limits the maximum transaction size in bytes.
  final int maxTxSize;

  /// The protocol parameter which limits the maximum transaction output value
  /// size in bytes.
  final int maxValueSize;

  /// The protocol parameter that establishes the minimum amount of [Coin]
  /// required per UTXO entry.
  ///
  /// This prevents storing too many tiny UTXOs on the network.
  final Coin coinsPerUtxoByte;

  /// The coin selection strategy for automatic input selection for the
  /// transaction.
  ///
  /// Default: It uses [GreedySelectionStrategy].
  final CoinSelectionStrategy selectionStrategy;

  /// The default constructor for [TransactionBuilderConfig].
  const TransactionBuilderConfig({
    required this.feeAlgo,
    required this.maxTxSize,
    required this.maxValueSize,
    required this.coinsPerUtxoByte,
    this.selectionStrategy = const GreedySelectionStrategy(),
  });

  @override
  List<Object?> get props => [
        feeAlgo,
        maxTxSize,
        maxValueSize,
        coinsPerUtxoByte,
      ];

  /// Creates copy of this config with updated parameters.
  TransactionBuilderConfig copyWith({
    TieredFee? feeAlgo,
    int? maxTxSize,
    int? maxValueSize,
    Coin? coinsPerUtxoByte,
    CoinSelectionStrategy? selectionStrategy,
  }) {
    return TransactionBuilderConfig(
      feeAlgo: feeAlgo ?? this.feeAlgo,
      maxTxSize: maxTxSize ?? this.maxTxSize,
      maxValueSize: maxValueSize ?? this.maxValueSize,
      coinsPerUtxoByte: coinsPerUtxoByte ?? this.coinsPerUtxoByte,
      selectionStrategy: selectionStrategy ?? this.selectionStrategy,
    );
  }
}

/// Builder and utils around [TransactionOutput].
final class TransactionOutputBuilder {
  /// Constant from figure 5 in Babbage spec meant to represent
  /// the size of the input in a UTXO.
  static const int constantOverhead = 160;

  /// Prevents creating instances of [TransactionOutputBuilder].
  const TransactionOutputBuilder._();

  /// Calculates the transaction fee for the given [output].
  ///
  /// The output fee is computed by multiplying the encoded output size
  /// (in bytes) by the fee coefficient from the builder's configuration.
  ///
  /// The encoding switches from a definite-length array (98FE) at length 254
  /// to an indefinite-length array (9F ... FF), making this calculation
  /// sufficient.
  static Coin feeForOutput(
    TransactionBuilderConfig config,
    ShelleyMultiAssetTransactionOutput output,
  ) =>
      Coin(
        cbor.encode(output.toCbor()).length * config.feeAlgo.coefficient,
      );

  /// Validates the size of a transaction output against protocol parameters.
  ///
  /// A transaction output is valid if:
  /// - The total value size (including lovelace and multi-assets) does not
  ///   exceed `maxValueSize`.
  ///
  /// These constraints ensure consistent and predictable transaction
  /// processing.
  static bool isOutputSizeValid(
    ShelleyMultiAssetTransactionOutput output,
    int maxValueSize,
  ) =>
      cbor.encode(output.amount.toCbor()).length <= maxValueSize;

  /// Validates the value of a transaction output.
  ///
  /// A transaction output value is valid if:
  /// - **Coin (Lovelace)**:
  ///   - The value is an unsigned integer within the range [0, 2^64 - 1].
  ///   - Although Dart's maximum safe integer for web applications is 2^53 - 1,
  ///     this range is sufficient for Cardano's lovelace maximum value
  ///     `(4.5 × 10^15)`, which fits well within this range above.
  /// - **Multi-asset amount**:
  ///   - The value is a positive uint64 (1 to 2^64 - 1).
  ///   - Since this range exceeds Dart's `int` limits on the web, `BigInt`
  ///     should be used.
  // TODO(ilap): Consider using BigInt for multiasset's values.
  static bool isOutputValueValid(TransactionOutput output) {
    final balance = output.amount;
    final coin = balance.coin;
    final (lowerBound, upperBound) = CoinSelector.coinValueRange;

    final coinValid = coin >= lowerBound && coin <= upperBound;

    /// It's evaluated using short-circuit logic, so no separation is needed.
    if (!coinValid || !output.amount.hasMultiAssets()) return coinValid;

    final (assetLowerBound, assetUpperBound) = CoinSelector.assetValueRange;

    for (final entry in balance.multiAsset!.bundle.entries) {
      final assets = entry.value;

      for (final assetEntry in assets.entries) {
        final coin = assetEntry.value;
        final valueValid = coin >= assetLowerBound && coin <= assetUpperBound;
        if (!valueValid) return false;
      }
    }

    /// No failures till now, so the output has valid values.
    return true;
  }

  /// Calculates the minimum amount of extra [Coin] for UTXO input.
  ///
  /// Adding extra output raises the transaction size which raises the fee,
  /// raising the fee can increase the transaction size as more bytes might
  /// need to be allocated to cover the higher fee.
  ///
  /// The algorithm considers all of above cases.
  static Coin minimumAdaForOutput(
    ShelleyMultiAssetTransactionOutput output,
    Coin coinsPerUtxoByte,
  ) {
    final outputSize = cbor.encode(output.toCbor()).length;

    // how many bytes the coin part of the value will take,
    // can vary based on encoding used
    final oldCoinSize = 1 + CborSize.ofInt(output.amount.coin.value).bytes;

    // most recent estimate of the size in bytes to include
    // the minimum ada value
    var latestCoinSize = oldCoinSize;

    // we calculate min ada in a loop because every time we increase
    // the min ada, it may increase the cbor size in bytes
    while (true) {
      final sizeDiff = latestCoinSize - oldCoinSize;
      final tentativeMinAda = Coin(outputSize + constantOverhead + sizeDiff) * coinsPerUtxoByte;

      final newCoinSize = 1 + CborSize.ofInt(tentativeMinAda.value).bytes;
      final isDone = latestCoinSize == newCoinSize;
      latestCoinSize = newCoinSize;

      if (isDone) {
        break;
      }
    }

    // how many bytes the size changed from including the minimum ada value
    final sizeChange = latestCoinSize - oldCoinSize;
    final adjustedMinAda = Coin(outputSize + constantOverhead + sizeChange) * coinsPerUtxoByte;
    return adjustedMinAda;
  }

  /// Creates a new [TransactionOutput] that transfers
  /// the [multiAsset] to the address.
  ///
  /// Adds a minimum amount of [Coin] to the transaction to pass
  /// the [minimumAdaForOutput] validation.
  static ShelleyMultiAssetTransactionOutput withAssetAndMinRequiredCoin({
    required ShelleyAddress address,
    required MultiAsset multiAsset,
    required Coin coinsPerUtxoByte,
  }) {
    final minOutput = PreBabbageTransactionOutput(
      address: address,
      amount: const Balance.zero(),
    );

    final minPossibleCoin = minimumAdaForOutput(minOutput, coinsPerUtxoByte);

    final checkOutput = minOutput.copyWith(
      amount: Balance(
        coin: minPossibleCoin,
        multiAsset: multiAsset,
      ),
    );

    final requiredCoin = minimumAdaForOutput(checkOutput, coinsPerUtxoByte);
    return PreBabbageTransactionOutput(
      address: address,
      amount: Balance(coin: requiredCoin, multiAsset: multiAsset),
    );
  }
}
