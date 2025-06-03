import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'selection_utils.dart';
import 'test_data.dart';

/// A [test] util which is run with randomly generated (seeded) [TransactionPropertyTestData].
///
/// It might be helpful to create large quantities of transactions to test
/// various scenarios such as coin selection or outputs planning.
///
/// Parameters:
/// - [description]: the test description.
/// - [body]: the test body.
/// - [config]: optional [TransactionBuilderConfig], if provided the test data will use it.
/// - [maxExamples]: how many different data sets to generate.
/// - [maxUtxos]: a maximum number of inputs utxos in the [TransactionPropertyTestData], must be at least one.
/// - [maxOutputs]: a maximum number of outputs to generate for the transaction.
/// - [maxAuxiliaryDataBytes]: a byte length of [AuxiliaryData].
/// - [minimumUtxoCoin]: the least of Ada in each of UTxO's.
///
///   The outputs are guaranteed to be composed in a way that it's possible to make
///   a valid transaction with generated configuration.
@isTest
void transactionPropertyTest(
  String description,
  FutureOr<void> Function(TransactionPropertyTestData data) body, {
  TransactionBuilderConfig? config,
  int maxExamples = 1000,
  int maxUtxos = 130,
  int maxOutputs = 20,
  int maxAuxiliaryDataBytes = 100,
  Coin minimumUtxoCoin = const Coin(1500000),
}) {
  property(description, () {
    forAll(
      maxExamples: maxExamples,
      combine6(
        combine2(
          integer(min: 1, max: maxUtxos),
          boolean(),
        ),
        integer(min: 0, max: maxOutputs),
        integer(min: 0, max: 1000000000),
        binary(minLength: 0, maxLength: maxAuxiliaryDataBytes),
        constantFrom([...NetworkId.values, null]),
        integer(min: 0, max: 3),
      ),
      (data) async {
        final resolvedConfig = config ?? transactionBuilderConfig();

        final (
          (utxoCount, withTokens),
          outputsCount,
          ttl,
          auxiliaryData,
          networkId,
          requiredSigners,
        ) = data;

        final utxos = SelectionUtils.generateUtxos(
          utxoCount,
          withTokens: withTokens,
          minimumCoin: minimumUtxoCoin,
          minimumTotalAda: withTokens ? const Coin.fromWholeAda(3) : null,
        );

        final outputs = outputsCount > 0
            ? SelectionUtils.outputsFromUTxos(
                inputs: utxos,
                config: resolvedConfig,
                maxOutputs: outputsCount,
              )
            : <TransactionOutput>[];

        final builderData = TransactionPropertyBuilderInputs(
          inputs: utxos,
          outputs: outputs,
          ttl: ttl > 0 ? SlotBigNum(ttl) : null,
          auxiliaryData: auxiliaryData.isEmpty
              ? null
              : AuxiliaryData(
                  map: {
                    const CborSmallInt(0): CborBytes(auxiliaryData),
                  },
                ),
          networkId: networkId,
          requiredSigners: requiredSigners > 0
              ? List.generate(
                  requiredSigners,
                  (i) => Ed25519PublicKeyHash.fromPublicKey(Ed25519PublicKey.seeded(i)),
                ).toSet()
              : null,
          changeAddress: SelectionUtils.randomAddress(networkId: networkId ?? NetworkId.testnet),
        );

        final builder = TransactionBuilder(
          config: resolvedConfig,
          inputs: builderData.inputs,
          outputs: builderData.outputs,
          ttl: builderData.ttl,
          // auxiliaryData: builderData.auxiliaryData,
          networkId: builderData.networkId,
          requiredSigners: builderData.requiredSigners,
          changeAddress: builderData.changeAddress,
        );

        final testData = TransactionPropertyTestData(
          builder: builder,
          inputs: builderData,
        );

        await body(testData);
      },
    );
  });
}

/// Properties of [TransactionBuilder].
final class TransactionPropertyBuilderInputs extends Equatable {
  final Set<TransactionUnspentOutput> inputs;
  final List<TransactionOutput> outputs;
  final SlotBigNum? ttl;
  final AuxiliaryData? auxiliaryData;
  final NetworkId? networkId;
  final Set<Ed25519PublicKeyHash>? requiredSigners;
  final ShelleyAddress changeAddress;

  const TransactionPropertyBuilderInputs({
    required this.inputs,
    required this.outputs,
    required this.ttl,
    required this.auxiliaryData,
    required this.networkId,
    required this.requiredSigners,
    required this.changeAddress,
  });

  @override
  List<Object?> get props => [
        inputs,
        outputs,
        ttl,
        auxiliaryData,
        networkId,
        requiredSigners,
        changeAddress,
      ];
}

/// The test data with which the [transactionPropertyTest] runs.
final class TransactionPropertyTestData extends Equatable {
  final TransactionBuilder builder;
  final TransactionPropertyBuilderInputs inputs;

  const TransactionPropertyTestData({
    required this.builder,
    required this.inputs,
  });

  @override
  List<Object?> get props => [
        builder,
        inputs,
      ];
}
