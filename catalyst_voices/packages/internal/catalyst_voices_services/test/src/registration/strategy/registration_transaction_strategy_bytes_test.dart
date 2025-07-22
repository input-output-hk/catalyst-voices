import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart' as kd;
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart' show Bip32Ed25519XSignature;
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/registration/strategy/registration_transaction_strategy_bytes.dart';
import 'package:cbor/cbor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group(RegistrationTransactionStrategyBytes, () {
    late KeyDerivationService keyDerivationService;

    setUpAll(() {
      kd.Bip32Ed25519XPublicKeyFactory.instance = _FakeBip32Ed25519XPublicKeyFactory();
      kd.Bip32Ed25519XPrivateKeyFactory.instance = _FakeBip32Ed25519XPrivateKeyFactory();
      kd.Bip32Ed25519XSignatureFactory.instance = _FakeBip32Ed25519XSignatureFactory();
      CatalystCompressionPlatform.instance = _FakeCatalystCompressionPlatform();
    });

    setUp(() async {
      keyDerivationService = _MockKeyDerivationService();

      when(
        () => keyDerivationService.deriveAccountRoleKeyPair(
          masterKey: _masterKey,
          role: AccountRole.voter,
        ),
      ).thenAnswer((_) async => _voterKeyPair);
    });

    test('raw transaction have correctly patched txInputsHash', () async {
      // Given
      final utxos = _buildUtxos();
      final requiredSigners = {
        _rewardAddress.publicKeyHash,
      };

      final derCert = _buildCert();
      final strategy = _buildStrategy(utxos: utxos);

      // When
      final rootKeyPair = await keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: _masterKey,
        role: AccountRole.voter,
      );
      final publicKeys = <RbacField<Ed25519PublicKey>>[
        RbacField.set(Ed25519PublicKey.fromBytes(List.filled(Ed25519PublicKey.length, 0))),
      ];

      // Then
      final rawTransaction = await strategy.build(
        purpose: _purpose,
        rootKeyPair: rootKeyPair,
        derCert: derCert,
        publicKeys: publicKeys,
        requiredSigners: requiredSigners,
      );

      expect(
        rawTransaction.txInputsHash,
        allOf(hasLength(TransactionInputsHash.hashLength), isNot(everyElement(0))),
        reason: 'txInputsHash have correct size and is non zero',
      );
    });

    test('raw transaction have correctly patched signature', () async {
      // Given
      final utxos = _buildUtxos();
      final requiredSigners = {
        _rewardAddress.publicKeyHash,
      };

      final derCert = _buildCert();
      final strategy = _buildStrategy(utxos: utxos);

      // When
      final rootKeyPair = await keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: _masterKey,
        role: AccountRole.voter,
      );
      final publicKeys = <RbacField<Ed25519PublicKey>>[
        RbacField.set(Ed25519PublicKey.fromBytes(List.filled(Ed25519PublicKey.length, 0))),
      ];

      // Then
      final rawTransaction = await strategy.build(
        purpose: _purpose,
        rootKeyPair: rootKeyPair,
        derCert: derCert,
        publicKeys: publicKeys,
        requiredSigners: requiredSigners,
      );

      expect(
        rawTransaction.signature,
        allOf(hasLength(Bip32Ed25519XSignature.length), isNot(everyElement(0))),
        reason: 'signature have correct size and is non zero',
      );
    });

    test('raw transaction have correct auxiliaryDataHash', () async {
      // Given
      final utxos = _buildUtxos();
      final requiredSigners = {
        _rewardAddress.publicKeyHash,
      };

      final derCert = _buildCert();
      final strategy = _buildStrategy(utxos: utxos);

      // When
      final rootKeyPair = await keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: _masterKey,
        role: AccountRole.voter,
      );
      final publicKeys = <RbacField<Ed25519PublicKey>>[
        RbacField.set(Ed25519PublicKey.fromBytes(List.filled(Ed25519PublicKey.length, 0))),
      ];

      // Then
      final rawTransaction = await strategy.build(
        purpose: _purpose,
        rootKeyPair: rootKeyPair,
        derCert: derCert,
        publicKeys: publicKeys,
        requiredSigners: requiredSigners,
      );

      final auxiliaryData = rawTransaction.auxiliaryData;
      final auxiliaryDataHash = AuxiliaryDataHash.blake2b(auxiliaryData);

      expect(
        rawTransaction.auxiliaryDataHash,
        equals(auxiliaryDataHash.bytes),
      );
    });

    test('auxiliary data size does not change', () async {
      // Given
      final utxos = _buildUtxos();
      final requiredSigners = {
        _rewardAddress.publicKeyHash,
      };

      final derCert = _buildCert();
      final strategy = _buildStrategy(utxos: utxos);

      // When
      final rootKeyPair = await keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: _masterKey,
        role: AccountRole.voter,
      );
      final publicKeys = <RbacField<Ed25519PublicKey>>[
        RbacField.set(Ed25519PublicKey.fromBytes(List.filled(Ed25519PublicKey.length, 0))),
      ];

      // Then
      Future<RawTransaction> build() async {
        return strategy.build(
          purpose: _purpose,
          rootKeyPair: rootKeyPair,
          derCert: derCert,
          publicKeys: publicKeys,
          requiredSigners: requiredSigners,
        );
      }

      expect(build, returnsNormally);
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

const _purpose = 'ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c';

final _changeAddress = ShelleyAddress.fromBech32(
  /* cSpell:disable */
  'addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
  /* cSpell:enable */
);

final _masterKey = _FakeCatalystPrivateKey(bytes: _masterKeyBytes);

final _masterKeyBytes = Uint8List.fromList(List.filled(96, 0));
final _rewardAddress = ShelleyAddress.fromBech32(
  /* cSpell:disable */
  'stake_test1urhsxq8996yy7varz0kgr0ev2e9wltvkcr0kuzd4wwzsdzqvt0e8t',
  /* cSpell:enable */
);

final _voterKeyPair = CatalystKeyPair(
  publicKey: _FakeCatalystPublicKey(bytes: Uint8List.fromList(List.filled(64, 1))),
  privateKey: _FakeCatalystPrivateKey(bytes: Uint8List.fromList(List.filled(96, 2))),
);

X509DerCertificate _buildCert() {
  return X509DerCertificate.fromBytes(bytes: List.filled(1000, 0));
}

TransactionHash _buildDummyTransactionId(int seed) {
  final hex = List.filled(64, '$seed').join();
  return TransactionHash.fromHex(hex);
}

RegistrationTransactionStrategyBytes _buildStrategy({
  TransactionBuilderConfig transactionConfig = _defaultTransactionBuilderConfig,
  ShelleyAddress? changeAddress,
  SlotBigNum slotNumberTtl = const SlotBigNum(100000),
  Set<RegistrationTransactionRole>? roles,
  required Set<TransactionUnspentOutput> utxos,
}) {
  changeAddress ??= _changeAddress;
  roles ??= {const RegistrationTransactionRole.set(AccountRole.voter)};

  return RegistrationTransactionStrategyBytes(
    transactionConfig: transactionConfig,
    networkId: NetworkId.testnet,
    slotNumberTtl: slotNumberTtl,
    roles: roles,
    changeAddress: changeAddress,
    utxos: utxos,
    previousTransactionId: null,
  );
}

Set<TransactionUnspentOutput> _buildUtxos() {
  return {
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
  ) =>
      callback(this);
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

class _MockKeyDerivationService extends Mock implements KeyDerivationService {}
