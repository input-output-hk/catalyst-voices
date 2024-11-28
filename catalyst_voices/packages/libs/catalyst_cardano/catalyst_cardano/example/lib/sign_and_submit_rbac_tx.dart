// ignore_for_file: avoid_print

part of 'main.dart';

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
    final rewardAddresses = await api.getRewardAddresses();

    final utxos = await api.getUtxos(
      amount: const Balance(
        coin: Coin(1000000),
      ),
    );

    if (utxos.isEmpty) {
      throw Exception('Insufficient balance, please top up your wallet');
    }

    final x509Envelope = await _buildMetadataEnvelope(
      utxos: utxos,
      rewardAddress: rewardAddresses.first,
    );

    final auxiliaryData = AuxiliaryData.fromCbor(
      await x509Envelope.toCbor(serializer: (e) => e.toCbor()),
    );

    final unsignedTx = _buildUnsignedRbacTx(
      inputs: utxos,
      changeAddress: changeAddress,
      rewardAddress: rewardAddresses.first,
      auxiliaryData: auxiliaryData,
    );

    print('unsigned tx: ${hex.encode(cbor.encode(unsignedTx.toCbor()))}');

    final witnessSet = await api.signTx(transaction: unsignedTx);

    print('Witness set: $witnessSet');

    final signedTx = Transaction(
      body: unsignedTx.body,
      isValid: true,
      witnessSet: witnessSet,
      auxiliaryData: unsignedTx.auxiliaryData,
    );

    print('signed tx: ${hex.encode(cbor.encode(signedTx.toCbor()))}');

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
  required Set<TransactionUnspentOutput> utxos,
  required ShelleyAddress rewardAddress,
}) async {
  const mnemonic = 'minute cause soda tilt taste cabin'
      ' father body mixture box gym awkward';

  const keyDerivation = CatalystKeyDerivation();
  final privateKey = await keyDerivation.deriveMasterKey(mnemonic: mnemonic);
  final publicKey = await privateKey.derivePublicKey();

  final keyPair = Bip32Ed25519XKeyPair(
    publicKey: publicKey,
    privateKey: privateKey,
  );

  final cert = await generateX509Certificate(
    keyPair: keyPair,
    stakeAddress: rewardAddress,
  );

  final derCert = cert.toDer();

  final x509Envelope = X509MetadataEnvelope.unsigned(
    purpose: UuidV4.fromString(_catalystUserRoleRegistrationPurpose),
    txInputsHash: TransactionInputsHash.fromTransactionInputs(utxos),
    previousTransactionId: _transactionHash,
    chunkedData: RegistrationData(
      derCerts: [derCert],
      publicKeys: [keyPair.publicKey],
      roleDataSet: {
        RoleData(
          roleNumber: 0,
          roleSigningKey: const LocalKeyReference(
            keyType: LocalKeyReferenceType.x509Certs,
            keyOffset: 0,
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
    hex.encode(
      cbor.encode(await x509Envelope.toCbor(serializer: (e) => e.toCbor())),
    ),
  );

  final signedX509Envelope = await x509Envelope.sign(
    privateKey: keyPair.privateKey,
    serializer: (e) => e.toCbor(),
  );

  print('signed x509 envelope:');
  print(
    hex.encode(
      cbor.encode(
        await signedX509Envelope.toCbor(serializer: (e) => e.toCbor()),
      ),
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
  required Set<TransactionUnspentOutput> inputs,
  required ShelleyAddress changeAddress,
  required ShelleyAddress rewardAddress,
  required AuxiliaryData auxiliaryData,
}) {
  final txBuilder = TransactionBuilder(
    requiredSigners: {
      rewardAddress.publicKeyHash,
    },
    config: _buildTransactionBuilderConfig(),
    inputs: inputs,
    networkId: NetworkId.testnet,
    auxiliaryData: auxiliaryData,
    witnessBuilder: const TransactionWitnessSetBuilder(
      vkeys: {},
      // TODO(dtscalac): investigate if vkeyCount can be found out
      // in a better way, count = reward addresses vkeys + payment address vkey
      vkeysCount: 2,
    ),
  );

  final txBody = txBuilder.withChangeAddressIfNeeded(changeAddress).buildBody();

  return Transaction(
    body: txBody,
    isValid: true,
    witnessSet: const TransactionWitnessSet(),
    auxiliaryData: auxiliaryData,
  );
}

Future<X509Certificate> generateX509Certificate({
  required Bip32Ed25519XKeyPair keyPair,
  required ShelleyAddress stakeAddress,
}) async {
  const maxInt = 4294967296;

  /* cSpell:disable */
  const issuer = X509DistinguishedName(
    countryName: '',
    stateOrProvinceName: '',
    localityName: '',
    organizationName: '',
    organizationalUnitName: '',
    commonName: '',
  );

  final tbs = X509TBSCertificate(
    serialNumber: Random().nextInt(maxInt),
    subjectPublicKey: keyPair.publicKey,
    issuer: issuer,
    validityNotBefore: DateTime.now().toUtc(),
    validityNotAfter: X509TBSCertificate.foreverValid,
    subject: issuer,
    extensions: X509CertificateExtensions(
      subjectAltName: [
        'mydomain.com',
        'www.mydomain.com',
        'example.com',
        'www.example.com',
        'web+cardano://addr/${stakeAddress.toBech32()}',
      ],
    ),
  );
  /* cSpell:enable */

  return X509Certificate.generateSelfSigned(
    tbsCertificate: tbs,
    privateKey: keyPair.privateKey,
  );
}
