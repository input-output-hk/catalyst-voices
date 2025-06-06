part of 'main.dart';

TransactionBuilderConfig _buildTransactionBuilderConfig() {
  return const TransactionBuilderConfig(
    feeAlgo: TieredFee(
      constant: 155381,
      coefficient: 44,
      refScriptByteCost: 15,
    ),
    maxTxSize: 16384,
    maxValueSize: 5000,
    maxAssetsPerOutput: 100,
    coinsPerUtxoByte: Coin(4310),
    selectionStrategy: ExactBiggestAssetSelectionStrategy(),
  );
}

Transaction _buildUnsignedTx({
  required Set<TransactionUnspentOutput> utxos,
  required ShelleyAddress changeAddress,
}) {
  /* cSpell:disable */
  final preprodFaucetAddress = ShelleyAddress.fromBech32(
    'addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
  );
  /* cSpell:enable */

  final txOutput = PreBabbageTransactionOutput(
    address: preprodFaucetAddress,
    amount: const Balance(coin: Coin(1000000)),
  );

  final txBuilder = TransactionBuilder(
    config: _buildTransactionBuilderConfig(),
    inputs: utxos,
    networkId: NetworkId.testnet,
    changeAddress: changeAddress,
  );

  final txBody = txBuilder.withOutput(txOutput).applySelection().buildBody();

  return Transaction(
    body: txBody,
    isValid: true,
    witnessSet: const TransactionWitnessSet(),
  );
}

Future<void> _signAndSubmitTx({
  required BuildContext context,
  required CardanoWalletApi api,
}) async {
  var result = '';
  try {
    final changeAddress = await api.getChangeAddress();
    final utxos = await api.getUtxos();

    if (utxos.isEmpty) {
      throw Exception('Insufficient balance, please top up your wallet');
    }

    final unsignedTx = _buildUnsignedTx(
      utxos: utxos,
      changeAddress: changeAddress,
    );

    final witnessSet = await api.signTx(transaction: unsignedTx);

    final signedTx = Transaction(
      body: unsignedTx.body,
      isValid: true,
      witnessSet: witnessSet,
    );

    final txHash = await api.submitTx(transaction: signedTx);
    result = 'Tx hash: ${txHash.toHex()}';
  } catch (error) {
    result = error.toString();
  }

  if (context.mounted) {
    await _showDialog(
      context: context,
      title: 'Sign & submit tx',
      message: result,
    );
  }
}
