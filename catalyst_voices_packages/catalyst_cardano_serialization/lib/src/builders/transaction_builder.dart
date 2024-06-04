import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/builders/witness_builder.dart';
import 'package:catalyst_cardano_serialization/src/exceptions.dart';
import 'package:catalyst_cardano_serialization/src/fees.dart';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/utils/cbor.dart';
import 'package:catalyst_cardano_serialization/src/utils/numbers.dart';
import 'package:catalyst_cardano_serialization/src/witness.dart';
import 'package:cbor/cbor.dart';

/// A builder which helps to create the [TransactionBody].
///
/// The class collects the [inputs], [outputs], calculates the [fee]
/// and adds a change address if some UTXOs are not fully spent.
///
/// Algorithms inspired by [cardano-multiplatform-lib](https://github.com/dcSpark/cardano-multiplatform-lib/blob/255500b3c683618849fb38107896170ea09c95dc/chain/rust/src/builders/tx_builder.rs#L380) implementation.
class TransactionBuilder {
  /// Contains the protocol parameters for Cardano blockchain.
  final TransactionBuilderConfig config;

  /// The list of transaction outputs from previous transactions
  /// that will be spent in the next transaction.
  ///
  /// Enough [inputs] must be provided to be greater or equal
  /// the amount of [outputs] + [fee].
  final List<TransactionUnspentOutput> inputs;

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

  /// Specifies on which network the code will run.
  final NetworkId? networkId;

  /// The builder that builds the witness set of the transaction.
  ///
  /// The caller must know in advance how many witnesses there will be to
  /// reserve a correct amount of bytes in the transaction as it influences
  /// the fee.
  final TransactionWitnessSetBuilder witnessBuilder;

  /// The default constructor for [TransactionBuilder].
  const TransactionBuilder({
    required this.config,
    required this.inputs,
    this.outputs = const [],
    this.fee,
    this.ttl,
    this.auxiliaryData,
    this.networkId,
    this.witnessBuilder = const TransactionWitnessSetBuilder(
      vkeys: {},
      vkeysCount: 1,
    ),
  });

  /// Returns a copy of this [TransactionBuilder] with extra [address] used
  /// to spend any remaining change from the transaction, if it is needed.
  ///
  /// Since in a Cardano transaction the input amount must match the output
  /// amount plus fee, the method must ensure that there are no unspent utxos.
  ///
  /// The algorithm first tries to create a [TransactionOutput] which will
  /// transfer any remaining [Coin] back to the [address]. The [address]
  /// should be the change address of the wallet initiating the transaction.
  ///
  /// If creating an extra [TransactionOutput] is not possible because
  /// i.e. the remaining change is too small to cover for extra fee that such
  /// extra output would generate then the transaction fee is increased to burn
  /// any remaining change.
  ///
  /// Follows code style of Cardano Multiplatform Lib to make patching easy.
  TransactionBuilder withChangeAddressIfNeeded(ShelleyAddress address) {
    if (this.fee != null) {
      // generating the change output involves changing the fee
      return this;
    }

    final fee = minFee();

    final inputTotal =
        inputs.map((e) => e.output.amount.coin).reduce((a, b) => a + b);
    final outputTotal =
        outputs.map((e) => e.amount.coin).reduce((a, b) => a + b);
    final outputTotalPlusFee = outputTotal + fee;

    if (outputTotalPlusFee == inputTotal) {
      // ignore: avoid_returning_this
      return this;
    } else if (outputTotalPlusFee > inputTotal) {
      throw InsufficientUtxoBalanceException(
        actualAmount: inputTotal,
        requiredAmount: outputTotalPlusFee,
      );
    } else {
      final changeEstimator = inputTotal - outputTotal;

      final minAda = TransactionOutputBuilder.minimumAdaForOutput(
        TransactionOutput(
          address: address,
          amount: Value(coin: changeEstimator),
        ),
        config.coinsPerUtxoByte,
      );

      switch (changeEstimator >= minAda) {
        case false:
          // burn remaining change as fee
          return withFee(changeEstimator);
        case true:
          final feeForChange = TransactionOutputBuilder.feeForOutput(
            this,
            TransactionOutput(
              address: address,
              amount: Value(coin: changeEstimator),
            ),
          );

          final newFee = fee + feeForChange;

          switch (changeEstimator >= minAda) {
            case false:
              // burn remaining change as fee
              return withFee(changeEstimator);
            case true:
              return withFee(newFee).withOutput(
                TransactionOutput(
                  address: address,
                  amount: Value(coin: changeEstimator - newFee),
                ),
              );
          }
      }
    }
  }

