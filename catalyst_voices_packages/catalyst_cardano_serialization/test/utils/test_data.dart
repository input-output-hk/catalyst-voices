import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';

/* cSpell:disable */
final mainnetAddr = ShelleyAddress.fromBech32(
  'addr1qx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3n0d3vllmyqws'
  'x5wktcd8cc3sq835lu7drv2xwl2wywfgse35a3x',
);
final testnetAddr = ShelleyAddress.fromBech32(
  'addr_test1vz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzerspjrlsz',
);
final mainnetStakeAddr = ShelleyAddress.fromBech32(
  'stake1uyehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gh6ffgw',
);
final testnetStakeAddr = ShelleyAddress.fromBech32(
  'stake_test1uqehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gssrtvn',
);

final testTransactionHash = TransactionHash.fromHex(
  '583a3a5150bc7990656020ffb4e5a1be'
  '1589ce6f1a430aacb8e7e089b894d3d1',
);

/// Returns a minimal transaction with optional fields skipped.
Transaction minimalTestTransaction() {
  return Transaction(
    body: TransactionBody(
      inputs: {
        TransactionInput(
          transactionId: testTransactionHash,
          index: 1,
        ),
      },
      outputs: [
        TransactionOutput(
          address: testnetAddr,
          amount: const Coin(5000000),
        ),
      ],
      fee: const Coin(10000000),
    ),
    isValid: true,
  );
}

/// Returns a full transaction with all possible optional fields.
Transaction fullTestTransaction() {
  final auxiliaryData = AuxiliaryData(
    map: {
      const CborSmallInt(1): CborString('Test'),
    },
  );

  return Transaction(
    body: TransactionBody(
      inputs: {
        TransactionInput(
          transactionId: testTransactionHash,
          index: 1,
        ),
      },
      outputs: [
        TransactionOutput(
          address: testnetAddr,
          amount: const Coin(5000000),
        ),
      ],
      fee: const Coin(10000000),
      ttl: const SlotBigNum(41001),
      auxiliaryDataHash: AuxiliaryDataHash.fromAuxiliaryData(auxiliaryData),
      networkId: NetworkId.testnet,
    ),
    isValid: true,
    auxiliaryData: auxiliaryData,
  );
}

/* cSpell:enable */
