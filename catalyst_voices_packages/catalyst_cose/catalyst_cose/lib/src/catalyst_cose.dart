import 'package:catalyst_cose_platform_interface/catalyst_cose_platform_interface.dart';
import 'package:cbor/cbor.dart';

/// A Flutter plugin implementing CBOR Object Signing and Encryption (RFC 8152).
class CatalystCose {
  /// The default instance of [CatalystCose] to use.
  static final CatalystCose instance = CatalystCose._();

  CatalystCose._();

  /// Signs the [message] and returns a [CborValue] representing
  /// a COSE signature.
  Future<CborValue> signMessage(List<int> message) {
    return CatalystCosePlatform.instance.signMessage(message);
  }
}
