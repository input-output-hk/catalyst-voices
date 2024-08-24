import 'dart:typed_data';

import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/scripts.dart';
import 'package:catalyst_cardano_serialization/src/transaction_output.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:test/test.dart';

void main() {
  // Create test instances for reuse
  final address = ShelleyAddress.fromBech32(
    'addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
  );
  const value = Balance(coin: Coin(1000000));
  final datumHash = DatumHash(Uint8List.fromList([1, 2, 3, 4, 5, 6]));
  final datumData = Data(CborBytes(Uint8List.fromList([1, 2, 3, 4, 5, 6])));
  final datumOptionHash = DatumOption(datumHash);
  final datumOptionData = DatumOption(datumData);
  final script = PlutusV2Script(Uint8List.fromList([0x43, 0x01, 0x02, 0x03]));
  final scriptRef = ScriptRef(script);

  group('TransactionOutput encoding/decoding Tests', () {
    test('Shelley-Ma era transaction output', () {
      final output = TransactionOutput(address: address, amount: value);
      final cbor = output.toCbor();
      final decoded = TransactionOutput.fromCbor(cbor);
      expect(decoded, equals(output));
      expect(decoded.toCbor(), equals(cbor));
    });

    test('Alonzo era transaction output with datum hash', () {
      final output = PreBabbageTransactionOutput(
        address: address,
        amount: value,
        datumHash: datumHash,
      );
      final cbor = output.toCbor();
      final decoded = TransactionOutput.fromCbor(cbor);
      expect(decoded, equals(output));
      expect(decoded.toCbor(), equals(cbor));
    });

    test('Babbage era transaction output with datum option hash', () {
      final output = TransactionOutput(
        address: address,
        amount: value,
        datumOption: datumOptionHash,
      );
      final cbor = output.toCbor();
      final decoded = TransactionOutput.fromCbor(cbor);
      expect(decoded, equals(output));
      expect(decoded.toCbor(), equals(cbor));
    });

    test('Babbage era transaction output with datum option data', () {
      final output = TransactionOutput(
        address: address,
        amount: value,
        datumOption: datumOptionData,
      );
      final cbor = output.toCbor();
      final decoded = TransactionOutput.fromCbor(cbor);
      expect(decoded, equals(output));
      expect(decoded.toCbor(), equals(cbor));
    });

    test('Babbage era transaction output with datum option data and script ref',
        () {
      final output = TransactionOutput(
        address: address,
        amount: value,
        datumOption: datumOptionData,
        scriptRef: scriptRef,
      );
      final cbor = output.toCbor();
      final decoded = TransactionOutput.fromCbor(cbor);
      expect(decoded, equals(output));
      expect(decoded.toCbor(), equals(cbor));
    });

    test('Babbage era transaction output with datum option hash and script ref',
        () {
      final output = TransactionOutput(
        address: address,
        amount: value,
        datumOption: datumOptionHash,
        scriptRef: scriptRef,
      );
      final cbor = output.toCbor();
      final decoded = TransactionOutput.fromCbor(cbor);
      expect(decoded, equals(output));
      expect(decoded.toCbor(), equals(cbor));
    });

    test('Babbage era transaction output only with script ref', () {
      final output = TransactionOutput(
        address: address,
        amount: value,
        scriptRef: scriptRef,
      );
      final cbor = output.toCbor();
      final decoded = TransactionOutput.fromCbor(cbor);
      expect(decoded, equals(output));
      expect(decoded.toCbor(), equals(cbor));
    });
  });

  group('TransactionOutput minimal validation Tests', () {
    test('Invalid CBOR input throws error', () {
      final invalidCbor = CborList([const CborSmallInt(1)]);

      expect(
        () => TransactionOutput.fromCbor(invalidCbor),
        throwsArgumentError,
      );
    });

    test('Invalid datum option type throws error', () {
      final invalidCbor = CborList([
        const CborSmallInt(3), // Invalid type
        CborBytes([1, 2, 3]),
      ]);

      expect(
        () => DatumOption.fromCbor(invalidCbor),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Equality and hashcode', () {
      final output1 =
          PreBabbageTransactionOutput(address: address, amount: value);
      final output2 =
          PreBabbageTransactionOutput(address: address, amount: value);

      expect(output1, equals(output2));
      expect(output1.hashCode, equals(output2.hashCode));
    });

    test('CopyWith functionality', () {
      final original = TransactionOutput(
        address: address,
        amount: value,
        datumOption: datumOptionHash,
      );

      final modified = original.copyWith(
        datumOption: datumOptionData,
        scriptRef: scriptRef,
      );

      expect(modified.datumOption, equals(datumOptionData));
      expect(modified.scriptRef, equals(scriptRef));
      expect(modified.address, equals(address));
      expect(modified.amount, equals(value));
      expect(modified.datumOption, isNot(equals(datumOptionHash)));
    });
  });
}
