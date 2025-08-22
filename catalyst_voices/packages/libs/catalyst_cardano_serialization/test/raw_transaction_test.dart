import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart'
    as cs
    show Ed25519PublicKey;
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/raw_transaction_aspect.dart';
import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart' as kd;
import 'package:cbor/cbor.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group(RawTransaction, () {
    final address = ShelleyAddress.fromBech32(
      /* cSpell:disable */
      'addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
      /* cSpell:enable */
    );

    final inputs = {
      TransactionInput(transactionId: _buildDummyTransactionId(0), index: 0),
      TransactionInput(transactionId: _buildDummyTransactionId(1), index: 1),
    };
    final outputs = [
      TransactionOutput(
        address: address,
        amount: Balance(coin: Coin.fromAda(1.2)),
      ),
    ];
    final fee = Coin.fromAda(0.19);
    final purpose = UuidV4.fromString('ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c');

    const voterRole = 0;

    late X509MetadataEnvelope<RegistrationData> envelope;

    setUpAll(() {
      CatalystCompressionPlatform.instance = _FakeCatalystCompressionPlatform();
    });

    setUp(() async {
      final txInputsHashBytes = List.filled(TransactionInputsHash.hashLength, 0);
      final txInputsHash = TransactionInputsHash.fromBytes(bytes: txInputsHashBytes);

      final signatureBytes = List.filled(kd.Bip32Ed25519XSignature.length, 0);
      final signature = _FakeBip32Ed25519XSignature(signatureBytes) as kd.Bip32Ed25519XSignature;

      final derCert = X509DerCertificate.fromBytes(bytes: List.filled(1000, 0));
      final publicKey = cs.Ed25519PublicKey.fromBytes(List.filled(cs.Ed25519PublicKey.length, 0));

      envelope = X509MetadataEnvelope<RegistrationData>(
        purpose: purpose,
        txInputsHash: txInputsHash,
        chunkedData: RegistrationData(
          derCerts: [
            RbacField.set(derCert),
          ],
          publicKeys: [
            RbacField.set(publicKey),
          ],
          roleDataSet: {
            const RoleData(
              roleNumber: voterRole,
              roleSigningKey: LocalKeyReference(
                keyType: LocalKeyReferenceType.x509Certs,
                offset: voterRole,
              ),
              paymentKey: 0,
            ),
          },
        ),
        validationSignature: signature,
      );
    });

    test('decodes into valid cbor', () async {
      // Given
      final body = TransactionBody(
        inputs: inputs,
        outputs: outputs,
        fee: fee,
      );
      const witnessSet = TransactionWitnessSet();
      const isValid = true;

      // When
      final envelopeCbor = await envelope.toCbor(serializer: (value) => value.toCbor());
      final auxiliaryData = AuxiliaryData.fromCbor(envelopeCbor);

      final rawTx = RawTransaction.from(
        body: body,
        witnessSet: witnessSet,
        isValid: isValid,
        auxiliaryData: auxiliaryData,
      );

      // Then
      void decode() {
        cborDecode(rawTx.bytes);
      }

      expect(
        decode,
        returnsNormally,
        reason: 'Have to produce valid cbor',
      );
    });

    test('Metadata Placeholder Encoding', () async {
      // Given
      final body = TransactionBody(
        inputs: inputs,
        outputs: outputs,
        fee: fee,
      );
      const witnessSet = TransactionWitnessSet();
      const isValid = true;

      // When
      final envelopeCbor = await envelope.toCbor(serializer: (value) => value.toCbor());
      final auxiliaryData = AuxiliaryData.fromCbor(envelopeCbor);

      final rawTx = RawTransaction.from(
        body: body,
        witnessSet: witnessSet,
        isValid: isValid,
        auxiliaryData: auxiliaryData,
      );

      final auxiliaryDataCbor = cborDecode(rawTx.auxiliaryData);

      // Then
      expect(auxiliaryDataCbor, isA<CborMap>());
      expect(auxiliaryDataCbor, hasLength(1));

      final entry = (auxiliaryDataCbor as CborMap).entries.elementAt(0);

      expect(entry.key, X509MetadataEnvelope.envelopeKey);

      final decodedEnvelope = entry.value as CborMap;
      expect(
        decodedEnvelope.keys,
        containsAll(
          [
            X509MetadataEnvelope.txInputsHashKey,
            X509MetadataEnvelope.validationSignatureKey,
          ],
        ),
      );

      expect(
        decodedEnvelope[X509MetadataEnvelope.txInputsHashKey],
        allOf(
          isA<CborBytes>(),
          predicate<CborBytes>((e) => e.bytes.length == TransactionInputsHash.hashLength),
          predicate<CborBytes>((e) => e.bytes.every((element) => element == 0)),
        ),
      );
    });

    test('Metadata Offset Capture', () async {
      // Given
      final body = TransactionBody(
        inputs: inputs,
        outputs: outputs,
        fee: fee,
      );
      const witnessSet = TransactionWitnessSet();
      const isValid = true;

      // When
      final envelopeCbor = await envelope.toCbor(serializer: (value) => value.toCbor());
      final auxiliaryData = AuxiliaryData.fromCbor(envelopeCbor);

      final rawTx = RawTransaction.from(
        body: body,
        witnessSet: witnessSet,
        isValid: isValid,
        auxiliaryData: auxiliaryData,
      );

      final txContext = rawTx.context;

      // Then
      expect(txContext.containsKey(RawTransactionAspect.auxiliaryData), isTrue);
      expect(txContext.containsKey(RawTransactionAspect.txInputsHash), isTrue);
      expect(txContext.containsKey(RawTransactionAspect.signature), isTrue);
    });

    test('Metadata Size Change Verification', () async {
      // Given
      final body = TransactionBody(
        inputs: inputs,
        outputs: outputs,
        fee: fee,
      );
      const witnessSet = TransactionWitnessSet();
      const isValid = true;

      // When
      final envelopeCbor = await envelope.toCbor(serializer: (value) => value.toCbor());
      final auxiliaryData = AuxiliaryData.fromCbor(envelopeCbor);

      final rawTx = RawTransaction.from(
        body: body,
        witnessSet: witnessSet,
        isValid: isValid,
        auxiliaryData: auxiliaryData,
      );

      final newTxInputsHash = List.filled(TransactionInputsHash.hashLength, 1);
      final newSignature = List.filled(kd.Bip32Ed25519XSignature.length, 1);

      // Then
      final size = rawTx.auxiliaryData.length;

      rawTx
        ..patchTxInputsHash(newTxInputsHash)
        ..patchSignature(newSignature);

      expect(
        rawTx.auxiliaryData,
        hasLength(size),
        reason: 'auxiliaryData size does not change',
      );
    });

    test('In Place Hash Patching', () async {
      // Given
      final body = TransactionBody(
        inputs: inputs,
        outputs: outputs,
        fee: fee,
      );
      const witnessSet = TransactionWitnessSet();
      const isValid = true;

      // When
      final envelopeCbor = await envelope.toCbor(serializer: (value) => value.toCbor());
      final auxiliaryData = AuxiliaryData.fromCbor(envelopeCbor);

      final rawTx = RawTransaction.from(
        body: body,
        witnessSet: witnessSet,
        isValid: isValid,
        auxiliaryData: auxiliaryData,
      );

      final newTxInputsHashBytes = List.filled(TransactionInputsHash.hashLength, 1);
      final newTxInputsHash = TransactionInputsHash.blake2b(newTxInputsHashBytes);

      // Then
      final size = rawTx.auxiliaryData.length;

      rawTx.patchTxInputsHash(newTxInputsHash.bytes);

      expect(
        rawTx.auxiliaryData,
        hasLength(size),
        reason: 'auxiliaryData size does not change',
      );
      expect(
        () => cbor.decode(rawTx.auxiliaryData),
        returnsNormally,
        reason: 'Remains valid cbor',
      );
    });

    test('In Place Signature Patching', () async {
      // Given
      final body = TransactionBody(
        inputs: inputs,
        outputs: outputs,
        fee: fee,
      );
      const witnessSet = TransactionWitnessSet();
      const isValid = true;

      // When
      final envelopeCbor = await envelope.toCbor(serializer: (value) => value.toCbor());
      final auxiliaryData = AuxiliaryData.fromCbor(envelopeCbor);

      final rawTx = RawTransaction.from(
        body: body,
        witnessSet: witnessSet,
        isValid: isValid,
        auxiliaryData: auxiliaryData,
      );

      final newSignatureBytes = List.filled(kd.Bip32Ed25519XSignature.length, 1);
      final newSignature = _FakeBip32Ed25519XSignature(newSignatureBytes);

      // Then
      final size = rawTx.auxiliaryData.length;

      rawTx.patchSignature(newSignature.bytes);

      expect(
        rawTx.auxiliaryData,
        hasLength(size),
        reason: 'auxiliaryData size does not change',
      );
      expect(
        () => cbor.decode(rawTx.auxiliaryData),
        returnsNormally,
        reason: 'Remains valid cbor',
      );
    });

    test('In Place Signature Patching', () async {
      // Given
      final body = TransactionBody(
        inputs: inputs,
        outputs: outputs,
        fee: fee,
      );
      const witnessSet = TransactionWitnessSet();
      const isValid = true;

      // When
      final envelopeCbor = await envelope.toCbor(serializer: (value) => value.toCbor());
      final auxiliaryData = AuxiliaryData.fromCbor(envelopeCbor);

      final rawTx = RawTransaction.from(
        body: body,
        witnessSet: witnessSet,
        isValid: isValid,
        auxiliaryData: auxiliaryData,
      );

      final newSignatureBytes = List.filled(kd.Bip32Ed25519XSignature.length, 1);
      final newSignature = _FakeBip32Ed25519XSignature(newSignatureBytes);

      // Then
      final size = rawTx.auxiliaryData.length;

      rawTx.patchSignature(newSignature.bytes);

      expect(
        rawTx.auxiliaryData,
        hasLength(size),
        reason: 'auxiliaryData size does not change',
      );
      expect(
        () => cbor.decode(rawTx.auxiliaryData),
        returnsNormally,
        reason: 'Remains valid cbor',
      );
    });

    test('Incorrect Patch Size Rejection', () async {
      // Given
      final body = TransactionBody(
        inputs: inputs,
        outputs: outputs,
        fee: fee,
      );
      const witnessSet = TransactionWitnessSet();
      const isValid = true;

      // When
      final envelopeCbor = await envelope.toCbor(serializer: (value) => value.toCbor());
      final auxiliaryData = AuxiliaryData.fromCbor(envelopeCbor);

      final rawTx = RawTransaction.from(
        body: body,
        witnessSet: witnessSet,
        isValid: isValid,
        auxiliaryData: auxiliaryData,
      );

      final invalidTxInputHash = List.filled(TransactionInputsHash.hashLength * 2, 1);
      final invalidSignature = List.filled(kd.Bip32Ed25519XSignature.length * 2, 1);

      // Then
      void attemptToPatchTxInputHash() {
        rawTx.patchTxInputsHash(invalidTxInputHash);
      }

      void attemptToPatchSignature() {
        rawTx.patchTxInputsHash(invalidSignature);
      }

      expect(
        attemptToPatchTxInputHash,
        throwsA(isA<ArgumentError>()),
        reason: 'Prevents corruption or buffer overrun scenarios',
      );
      expect(
        attemptToPatchSignature,
        throwsA(isA<ArgumentError>()),
        reason: 'Prevents corruption or buffer overrun scenarios',
      );
    });

    test('Chunked Metadata Encoding', () async {
      // Given
      final body = TransactionBody(
        inputs: inputs,
        outputs: outputs,
        fee: fee,
      );
      const witnessSet = TransactionWitnessSet();
      const isValid = true;

      // When
      final envelopeCbor = await envelope.toCbor(serializer: (value) => value.toCbor());
      final auxiliaryData = AuxiliaryData.fromCbor(envelopeCbor);

      final rawTx = RawTransaction.from(
        body: body,
        witnessSet: witnessSet,
        isValid: isValid,
        auxiliaryData: auxiliaryData,
      );

      // Then
      expect(() => cbor.decode(rawTx.bytes), returnsNormally, reason: 'CBOR remains valid');

      final chunkedData =
          ((cbor.decode(rawTx.auxiliaryData) as CborMap)[X509MetadataEnvelope.envelopeKey]!
              as CborMap)[const CborSmallInt(10)];

      expect(
        chunkedData,
        allOf(isNotNull, isA<CborList>()),
        reason: 'Chunked data is a list',
      );
    });

    test('Replay Attack Resilience', () async {
      // Given
      final body = TransactionBody(
        inputs: inputs,
        outputs: outputs,
        fee: fee,
      );
      const witnessSet = TransactionWitnessSet();
      const isValid = true;

      // When
      final envelopeCbor = await envelope.toCbor(serializer: (value) => value.toCbor());
      final auxiliaryData = AuxiliaryData.fromCbor(envelopeCbor);

      final rawTx = RawTransaction.from(
        body: body,
        witnessSet: witnessSet,
        isValid: isValid,
        auxiliaryData: auxiliaryData,
      );

      // Then
      void tryChangeInputs() {
        final range = rawTx.context[RawTransactionAspect.inputs]!;
        rawTx.bytes.replaceRange(range.start, range.end, List.filled(range.end - range.start, 0));
      }

      expect(
        tryChangeInputs,
        throwsA(isA<UnsupportedError>()),
        reason: 'Can not change data outside of RawTransaction',
      );
    });
  });
}

TransactionHash _buildDummyTransactionId(int seed) {
  final hex = List.filled(64, '$seed').join();
  return TransactionHash.fromHex(hex);
}

class _FakeBip32Ed25519XSignature extends Fake implements kd.Bip32Ed25519XSignature {
  @override
  final List<int> bytes;

  _FakeBip32Ed25519XSignature(this.bytes);

  @override
  CborValue toCbor() => CborBytes(bytes);
}

class _FakeCatalystCompressionPlatform extends CatalystCompressionPlatform {
  @override
  CatalystCompressor get brotli => const _FakeCompressor();

  @override
  CatalystCompressor get zstd => const _FakeCompressor();
}

final class _FakeCompressor implements CatalystCompressor {
  const _FakeCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async => bytes;

  @override
  Future<List<int>> decompress(List<int> bytes) async => bytes;
}
