import 'dart:js_interop';

import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_web/src/interop/catalyst_cardano_interop.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';

/// A wrapper around [JSCardanoWallet] that translates between JS/dart layers.
class JSCardanoWalletProxy implements CardanoWallet {
  final JSCardanoWallet _delegate;

  /// The default constructor for [JSCardanoWalletProxy].
  JSCardanoWalletProxy(this._delegate);

  @override
  String get name => _delegate.name.toDart;

  @override
  String get icon => _delegate.icon.toDart;

  @override
  String get apiVersion => _delegate.apiVersion.toDart;

  @override
  List<CipExtension> get supportedExtensions =>
      _delegate.supportedExtensions.toDart.map((e) => e.toDart).toList();

  @override
  Future<bool> isEnabled() =>
      _delegate.isEnabled().toDart.then((e) => e.toDart);

  @override
  Future<CardanoWalletApi> enable() =>
      _delegate.enable().toDart.then((e) => e.toDart);
}

/// A wrapper around [JSCardanoWalletApi] that translates between JS/dart layers.
class JSCardanoWalletApiProxy implements CardanoWalletApi {
  final JSCardanoWalletApi _delegate;

  /// The default constructor for [JSCardanoWalletApiProxy].
  JSCardanoWalletApiProxy(this._delegate);

  @override
  Future<Coin> getBalance() async {
    final result = await _delegate.getBalance().toDart.then((e) => e.toDart);
    return Coin.fromCbor(cbor.decode(hex.decode(result)));
  }

  @override
  Future<List<CipExtension>> getExtensions() => _delegate
      .getExtensions()
      .toDart
      .then((array) => array.toDart.map((item) => item.toDart).toList());

  @override
  Future<NetworkId> getNetworkId() async {
    final result =
        await _delegate.getNetworkId().toDart.then((e) => e.toDartInt);
    return NetworkId.fromId(result);
  }

  @override
  Future<ShelleyAddress> getChangeAddress() => _delegate
      .getChangeAddress()
      .toDart
      .then((e) => ShelleyAddress(hex.decode(e.toDart)));

  @override
  Future<List<ShelleyAddress>> getRewardAddresses() {
    return _delegate.getRewardAddresses().toDart.then(
          (array) => array.toDart
              .map((item) => ShelleyAddress(hex.decode(item.toDart)))
              .toList(),
        );
  }

  @override
  Future<List<ShelleyAddress>> getUnusedAddresses() {
    return _delegate.getUnusedAddresses().toDart.then(
          (array) => array.toDart
              .map((item) => ShelleyAddress(hex.decode(item.toDart)))
              .toList(),
        );
  }

  @override
  Future<List<ShelleyAddress>> getUsedAddresses({Paginate? paginate}) {
    final jsPaginate = paginate != null ? JSPaginate.fromDart(paginate) : null;

    return _delegate.getUsedAddresses(jsPaginate).toDart.then(
          (array) => array.toDart
              .map((item) => ShelleyAddress(hex.decode(item.toDart)))
              .toList(),
        );
  }

  @override
  Future<List<TransactionUnspentOutput>> getUtxos({
    Coin? amount,
    Paginate? paginate,
  }) {
    return _delegate
        .getUtxos(
          amount?.value.toJS,
          paginate != null ? JSPaginate.fromDart(paginate) : null,
        )
        .toDart
        .then(
          (array) => array.toDart
              .map(
                (item) => TransactionUnspentOutput.fromCbor(
                  cbor.decode(hex.decode(item.toDart)),
                ),
              )
              .toList(),
        );
  }

  @override
  Future<TransactionWitnessSet> signTx({
    required Transaction transaction,
    bool partialSign = false,
  }) {
    final bytes = cbor.encode(transaction.toCbor());
    final hexString = hex.encode(bytes);

    return _delegate.signTx(hexString.toJS, partialSign.toJS).toDart.then(
          (e) => TransactionWitnessSet.fromCbor(
            cbor.decode(hex.decode(e.toDart)),
          ),
        );
  }

  @override
  Future<TransactionHash> submitTx({required Transaction transaction}) async {
    final bytes = cbor.encode(transaction.toCbor());
    final hexString = hex.encode(bytes);
    final result = await _delegate.submitTx(hexString.toJS).toDart;
    return TransactionHash.fromHex(result.toDart);
  }
}
