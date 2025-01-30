import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/builders/input_builder.dart';
import 'package:catalyst_cardano_serialization/src/builders/strategies/selection_strategies.dart';
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
  final List<TransactionOutput> outputs;

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
    this.witnessBuilder = const TransactionWitnessSetBuilder(
      vkeys: {},
      vkeysCount: 1,
    ),
    this.changeAddress,
  });

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

    final inputTotal =
        inputs.map((e) => e.output.amount).reduce((a, b) => a + b);
    final outputTotal = outputs.isNotEmpty
        ? outputs.map((e) => e.amount).reduce((a, b) => a + b)
        : const Balance.zero();
    final outputTotalPlusFee = outputTotal + Balance(coin: fee);

    if (outputTotalPlusFee.coin == inputTotal.coin) {
      // ignore: avoid_returning_this
      return this;
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
  ///
  /// The [output] must reach a minimum [Coin] value as calculated
  /// by [TransactionOutputBuilder.minimumAdaForOutput],
  /// otherwise [TxValueBelowMinUtxoValueException] is thrown.
  TransactionBuilder withOutput(TransactionOutput output) {
    final valueSize = cbor.encode(output.amount.toCbor()).length;

    if (!TransactionOutputBuilder.isOutputSizeValid(
      output,
      config.maxValueSize,
    )) {
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

    return copyWith(outputs: [...outputs, output]);
  }

  /// Returns a copy of this [TransactionBuilder] with extra [vkeyWitness].
  TransactionBuilder withWitnessVkey(VkeyWitness vkeyWitness) {
    final builder = witnessBuilder.addVkey(vkeyWitness);
    return copyWith(witnessBuilder: builder);
  }

  /// Builds a [TransactionBody] and measures the final transaction size
  /// that will be submitted to the blockchain.
  ///
  /// Knowing the final transaction size is very important as it influences
  /// the [fee] the wallet must pay for the transaction.
  ///
  /// Since the transaction body is signed before all
  (TransactionBody, int) buildAndSize() {
    final built = _buildBody();

    // we must build a tx with fake data (of correct size)
    // to check the final transaction size
    final fullTx = buildFakeTransaction(built);
    final fullTxSize = cbor.encode(fullTx.toCbor()).length;
    return (fullTx.body, fullTxSize);
  }

  /// Returns the body of the new transaction.
  ///
  /// Throws [MaxTxSizeExceededException] if maximum transaction
  /// size is reached.
  TransactionBody buildBody() {
    final (body, fullTxSize) = buildAndSize();
    if (fullTxSize > config.maxTxSize) {
      throw MaxTxSizeExceededException(
        maxTxSize: config.maxTxSize,
        actualTxSize: fullTxSize,
      );
    }

    return body;
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

  /// Constructs a placeholder [Transaction] using fake witness data.
  ///
  /// This method generates a [Transaction] for estimating the final size by
  /// creating fake witness data of the appropriate length. If [useWitnesses]
  /// is set to `true`, it generates a witness set based on the unique input
  /// addresses. Otherwise, it uses the existing `buildFake` method for
  /// backward compatibility.
  ///
  /// Parameters:
  /// - [txBody]: The body of the transaction being constructed.
  /// - [useWitnesses]: If `true`, generates a witness set based on the inputs.
  ///   Defaults to `false` for backward compatibility.
  ///
  /// Returns:
  /// - A proper [Transaction] with a body, placeholder witness set, and
  ///   auxiliary data.
  Transaction buildFakeTransaction(
    TransactionBody txBody, {
    bool useWitnesses = false,
  }) {
    return Transaction(
      body: txBody,
      // TODO(ilap): The buildFake should be refactored instead.
      witnessSet: useWitnesses
          ? generateFakeWitnessSet(inputs)
          : witnessBuilder.buildFake(),
      isValid: true,
      auxiliaryData: auxiliaryData,
    );
  }

  /// Generates a fake `TransactionWitnessSet` for accurate transaction fee
  /// calculation, ensuring the correct number of VKey witnesses based on
  /// the builder's unique input addresses.
  static TransactionWitnessSet generateFakeWitnessSet(
    Set<TransactionUnspentOutput> inputs,
  ) {
    final uniqueAddresses =
        inputs.map((input) => input.output.address.publicKeyHash).toSet();

    return TransactionWitnessSet(
      vkeyWitnesses: {
        for (var i = 0; i < uniqueAddresses.length; i++) VkeyWitness.seeded(i),
      },
    );
  }

  /// Returns the size of the full transaction in bytes.
  int fullSize() {
    return buildAndSize().$2;
  }

  /// Calculates the minimum fee for the transaction.
  ///
  /// This method calculates the minimum fee required for the transaction,
  /// optionally considering the witnesses based on the inputs' addresses.
  ///
  /// - [useWitnesses]: If `true`, the fee calculation will include witnesses
  ///   based on the inputs' addresses, making the fee more accurate by using
  ///   the proper number of witnesses.
  ///
  /// Returns:
  /// - A [Coin] representing the minimum fee required for the transaction.
  Coin minFee({bool useWitnesses = false}) {
    final txBody = copyWith(fee: Coin(config.feeAlgo.constant)).buildBody();
    final fullTx = buildFakeTransaction(txBody, useWitnesses: useWitnesses);

    return config.feeAlgo.minFee(fullTx, {...inputs, ...?referenceInputs});
  }

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
        final changeOutput =
            TransactionOutputBuilder.withAssetAndMinRequiredCoin(
          address: address,
          multiAsset: nftChange,
          coinsPerUtxoByte: config.coinsPerUtxoByte,
        );

        final feeForChange = TransactionOutputBuilder.feeForOutput(
          config,
          changeOutput,
          numOutputs: outputs.length,
        );

        newFee = newFee + feeForChange;

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
      final outputs = List.of(builder.outputs);
      final lastOutput = outputs.removeLast();
      final newOutput =
          lastOutput.copyWith(amount: lastOutput.amount + changeLeft);
      outputs.add(newOutput);
      builder = builder.copyWith(outputs: outputs);
    }

    return builder;
  }

  TransactionBuilder _withChangeAddressIfNeededWithoutMultiAssets({
    required ShelleyAddress address,
    required Coin fee,
    required Balance changeEstimator,
  }) {
    final minAda = TransactionOutputBuilder.minimumAdaForOutput(
      TransactionOutput(
        address: address,
        amount: changeEstimator,
      ),
      config.coinsPerUtxoByte,
    );

    switch (changeEstimator.coin >= minAda) {
      case false:
        // burn remaining change as fee
        return withFee(changeEstimator.coin);
      case true:
        final feeForChange = TransactionOutputBuilder.feeForOutput(
          config,
          TransactionOutput(
            address: address,
            amount: changeEstimator,
          ),
          numOutputs: outputs.length,
        );

        final newFee = fee + feeForChange;

        switch (changeEstimator.coin >= minAda) {
          case false:
            // burn remaining change as fee
            return withFee(changeEstimator.coin);
          case true:
            return withFee(newFee).withOutput(
              TransactionOutput(
                address: address,
                amount: changeEstimator - Balance(coin: newFee),
              ),
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

  TransactionBody _buildBody() {
    final fee = this.fee;
    if (fee == null) {
      throw const TxFeeNotSpecifiedException();
    }

    return TransactionBody(
      inputs: Set.of(inputs.map((e) => e.input)),
      outputs: List.of(outputs),
      fee: fee,
      ttl: ttl,
      auxiliaryDataHash: auxiliaryData != null
          ? AuxiliaryDataHash.fromAuxiliaryData(auxiliaryData!)
          : null,
      validityStart: validityStart,
      mint: mint,
      scriptDataHash: scriptData != null
          ? ScriptDataHash.fromScriptData(scriptData!)
          : null,
      collateralInputs: collateralInputs,
      requiredSigners: requiredSigners,
      networkId: networkId,
      collateralReturn: collateralReturn,
      totalCollateral: totalCollateral,
      referenceInputs: referenceInputs?.map((utxo) => utxo.input).toSet(),
    );
  }

  /// CopyWidth
  TransactionBuilder copyWith({
    Set<TransactionUnspentOutput>? inputs,
    List<TransactionOutput>? outputs,
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
  List<Object?> get props =>
      [feeAlgo, maxTxSize, maxValueSize, coinsPerUtxoByte];
}

/// Builder and utils around [TransactionOutput].
final class TransactionOutputBuilder {
  /// Constant from figure 5 in Babbage spec meant to represent
  /// the size of the input in a UTXO.
  static const int constantOverhead = 160;

  /// Prevents creating instances of [TransactionOutputBuilder].
  const TransactionOutputBuilder._();

  /// Creates a new [TransactionOutput] that transfers
  /// the [multiAsset] to the address.
  ///
  /// Adds a minimum amount of [Coin] to the transaction to pass
  /// the [minimumAdaForOutput] validation.
  static TransactionOutput withAssetAndMinRequiredCoin({
    required ShelleyAddress address,
    required MultiAsset multiAsset,
    required Coin coinsPerUtxoByte,
  }) {
    final minOutput = TransactionOutput(
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
    return TransactionOutput(
      address: address,
      amount: Balance(coin: requiredCoin, multiAsset: multiAsset),
    );
  }

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
    ShelleyMultiAssetTransactionOutput output, {
    required int numOutputs,
  }) =>
      Coin(
        cbor.encode(output.toCbor()).length * config.feeAlgo.coefficient,
      );

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
      final tentativeMinAda =
          Coin(outputSize + constantOverhead + sizeDiff) * coinsPerUtxoByte;

      final newCoinSize = 1 + CborSize.ofInt(tentativeMinAda.value).bytes;
      final isDone = latestCoinSize == newCoinSize;
      latestCoinSize = newCoinSize;

      if (isDone) {
        break;
      }
    }

    // how many bytes the size changed from including the minimum ada value
    final sizeChange = latestCoinSize - oldCoinSize;

    final adjustedMinAda =
        Coin(outputSize + constantOverhead + sizeChange) * coinsPerUtxoByte;

    return adjustedMinAda;
  }

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

  /// Validates the size of a transaction output against protocol parameters.
  ///
  /// A transaction output is valid if:
  /// - The total value size (including lovelace and multi-assets) does not
  ///   exceed `maxValueSize`.
  ///
  /// These constraints ensure consistent and predictable transaction
  /// processing.
  static bool isOutputSizeValid(
    TransactionOutput output,
    int maxValueSize,
  ) =>
      cbor.encode(output.amount.toCbor()).length <= maxValueSize;
}
