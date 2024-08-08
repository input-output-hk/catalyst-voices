import 'dart:js_interop';

import 'package:catalyst_cose_platform_interface/catalyst_cose_platform_interface.dart';
import 'package:catalyst_cose_web/src/interop/catalyst_cose_interop.dart'
    as interop;
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show Registrar;

/// The web implementation of [CatalystCosePlatform].
///
/// This class implements the `package:catalyst_cose` functionality
/// for the web.
class CatalystCoseWeb extends CatalystCosePlatform {
  /// A constructor that allows tests to override the window object used by the
  /// plugin.
  CatalystCoseWeb();

  /// Registers this class as the default instance of
  /// [CatalystCosePlatform].
  static void registerWith(Registrar registrar) {
    CatalystCosePlatform.instance = CatalystCoseWeb();
  }

  @override
  Future<CborValue> signMessage(List<int> message) {
    return interop
        .signMessage(hex.encode(message).toJS)
        .toDart
        .then((e) => cbor.decode(hex.decode(e.toDart)));
  }
}
