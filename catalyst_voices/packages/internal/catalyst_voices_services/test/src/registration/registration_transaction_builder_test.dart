import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart' as kd;
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:cbor/cbor.dart';
import 'package:flutter/foundation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group(RegistrationTransactionBuilder, () {
    late Keychain keychain;

    setUpAll(() {
      kd.Bip32Ed25519XPublicKeyFactory.instance = _FakeBip32Ed25519XPublicKeyFactory();
      kd.Bip32Ed25519XPrivateKeyFactory.instance = _FakeBip32Ed25519XPrivateKeyFactory();
      kd.Bip32Ed25519XSignatureFactory.instance = _FakeBip32Ed25519XSignatureFactory();
      CatalystCompressionPlatform.instance = _FakeCatalystCompressionPlatform();
    });

    setUp(() async {
      keychain = _MockKeychain();

      when(
        () => keychain.getRoleKeyPair(role: AccountRole.voter),
      ).thenAnswer((_) async => _voterKeyPair);
    });

    test('txInputsHash is calculated from selected utxos, not from all utxos', () async {
      final allUtxos = {
        TransactionUnspentOutput(
          input: TransactionInput(
            transactionId: _buildDummyTransactionId(0),
            index: 0,
          ),
          output: TransactionOutput(
            address: _changeAddress,
            amount: Balance(coin: Coin.fromAda(1.2)),
          ),
        ),
        TransactionUnspentOutput(
          input: TransactionInput(
            transactionId: _buildDummyTransactionId(1),
            index: 1,
          ),
          output: TransactionOutput(
            address: _changeAddress,
            amount: Balance(coin: Coin.fromAda(1.2)),
          ),
        ),
      };

      final selectedUtxos = {allUtxos.first};

      final transactionBuilder = RegistrationTransactionBuilder(
        transactionConfig: _defaultTransactionBuilderConfig,
        keychain: keychain,
        networkId: NetworkId.testnet,
        slotNumberTtl: const SlotBigNum(100000),
        roles: {const RegistrationTransactionRole.set(AccountRole.voter)},
        changeAddress: _changeAddress,
        rewardAddresses: [_rewardAddress],
        utxos: allUtxos,
        previousTransactionId: null,
      );

      final baseTransaction = await transactionBuilder.build();
      final transactionCbor = cbor.decode(baseTransaction.bytes);
      final transaction = Transaction.fromCbor(transactionCbor);

      final metadata = await X509MetadataEnvelope.fromCbor(
        transaction.auxiliaryData!.toCbor(),
        deserializer: RegistrationData.fromCbor,
      );

      final allUtxosHash = TransactionInputsHash.fromTransactionInputs(allUtxos);
      final selectedUtxosHash = TransactionInputsHash.fromTransactionInputs(selectedUtxos);

      expect(metadata.txInputsHash, isNot(equals(allUtxosHash)));
      expect(metadata.txInputsHash, equals(selectedUtxosHash));
    });

    test('txInputsHash matches hash calculated from selected inputs', () async {
      // Given
      final utxo1 = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: _buildDummyTransactionId(0),
          index: 0,
        ),
        output: TransactionOutput(
          address: _changeAddress,
          amount: Balance(coin: Coin.fromAda(0.3)),
        ),
      );
      final utxo2 = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: _buildDummyTransactionId(1),
          index: 1,
        ),
        output: TransactionOutput(
          address: _changeAddress,
          amount: Balance(coin: Coin.fromAda(0.2)),
        ),
      );
      final utxo3 = TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: _buildDummyTransactionId(2),
          index: 2,
        ),
        output: TransactionOutput(
          address: _changeAddress,
          amount: Balance(coin: Coin.fromAda(0.9)),
        ),
      );

      final allUtxos = {utxo1, utxo2, utxo3};
      final expectedUtxos = {utxo3, utxo1};
      final expectedInputs = {utxo3.input, utxo1.input};

      // When
      final transactionBuilder = RegistrationTransactionBuilder(
        transactionConfig: _defaultTransactionBuilderConfig,
        keychain: keychain,
        networkId: NetworkId.testnet,
        slotNumberTtl: const SlotBigNum(100000),
        roles: {const RegistrationTransactionRole.set(AccountRole.voter)},
        changeAddress: _changeAddress,
        rewardAddresses: [_rewardAddress],
        utxos: allUtxos,
        previousTransactionId: null,
      );

      // Then
      final baseTransaction = await transactionBuilder.build();
      final transactionCbor = cbor.decode(baseTransaction.bytes);
      final transaction = Transaction.fromCbor(transactionCbor);
      final inputs = transaction.body.inputs;

      final metadata = await X509MetadataEnvelope.fromCbor(
        transaction.auxiliaryData!.toCbor(),
        deserializer: RegistrationData.fromCbor,
      );

      expect(
        TransactionInputsHash.fromTransactionInputs(expectedUtxos),
        equals(metadata.txInputsHash),
        reason: 'Should calculate same hash from same utxos',
      );
      expect(
        inputs,
        containsAllInOrder(expectedInputs),
        reason: 'Order of selected utxos is kept',
      );
    });

    // Emirs test
    test('order of selected utxo is consistent', () async {
      // Given
      final address = ShelleyAddress.fromBech32(
        /* cSpell:disable */
        'addr_test1qrg3glkhgr446yh0vlun2fwg3yznyxvulru96tjewej7ea059qfhuxkk4c8tmtxvtvelqgvgaw8jfpw22yd48suy4u3qu4zkyk',
        /* cSpell:enable */
      );

      const biggerUtxoIndex = 5;
      final allUtxos = Set.of(
        List.generate(
          7,
          (index) {
            final id = _buildDummyTransactionId(index);
            final amount = index == biggerUtxoIndex
                ? const Balance(coin: Coin(1157046))
                : const Balance(coin: Coin(969750));

            final input = TransactionInput(transactionId: id, index: index);
            final output = TransactionOutput(address: address, amount: amount);

            return TransactionUnspentOutput(input: input, output: output);
          },
        ),
      );

      final firstExpectedUtxo = allUtxos.elementAt(biggerUtxoIndex);
      final secondExpectedUtxo = allUtxos.elementAt(0);

      final expectedUtxos = {firstExpectedUtxo, secondExpectedUtxo};
      final expectedInputs = {firstExpectedUtxo.input, secondExpectedUtxo.input};

      // When
      final transactionBuilder = RegistrationTransactionBuilder(
        transactionConfig: _defaultTransactionBuilderConfig,
        keychain: keychain,
        networkId: NetworkId.testnet,
        slotNumberTtl: const SlotBigNum(100000),
        roles: {const RegistrationTransactionRole.set(AccountRole.voter)},
        changeAddress: address,
        rewardAddresses: [address],
        utxos: allUtxos,
        previousTransactionId: null,
      );

      // Then
      final baseTransaction = await transactionBuilder.build();
      final transactionCbor = cbor.decode(baseTransaction.bytes);
      final transaction = Transaction.fromCbor(transactionCbor);
      final inputs = transaction.body.inputs;

      final metadata = await X509MetadataEnvelope.fromCbor(
        transaction.auxiliaryData!.toCbor(),
        deserializer: RegistrationData.fromCbor,
      );

      final transactionInputsHash = TransactionInputsHash.fromTransactionInputs(expectedUtxos);
      expect(
        transactionInputsHash,
        equals(metadata.txInputsHash),
        reason: 'Should calculate same hash from same utxos',
      );
      expect(
        inputs,
        containsAllInOrder(expectedInputs),
        reason: 'Order of selected utxos is kept',
      );
    });
  });
}

