// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

Future<void> main() async {
  await _coseSign1();
  await _coseSign();
}

Future<void> _coseSign1() async {
  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPairFromSeed(List.filled(32, 0));
  final publicKey = await keyPair.extractPublicKey().then((e) => e.bytes);

  Future<Uint8List> signer(Uint8List data) async {
    final signature = await algorithm.sign(data, keyPair: keyPair);
    return Uint8List.fromList(signature.bytes);
  }

  Future<bool> verifier(Uint8List data, Uint8List signature) async {
    return algorithm.verify(
      data,
      signature: Signature(
        signature,
        publicKey: SimplePublicKey(publicKey, type: KeyPairType.ed25519),
      ),
    );
  }

  final coseSign1 = await CoseSign1.sign(
    protectedHeaders: CoseHeaders.protected(
      alg: const IntValue(CoseValues.eddsaAlg),
      kid: hex.encode(publicKey),
    ),
    unprotectedHeaders: const CoseHeaders.unprotected(),
    signer: signer,
    payload: utf8.encode('This is the content.'),
  );

  final verified = await coseSign1.verify(
    verifier: verifier,
  );

  print('COSE_SIGN1:');
  print(hex.encode(cbor.encode(coseSign1.toCbor())));
  print('verified: $verified');

  assert(
    verified,
    'The signature proves that given COSE_SIGN1 structure has been '
    'signed by the owner of the given public key',
  );
}

Future<void> _coseSign() async {
  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPairFromSeed(List.filled(32, 0));
  final publicKey = await keyPair.extractPublicKey().then((e) => e.bytes);

  Future<Uint8List> signer(Uint8List data) async {
    final signature = await algorithm.sign(data, keyPair: keyPair);
    return Uint8List.fromList(signature.bytes);
  }

  Future<bool> verifier(Uint8List data, Uint8List signature) async {
    return algorithm.verify(
      data,
      signature: Signature(
        signature,
        publicKey: SimplePublicKey(publicKey, type: KeyPairType.ed25519),
      ),
    );
  }

  final coseSign = await CoseSign.sign(
    protectedHeaders: CoseHeaders.protected(
      alg: const IntValue(CoseValues.eddsaAlg),
      kid: hex.encode(publicKey),
    ),
    unprotectedHeaders: const CoseHeaders.unprotected(),
    signers: [signer],
    payload: utf8.encode('This is the content.'),
  );

  final verified = await coseSign.verify(
    verifiers: [verifier],
  );

  print('COSE_SIGN:');
  print(hex.encode(cbor.encode(coseSign.toCbor())));
  print('verified: $verified');

  assert(
    verified,
    'The signature proves that given COSE_SIGN structure has been '
    'signed by the owner of the given public key',
  );
}