  /// Returns a copy of this [TransactionBuilder] with the [fee].
  TransactionBuilder withFee(Coin fee) {
    return _copyWith(fee: fee);
  }

  /// Returns a copy of this [TransactionBuilder] with extra [output].
  ///
  /// The [output] must reach a minimum [Coin] value as calculated
  /// by [TransactionOutputBuilder.minimumAdaForOutput],
  /// otherwise [TxValueBelowMinUtxoValueException] is thrown.
  TransactionBuilder withOutput(TransactionOutput output) {
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

    return _copyWith(
      outputs: [...outputs, output],
    );
  }

  /// Returns a copy of this [TransactionBuilder] with extra [vkeyWitness].
  TransactionBuilder withWitnessVkey(VkeyWitness vkeyWitness) {
    final builder = witnessBuilder.addVkey(vkeyWitness);
    return _copyWith(witnessBuilder: builder);
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

  /// Constructs the rest of the Transaction using fake witness data of the
  /// correct length for use in calculating the size of the final [Transaction].
  Transaction buildFakeTransaction(TransactionBody txBody) {
    return Transaction(
      body: txBody,
      witnessSet: witnessBuilder.buildFake(),
      isValid: true,
      auxiliaryData: auxiliaryData,
    );
  }

  /// Returns the size of the full transaction in bytes.
  int fullSize() {
    return buildAndSize().$2;
  }

  /// Calculates the minimum transaction fee for this builder.
  Coin minFee() {
    final txBody = _copyWith(fee: const Coin(Numbers.intMaxValue)).buildBody();
    final fullTx = buildFakeTransaction(txBody);
    return config.feeAlgo.minNoScriptFee(fullTx);
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
      networkId: networkId,
    );
  }

  TransactionBuilder _copyWith({
    List<TransactionOutput>? outputs,
    Coin? fee,
    TransactionWitnessSetBuilder? witnessBuilder,
  }) {
    return TransactionBuilder(
      config: config,
      inputs: inputs,
      outputs: outputs ?? this.outputs,
      fee: fee ?? this.fee,
      ttl: ttl,
      auxiliaryData: auxiliaryData,
      networkId: networkId,
      witnessBuilder: witnessBuilder ?? this.witnessBuilder,
    );
  }
}

/// A configuration for the [TransactionBuilder] which holds
/// protocol parameters and other constants.
class TransactionBuilderConfig {
  /// The protocol parameter which describes the transaction fee algorithm.
  final LinearFee feeAlgo;

  /// The protocol parameter which limits the maximum transaction size in bytes.
  final int maxTxSize;

  /// The protocol parameter that establishes the minimum amount of [Coin]
  /// required per UTXO entry.
  ///
  /// This prevents storing too many tiny UTXOs on the network.
  final Coin coinsPerUtxoByte;

  /// The default constructor for [TransactionBuilderConfig].
  const TransactionBuilderConfig({
    required this.feeAlgo,
    required this.maxTxSize,
    required this.coinsPerUtxoByte,
  });
}

/// Builder and utils around [TransactionOutput].
class TransactionOutputBuilder {
  /// Constant from figure 5 in Babbage spec meant to represent
  /// the size of the input in a UTXO.
  static const int constantOverhead = 160;

  /// Calculates the additional fee for adding the [output] to the [builder].
  static Coin feeForOutput(
    TransactionBuilder builder,
    TransactionOutput output,
  ) {
    final prev = builder.withFee(const Coin(0));
    final prevFee = prev.minFee();
    final next = prev.withOutput(output);
    final nextFee = next.minFee();
    return nextFee - prevFee;
  }

  /// Calculates the minimum amount of extra [Coin] for UTXO input.
  ///
  /// Adding extra output raises the transaction size which raises the fee,
  /// raising the fee can increase the transaction size as more bytes might
  /// need to be allocated to cover the higher fee.
  ///
  /// The algorithm considers all of above cases.
  static Coin minimumAdaForOutput(
    TransactionOutput output,
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
}
