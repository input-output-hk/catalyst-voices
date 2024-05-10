import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';

void main() {
  group(Transaction, () {
    test('transaction with all supported fields serialized to bytes', () {
      final auxiliaryData = AuxiliaryData(
        map: {
          const CborSmallInt(1): CborString('Test'),
        },
      );

      final tx = Transaction(
        body: TransactionBody(
          inputs: {
            TransactionInput(
              transactionId: TransactionHash.fromHex(
                '583a3a5150bc7990656020ffb4e5a1be'
                '1589ce6f1a430aacb8e7e089b894d3d1',
              ),
              index: 1,
            ),
          },
          outputs: [
            TransactionOutput(
              address: ShelleyAddress.fromBech32(
                'addr_test1qr3z9jna2wxcs7gp59tmjlhp9tu2ldh27t24g9krfz6k'
                '2mkyf379rcw5luptsjavwrum45xz3gvdnwlp244qnmf2hrgsgsxvgh',
              ),
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

      final bytes = cbor.encode(tx.toCbor());
      final hexString = hex.encode(bytes);

      expect(
        hexString,
        equals(
          '84a40081825820583a3a5150bc7990656020ffb4e5a1be1589ce6f1a430aacb8e7e0'
          '89b894d3d101018182583900e222ca7d538d887901a157b97ee12af8afb6eaf2d554'
          '16c348b5656ec44c7c51e1d4ff02b84bac70f9bad0c28a18d9bbe1556a09ed2ab8d1'
          '1a004c4b40021a009896800319a029a0f5a1016454657374',
        ),
      );
    });

    test('transaction with required fields serialized to bytes', () {
      final tx = Transaction(
        body: TransactionBody(
          inputs: {
            TransactionInput(
              transactionId: TransactionHash.fromHex(
                '583a3a5150bc7990656020ffb4e5a1be'
                '1589ce6f1a430aacb8e7e089b894d3d1',
              ),
              index: 1,
            ),
          },
          outputs: [
            TransactionOutput(
              address: ShelleyAddress.fromBech32(
                'addr_test1qr3z9jna2wxcs7gp59tmjlhp9tu2ldh27t24g9krfz6k'
                '2mkyf379rcw5luptsjavwrum45xz3gvdnwlp244qnmf2hrgsgsxvgh',
              ),
              amount: const Coin(5000000),
            ),
          ],
          fee: const Coin(10000000),
        ),
        isValid: true,
      );

      final bytes = cbor.encode(tx.toCbor());
      final hexString = hex.encode(bytes);

      expect(
        hexString,
        equals(
          '84a30081825820583a3a5150bc7990656020ffb4e5a1be1589ce6f1a430aacb8e7e0'
          '89b894d3d101018182583900e222ca7d538d887901a157b97ee12af8afb6eaf2d554'
          '16c348b5656ec44c7c51e1d4ff02b84bac70f9bad0c28a18d9bbe1556a09ed2ab8d1'
          '1a004c4b40021a00989680a0f5d90103a0',
        ),
      );
    });
  });
}
