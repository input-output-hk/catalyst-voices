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
  final signerVerifier = _SignerVerifier(algorithm, keyPair);

  final coseSign1 = await CoseSign1.sign(
    protectedHeaders: const CoseHeaders.protected(),
    unprotectedHeaders: const CoseHeaders.unprotected(),
    signer: signerVerifier,
    payload: utf8.encode('This is the content.'),
  );

  final verified = await coseSign1.verify(
    verifier: signerVerifier,
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
  final signerVerifier = _SignerVerifier(algorithm, keyPair);

  final coseSign = await CoseSign.sign(
    protectedHeaders: const CoseHeaders.protected(),
    unprotectedHeaders: const CoseHeaders.unprotected(),
    signers: [signerVerifier],
    payload: utf8.encode('This is the content.'),
  );

  final verified = await coseSign.verifyAll(
    verifiers: [signerVerifier],
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

final class _SignerVerifier
    implements CatalystCoseSigner, CatalystCoseVerifier {
  final SignatureAlgorithm _algorithm;
  final SimpleKeyPair _keyPair;

  const _SignerVerifier(this._algorithm, this._keyPair);

  @override
  StringOrInt? get alg => const IntValue(CoseValues.eddsaAlg);

  @override
  Future<String?> get kid async {
    final pk = await _keyPair.extractPublicKey();
    return hex.encode(pk.bytes);
  }

  @override
  Future<Uint8List> sign(Uint8List data) async {
    final signature = await _algorithm.sign(data, keyPair: _keyPair);
    return Uint8List.fromList(signature.bytes);
  }

  @override
  Future<bool> verify(Uint8List data, Uint8List signature) async {
    final publicKey = await _keyPair.extractPublicKey();
    return _algorithm.verify(
      data,
      signature: Signature(
        signature,
        publicKey: SimplePublicKey(publicKey.bytes, type: KeyPairType.ed25519),
      ),
    );
  }
}