const _defaultTransactionBuilderConfig = TransactionBuilderConfig(
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

final _changeAddress = ShelleyAddress.fromBech32(
  /* cSpell:disable */
  'addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
  /* cSpell:enable */
);

final _rewardAddress = ShelleyAddress.fromBech32(
  /* cSpell:disable */
  'stake_test1urhsxq8996yy7varz0kgr0ev2e9wltvkcr0kuzd4wwzsdzqvt0e8t',
  /* cSpell:enable */
);
final _voterKeyPair = CatalystKeyPair(
  publicKey: _FakeCatalystPublicKey(bytes: Uint8List.fromList(List.filled(64, 1))),
  privateKey: _FakeCatalystPrivateKey(bytes: Uint8List.fromList(List.filled(96, 2))),
);

TransactionHash _buildDummyTransactionId(int seed) {
  final hex = List.filled(64, '$seed').join();
  return TransactionHash.fromHex(hex);
}

class _FakeBip32Ed25519XPrivateKey extends Fake implements kd.Bip32Ed25519XPrivateKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed25519XPrivateKey(this.bytes);

  @override
  Future<kd.Bip32Ed25519XSignature> sign(List<int> message) async {
    return _FakeBip32Ed25519XSignature([
      ...message.take(32),
      ...List.filled(32, 0),
    ]);
  }

  @override
  Future<R> use<R>(
    Future<R> Function(kd.Bip32Ed25519XPrivateKey privateKey) callback,
  ) => callback(this);

  @override
  Future<bool> verify(List<int> message, {required kd.Bip32Ed25519XSignature signature}) async {
    return true;
  }
}

