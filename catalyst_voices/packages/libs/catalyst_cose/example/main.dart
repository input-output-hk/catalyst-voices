// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

Future<void> main() async {
  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPairFromSeed(List.filled(32, 0));
  final publicKey = await keyPair.extractPublicKey().then((e) => e.bytes);

  final payload = utf8.encode('This is the content.');

  final coseSign1 = await CatalystCose.sign1(
    payload: payload,
    kid: CborBytes(publicKey),
    signer: (data) async {
      final signature = await algorithm.sign(data, keyPair: keyPair);
      return Uint8List.fromList(signature.bytes);
    },
  );

  final verified = await CatalystCose.verifyCoseSign1(
    coseSign1: coseSign1,
    verifier: (data, signature) {
      return algorithm.verify(
        data,
        signature: Signature(
          signature,
          publicKey: SimplePublicKey(publicKey, type: KeyPairType.ed25519),
        ),
      );
    },
  );

  print('COSE_SIGN1:');
  print(hex.encode(cbor.encode(coseSign1)));
  print('verified: $verified');

  assert(
    verified,
    'The signature proves that given COSE_SIGN1 structure has been '
    'signed by the owner of the given public key',
  );
}
