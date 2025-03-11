import 'dart:typed_data';

import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';

/// A factory that builds specific types for private/public keys.
abstract interface class CatalystKeyFactory {
  CatalystPrivateKey createPrivateKey(Uint8List bytes);

  CatalystPublicKey createPublicKey(Uint8List bytes);

  CatalystSignature createSignature(Uint8List bytes);
}