class _FakeBip32Ed25519XPrivateKeyFactory extends kd.Bip32Ed25519XPrivateKeyFactory {
  @override
  kd.Bip32Ed25519XPrivateKey fromBytes(List<int> bytes) {
    return _FakeBip32Ed25519XPrivateKey(bytes);
  }
}

class _FakeBip32Ed25519XPublicKey extends Fake implements kd.Bip32Ed25519XPublicKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed25519XPublicKey(this.bytes);

  @override
  kd.Ed25519PublicKey toPublicKey() => kd.Ed25519PublicKey.fromBytes(
    bytes.take(kd.Ed25519PrivateKey.length).toList(),
  );
}

class _FakeBip32Ed25519XPublicKeyFactory extends kd.Bip32Ed25519XPublicKeyFactory {
  @override
  kd.Bip32Ed25519XPublicKey fromBytes(List<int> bytes) {
    return _FakeBip32Ed25519XPublicKey(bytes);
  }
}

class _FakeBip32Ed25519XSignature extends Fake implements kd.Bip32Ed25519XSignature {
  @override
  final List<int> bytes;

  _FakeBip32Ed25519XSignature(this.bytes);

  @override
  CborValue toCbor() => CborBytes(bytes);
}

class _FakeBip32Ed25519XSignatureFactory extends kd.Bip32Ed25519XSignatureFactory {
  @override
  kd.Bip32Ed25519XSignature fromBytes(List<int> bytes) {
    return _FakeBip32Ed25519XSignature(bytes);
  }
}

class _FakeCatalystCompressionPlatform extends CatalystCompressionPlatform {
  @override
  CatalystCompressor get brotli => const _FakeCompressor();

  @override
  CatalystCompressor get zstd => const _FakeCompressor();
}

class _FakeCatalystPrivateKey extends Fake implements CatalystPrivateKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPrivateKey({required this.bytes});

  @override
  CatalystSignatureAlgorithm get algorithm => CatalystSignatureAlgorithm.ed25519;

  @override
  Future<CatalystPrivateKey> derivePrivateKey({
    required String path,
  }) async {
    return _FakeCatalystPrivateKey(bytes: Uint8List.fromList(path.codeUnits));
  }

  @override
  Future<CatalystPublicKey> derivePublicKey() async {
    return _FakeCatalystPublicKey(bytes: bytes);
  }

  @override
  void drop() {}
}

class _FakeCatalystPublicKey extends Fake implements CatalystPublicKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPublicKey({required this.bytes});

  @override
  Uint8List get publicKeyBytes => bytes;
}

final class _FakeCompressor implements CatalystCompressor {
  const _FakeCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async => bytes;

  @override
  Future<List<int>> decompress(List<int> bytes) async => bytes;
}

class _MockKeychain extends Mock implements Keychain {}
