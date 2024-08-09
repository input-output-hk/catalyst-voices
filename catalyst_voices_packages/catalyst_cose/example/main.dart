// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

Future<void> main() async {
  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPairFromSeed(List.filled(32, 0));
  final privateKey = await keyPair.extractPrivateKeyBytes();
  final publicKey = await keyPair.extractPublicKey().then((e) => e.bytes);

  final payload = utf8.encode('This is the content.');

  final coseSign1 = await CatalystCose.sign1(
    privateKey: privateKey,
    payload: payload,
    kid: CborBytes(publicKey),
  );

  final verified = await CatalystCose.verifyCoseSign1(
    coseSign1: coseSign1,
    publicKey: publicKey,
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
