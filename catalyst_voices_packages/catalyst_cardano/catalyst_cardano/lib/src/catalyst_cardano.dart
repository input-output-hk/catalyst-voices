import 'dart:typed_data';

import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';

/// A Flutter plugin wrapping the Cardano Multiplatform Lib.
class CatalystCardano {
  /// The default instance of [CatalystCardano] to use.
  static final CatalystCardano instance = CatalystCardano._();

  CatalystCardano._();

  /// Encodes [bytes] as metadatum, function to be removed later by providing
  /// actual implementations of methods related to cardano multiplatform lib.
  Future<void> encodeArbitraryBytesAsMetadatum(Uint8List bytes) async {
    await CatalystCardanoPlatform.instance
        .encodeArbitraryBytesAsMetadatum(bytes);
  }

  /// Initializer method to boostrap internals of Cardano Multiplatform Lib.
  ///
  /// Must be called and awaited exactly once before any
  /// additional interaction with the lib.
  Future<void> init() async {
    await CatalystCardanoPlatform.instance.init();
  }
}
