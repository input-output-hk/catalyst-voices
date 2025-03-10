// ignore_for_file: one_member_abstracts

import 'dart:typed_data';

import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';

/// A factory that builds specific types for private keys.
abstract interface class CatalystPrivateKeyFactory {
  CatalystPrivateKey createPrivateKey(Uint8List bytes);
}

/// A factory that builds specific types for public keys.
abstract interface class CatalystPublicKeyFactory {
  CatalystPublicKey createPublicKey(Uint8List bytes);
}

/// A factory that builds specific types for signatures.
abstract interface class CatalystSignatureFactory {
  CatalystSignature createSignature(Uint8List bytes);
}
