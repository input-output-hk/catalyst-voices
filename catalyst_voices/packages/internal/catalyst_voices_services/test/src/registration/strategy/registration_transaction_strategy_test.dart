import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart' hide Ed25519PublicKey;
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/registration/strategy/registration_transaction_strategy.dart';
import 'package:catalyst_voices_services/src/registration/strategy/registration_transaction_strategy_bytes.dart';
import 'package:catalyst_voices_services/src/registration/strategy/registration_transaction_strategy_models.dart';
import 'package:catalyst_voices_services/src/registration/strategy/registration_transaction_strategy_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group(RegistrationTransactionStrategy, () {
    late KeyDerivationService keyDerivationService;

    setUpAll(() {
      Bip32Ed25519XPublicKeyFactory.instance = FakeBip32Ed25519XPublicKeyFactory();
      Bip32Ed25519XPrivateKeyFactory.instance = FakeBip32Ed25519XPrivateKeyFactory();
      Bip32Ed25519XSignatureFactory.instance = FakeBip32Ed25519XSignatureFactory();
      CatalystCompression.overrideBrotli(const FakeCompressor());
      CatalystCompression.overrideZstd(const FakeCompressor());
    });

    setUp(() async {
      keyDerivationService = MockKeyDerivationService();

      when(
        () => keyDerivationService.deriveAccountRoleKeyPair(
          masterKey: _masterKey,
          role: AccountRole.voter,
        ),
      ).thenAnswer((_) async => _voterKeyPair);
    });

    test('comparing models and bytes transactions should give same output', () async {
      // Given
      final utxos = {
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
      final requiredSigners = {
        _rewardAddress.publicKeyHash,
        _changeAddress.publicKeyHash,
      };

      final derCert = X509DerCertificate.fromBytes(bytes: List.filled(32, 0));

      // When
      final rootKeyPair = await keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: _masterKey,
        role: AccountRole.voter,
      );
      final publicKeys = <RbacField<Ed25519PublicKey>>[
        RbacField.set(Ed25519PublicKey.fromBytes(List.filled(Ed25519PublicKey.length, 0))),
      ];

      final models = _pickStrategy(RegistrationTransactionStrategyType.models, utxos: utxos);
      final bytes = _pickStrategy(RegistrationTransactionStrategyType.bytes, utxos: utxos);

      // Then
      final modelsTransaction = await models.build(
        purpose: _purpose,
        rootKeyPair: rootKeyPair,
        derCert: derCert,
        publicKeys: publicKeys,
        requiredSigners: requiredSigners,
      );
      final rawTransaction = await bytes.build(
        purpose: _purpose,
        rootKeyPair: rootKeyPair,
        derCert: derCert,
        publicKeys: publicKeys,
        requiredSigners: requiredSigners,
      );

      final modelsTxBytes = modelsTransaction.bytes;
      final rawTxBytes = rawTransaction.bytes;

      expect(
        modelsTxBytes,
        allOf(hasLength(rawTxBytes.length), equals(rawTxBytes)),
        reason: 'Two bytes and models strategy have to produce same outcome',
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

const _purpose = 'ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c';

final _changeAddress = ShelleyAddress.fromBech32(
  /* cSpell:disable */
  'addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
  /* cSpell:enable */
);

final _masterKey = FakeCatalystPrivateKey(bytes: _masterKeyBytes);
final _masterKeyBytes = Uint8List.fromList(List.filled(96, 0));

final _rewardAddress = ShelleyAddress.fromBech32(
  /* cSpell:disable */
  'stake_test1urhsxq8996yy7varz0kgr0ev2e9wltvkcr0kuzd4wwzsdzqvt0e8t',
  /* cSpell:enable */
);
final _voterKeyPair = CatalystKeyPair(
  publicKey: FakeCatalystPublicKey(bytes: Uint8List.fromList(List.filled(64, 1))),
  privateKey: FakeCatalystPrivateKey(bytes: Uint8List.fromList(List.filled(96, 2))),
);

TransactionHash _buildDummyTransactionId(int seed) {
  final hex = List.filled(64, '$seed').join();
  return TransactionHash.fromHex(hex);
}

RegistrationTransactionStrategy _pickStrategy(
  RegistrationTransactionStrategyType type, {
  TransactionBuilderConfig transactionConfig = _defaultTransactionBuilderConfig,
  ShelleyAddress? changeAddress,
  SlotBigNum slotNumberTtl = const SlotBigNum(100000),
  Set<RegistrationTransactionRole>? roles,
  required Set<TransactionUnspentOutput> utxos,
}) {
  changeAddress ??= _changeAddress;
  roles ??= {const RegistrationTransactionRole.set(AccountRole.voter)};

  switch (type) {
    case RegistrationTransactionStrategyType.models:
      return RegistrationTransactionStrategyModels(
        transactionConfig: transactionConfig,
        networkId: NetworkId.testnet,
        slotNumberTtl: slotNumberTtl,
        roles: roles,
        changeAddress: changeAddress,
        utxos: utxos,
        previousTransactionId: null,
      );
    case RegistrationTransactionStrategyType.bytes:
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
}
