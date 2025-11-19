// ignore_for_file: only_throw_errors

import 'dart:js_interop';

import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_web/src/interop/catalyst_cardano_interop.dart';
import 'package:catalyst_cardano_web/src/interop/catalyst_cardano_wallet_errors.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';

/// The minimal set of wallet extensions that
/// must be supported by every wallet extension.
const _fallbackExtensions = [CipExtension(cip: 30)];

/// Error message in exception thrown when trying
/// to execute a method which doesn't exist in JS layer.
///
/// Notably some wallet extensions decided not to implement
/// some method even if they are required by the CIP-30 standard.
///
/// Checking for this error messages allows to detect unimplemented method.
const _noSuchMethodError = 'NoSuchMethodError';

/// A wrapper around [JSCardanoWalletApi] that translates between JS/dart layers.
class JSCardanoWalletApiProxy implements CardanoWalletApi {
  final JSCardanoWalletApi _delegate;

  /// The default constructor for [JSCardanoWalletApiProxy].
  JSCardanoWalletApiProxy(this._delegate);

  @override
  CardanoWalletCip95Api get cip95 {
    try {
      return JSCardanoWalletCip95ApiProxy(_delegate.cip95);
    } catch (ex) {
      throw fallbackApiException(ex);
    }
  }

  @override
  Future<Balance> getBalance() async {
    try {
      final result = await _delegate.getBalance().toDart.then((e) => e.toDart);
      return Balance.fromCbor(cbor.decode(hexDecode(result)));
    } catch (ex) {
      throw mapApiException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<ShelleyAddress> getChangeAddress() async {
    try {
      return await _delegate.getChangeAddress().toDart.then(
        (e) => ShelleyAddress(hexDecode(e.toDart)),
      );
    } catch (ex) {
      throw mapApiException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<List<CipExtension>> getExtensions() async {
    try {
      return await _delegate.getExtensions().toDart.then(
        (array) => array.toDart.map((item) => item.toDart).toList(),
      );
    } catch (ex) {
      if (ex.toString().contains(_noSuchMethodError)) {
        return _fallbackExtensions;
      }

      throw mapApiException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<NetworkId> getNetworkId() async {
    try {
      final result = await _delegate.getNetworkId().toDart.then((e) => e.toDartInt);
      return NetworkId.fromId(result);
    } catch (ex) {
      throw mapApiException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<List<ShelleyAddress>> getRewardAddresses() async {
    try {
      return await _delegate.getRewardAddresses().toDart.then(
        (array) => array.toDart.map((item) => ShelleyAddress(hexDecode(item.toDart))).toList(),
      );
    } catch (ex) {
      throw mapApiException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<List<ShelleyAddress>> getUnusedAddresses() async {
    try {
      return await _delegate.getUnusedAddresses().toDart.then(
        (array) => array.toDart.map((item) => ShelleyAddress(hexDecode(item.toDart))).toList(),
      );
    } catch (ex) {
      throw mapApiException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<List<ShelleyAddress>> getUsedAddresses({Paginate? paginate}) async {
    try {
      return await _delegate
          .getUsedAddresses(paginate != null ? JSPaginate.fromDart(paginate) : null)
          .toDart
          .then(
            (array) => array.toDart.map((item) => ShelleyAddress(hexDecode(item.toDart))).toList(),
          );
    } catch (ex) {
      throw mapApiException(ex) ?? mapPaginateException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<Set<TransactionUnspentOutput>> getUtxos({
    Balance? amount,
    Paginate? paginate,
  }) async {
    try {
      final promise = _delegate.getUtxos(
        amount != null ? hex.encode(cbor.encode(amount.toCbor())).toJS : null,
        paginate != null ? JSPaginate.fromDart(paginate) : null,
      );

      if (promise == null) return const {};

      return await promise.toDart.then(
        (array) => array.toDart
            .map(
              (item) => TransactionUnspentOutput.fromCbor(
                cbor.decode(hexDecode(item.toDart)),
              ),
            )
            .toSet(),
      );
    } catch (ex) {
      throw mapApiException(ex) ?? mapPaginateException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<DataSignature> signData({
    required ShelleyAddress address,
    required List<int> payload,
  }) async {
    try {
      return await _delegate
          .signData(
            address.toBech32().toJS,
            hex.encode(payload).toJS,
          )
          .toDart
          .then((e) => e.toDart);
    } catch (ex) {
      throw mapApiException(ex) ?? mapDataSignException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<TransactionWitnessSet> signTx({
    required BaseTransaction transaction,
    bool partialSign = false,
  }) async {
    try {
      final bytes = transaction.bytes;
      final hexString = hex.encode(bytes);

      return await _delegate
          .signTx(hexString.toJS, partialSign.toJS)
          .toDart
          .then(
            (e) => TransactionWitnessSet.fromCbor(
              cbor.decode(hexDecode(e.toDart)),
            ),
          );
    } catch (ex) {
      throw mapApiException(ex) ?? mapTxSignException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<TransactionHash> submitTx({required BaseTransaction transaction}) async {
    try {
      final bytes = transaction.bytes;
      final hexString = hex.encode(bytes);
      final result = await _delegate.submitTx(hexString.toJS).toDart;
      return TransactionHash.fromHex(result.toDart);
    } catch (ex) {
      throw mapApiException(ex) ?? mapTxSendException(ex) ?? fallbackApiException(ex);
    }
  }
}

/// A wrapper around [JSCardanoWalletCip95Api] that translates between JS/dart layers.
class JSCardanoWalletCip95ApiProxy implements CardanoWalletCip95Api {
  final JSCardanoWalletCip95Api _delegate;

  /// The default constructor for [JSCardanoWalletCip95ApiProxy].
  JSCardanoWalletCip95ApiProxy(this._delegate);

  @override
  Future<PubDRepKey> getPubDRepKey() async {
    try {
      final result = await _delegate.getPubDRepKey().toDart.then((e) => e.toDart);
      return PubDRepKey(result);
    } catch (ex) {
      throw mapApiException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<List<PubStakeKey>> getRegisteredPubStakeKeys() async {
    try {
      return await _delegate.getRegisteredPubStakeKeys().toDart.then(
        (jsArray) => jsArray.toDart.map((key) => PubStakeKey(key.toDart)).toList(),
      );
    } catch (ex) {
      throw mapApiException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<List<PubStakeKey>> getUnregisteredPubStakeKeys() async {
    try {
      return await _delegate.getUnregisteredPubStakeKeys().toDart.then(
        (jsArray) => jsArray.toDart.map((key) => PubStakeKey(key.toDart)).toList(),
      );
    } catch (ex) {
      throw mapApiException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<VkeyWitness> signData({
    required (ShelleyAddress?, DRepID?) address,
    required List<int> payload,
  }) async {
    final String cborAddress;
    final shelleyAddress = address.$1;
    final dRepID = address.$2;

    if (shelleyAddress != null) {
      cborAddress = hex.encode(cbor.encode(shelleyAddress.toCbor()));
    } else if (dRepID != null) {
      cborAddress = hex.encode(cbor.encode(dRepID.toCbor()));
    } else {
      throw const WalletApiException(
        code: WalletApiErrorCode.invalidRequest,
        info: 'Either address or DRepId must be provided',
      );
    }

    try {
      return await _delegate
          .signData(
            cborAddress.toJS,
            hex.encode(payload).toJS,
          )
          .toDart
          .then((e) => VkeyWitness.fromCbor(cbor.decode(hexDecode(e.toDart))));
    } catch (ex) {
      throw mapApiException(ex) ?? mapDataSignException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<TransactionWitnessSet> signTx({
    required BaseTransaction transaction,
    bool partialSign = false,
  }) async {
    try {
      final bytes = transaction.bytes;
      final hexString = hex.encode(bytes);

      return await _delegate
          .signTx(hexString.toJS, partialSign.toJS)
          .toDart
          .then(
            (e) => TransactionWitnessSet.fromCbor(
              cbor.decode(hexDecode(e.toDart)),
            ),
          );
    } catch (ex) {
      throw mapApiException(ex) ?? mapTxSignException(ex) ?? fallbackApiException(ex);
    }
  }
}

/// A wrapper around [JSCardanoWallet] that translates between JS/dart layers.
class JSCardanoWalletProxy implements CardanoWallet {
  final JSCardanoWallet _delegate;

  /// The default constructor for [JSCardanoWalletProxy].
  JSCardanoWalletProxy(this._delegate);

  @override
  String? get apiVersion => _delegate.apiVersion?.toDart;

  @override
  String get icon => _delegate.icon.toDart;

  @override
  String get name => _delegate.name.toDart;

  @override
  List<CipExtension> get supportedExtensions =>
      _delegate.supportedExtensions?.toDart.map((e) => e.toDart).toList() ?? _fallbackExtensions;

  @override
  Future<CardanoWalletApi> enable({List<CipExtension>? extensions}) async {
    try {
      final jsExtensions = extensions != null ? JSCipExtensions.fromDart(extensions) : null;

      return await _delegate.enable(jsExtensions).toDart.then((e) => e.toDart);
    } catch (ex) {
      throw mapApiException(ex) ?? fallbackApiException(ex);
    }
  }

  @override
  Future<bool> isEnabled() async {
    try {
      return await _delegate.isEnabled().toDart.then((e) => e.toDart);
    } catch (ex) {
      throw mapApiException(ex) ?? fallbackApiException(ex);
    }
  }
}
