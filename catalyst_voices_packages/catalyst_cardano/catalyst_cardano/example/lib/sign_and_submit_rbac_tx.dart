// ignore_for_file: avoid_print

part of 'main.dart';

final _derCert = X509DerCertificate.fromHex(
  '''
308202343082019DA00302010202145A
FC371DAF301793CF0B1835A118C2F903
63D5D9300D06092A864886F70D01010B
05003045310B30090603550406130241
553113301106035504080C0A536F6D65
2D53746174653121301F060355040A0C
18496E7465726E657420576964676974
7320507479204C7464301E170D323430
3731313038353733365A170D32353037
31313038353733365A3045310B300906
03550406130241553113301106035504
080C0A536F6D652D5374617465312130
1F060355040A0C18496E7465726E6574
205769646769747320507479204C7464
30819F300D06092A864886F70D010101
050003818D0030818902818100CD28E2
0B157CA70C85433C1689B1D5890EC479
BDD1FFDCC5647AE12BE9BADF4AF20764
CD24BD64130831A57506DFBBDD3E924C
96B259C6CCEDF24D6A25618F0819643C
739F145B733C3C94333E5937B499ADA9
A4FFC127457C7CB557F2F5623DCADEA1
E06F09129DB9584B0AEE949244B3252B
52AFDE5D385C65E563A6EFB07F020301
0001A321301F301D0603551D0E041604
1492EB169818B833588321957A846077
AA239CF3A0300D06092A864886F70D01
010B0500038181002E5F73333CE667E4
172B252416EAA1D2E9681F59943724B4
F366A8B930443CA6B69B12DD9DEBEE9C
8A6307695EE1884DA4B00136195D1D82
23D1C253FF408EDFC8ED03AF1819244C
35D3843855FB9AF86E84FB7636FA3F4A
0FC396F6FB6FD16D3BCEBDE68A8BD81B
E61E8EE7D77E9F7F9804E03EBC31B458
1313C955A667658B
'''
      .replaceAll('\n', ''),
);

final _c509Cert = C509Certificate.fromHex(
  '''
004301F50D6B524643207465737420
43411A63B0CD001A6955B90047010123
456789AB01582102B1216AB96E5B3B33
40F5BDF02E693F16213A04525ED44450
B1019C2DFD3838AB010058406FC90301
5259A38C0800A3D0B2969CA21977E8ED
6EC344964D4E1C6B37C8FB541274C3BB
81B2F53073C5F101A5AC2A92886583B6
A2679B6E682D2A26945ED0B2
'''
      .replaceAll('\n', ''),
);

const _catalystUserRoleRegistrationPurpose =
    'ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c';

final _transactionHash = TransactionHash.fromHex(
  '4d3f576f26db29139981a69443c2325daa812cc353a31b5a4db794a5bcbb06c2',
);

Future<void> _signAndSubmitRbacTx({
  required BuildContext context,
  required CardanoWalletApi api,
}) async {
  var result = '';
  try {
    final changeAddress = await api.getChangeAddress();

    final utxos = await api.getUtxos(
      amount: const Balance(
        coin: Coin(1000000),
      ),
    );

    final x509Envelope = await _buildMetadataEnvelope(
      utxos: utxos,
    );

    final auxiliaryData = AuxiliaryData.fromCbor(
      x509Envelope.toCbor(serializer: (e) => e.toCbor()),
    );

    final unsignedTx = _buildUnsignedRbacTx(
      inputs: utxos,
      changeAddress: changeAddress,
      auxiliaryData: auxiliaryData,
    );

    final witnessSet = await api.signTx(transaction: unsignedTx);

    final signedTx = Transaction(
      body: unsignedTx.body,
      isValid: true,
      witnessSet: witnessSet,
      auxiliaryData: unsignedTx.auxiliaryData,
    );

    final txHash = await api.submitTx(transaction: signedTx);
    result = 'Tx hash: ${txHash.toHex()}';
  } catch (error) {
    result = error.toString();
  }

  if (context.mounted) {
    await _showDialog(
      context: context,
      title: 'Sign & submit RBAC tx',
      message: result,
    );
  }
}

Future<X509MetadataEnvelope<RegistrationData>> _buildMetadataEnvelope({
  required List<TransactionUnspentOutput> utxos,
}) async {
  final keyPair =
      await Ed25519KeyPair.fromSeed(Ed25519PrivateKey.seeded(0).bytes);

  final x509Envelope = X509MetadataEnvelope.unsigned(
    purpose: UuidV4.fromString(_catalystUserRoleRegistrationPurpose),
    txInputsHash: TransactionInputsHash.fromTransactionInputs(utxos),
    previousTransactionId: _transactionHash,
    chunkedData: RegistrationData(
      derCerts: [_derCert],
      cborCerts: [_c509Cert],
      publicKeys: [keyPair.publicKey],
      revocationSet: [
        CertificateHash.fromX509DerCertificate(_derCert),
        CertificateHash.fromC509Certificate(_c509Cert),
      ],
      roleDataSet: {
        RoleData(
          roleNumber: 0,
          roleSigningKey: KeyReference(
            localRef: const LocalKeyReference(
              keyType: LocalKeyReferenceType.x509Certs,
              keyOffset: 0,
            ),
          ),
          roleEncryptionKey: KeyReference(
            hash: CertificateHash.fromX509DerCertificate(_derCert),
          ),
          paymentKey: 0,
          roleSpecificData: {
            10: CborString('Test'),
          },
        ),
      },
    ),
  );

  print('unsigned x509 envelope:');
  print(
    hex.encode(cbor.encode(x509Envelope.toCbor(serializer: (e) => e.toCbor()))),
  );

  final signedX509Envelope = await x509Envelope.sign(
    privateKey: keyPair.privateKey,
    serializer: (e) => e.toCbor(),
  );

  print('signed x509 envelope:');
  print(
    hex.encode(
      cbor.encode(signedX509Envelope.toCbor(serializer: (e) => e.toCbor())),
    ),
  );

  final isSignatureValid = await signedX509Envelope.verifySignature(
    signature: signedX509Envelope.validationSignature,
    publicKey: keyPair.publicKey,
    serializer: (e) => e.toCbor(),
  );

  print('isSignatureValid: $isSignatureValid');
  print('public key: ${keyPair.publicKey.toHex()}');
  print('private key: ${keyPair.privateKey.toHex()}');
  print('signature: ${signedX509Envelope.validationSignature.toHex()}');

  return signedX509Envelope;
}

Transaction _buildUnsignedRbacTx({
  required List<TransactionUnspentOutput> inputs,
  required ShelleyAddress changeAddress,
  required AuxiliaryData auxiliaryData,
}) {
  final txBuilder = TransactionBuilder(
    config: _buildTransactionBuilderConfig(),
    inputs: inputs,
    networkId: NetworkId.testnet,
    auxiliaryData: auxiliaryData,
  );

  final txBody = txBuilder.withChangeAddressIfNeeded(changeAddress).buildBody();

  return Transaction(
    body: txBody,
    isValid: true,
    witnessSet: const TransactionWitnessSet(vkeyWitnesses: {}),
    auxiliaryData: auxiliaryData,
  );
}
