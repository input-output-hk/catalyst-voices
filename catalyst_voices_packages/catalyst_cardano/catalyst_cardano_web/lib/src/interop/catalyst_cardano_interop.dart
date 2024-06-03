@JS('catalyst_cardano')
library catalyst_cardano_interop;

import 'dart:js_interop';

import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';
import 'package:catalyst_cardano_web/src/interop/catalyst_cardano_wallet_proxy.dart';

/// Lists all injected Cardano wallet extensions that are reachable
/// via window.cardano.{walletName} in javascript.
@JS()
external JSArray<JSCardanoWallet> getWallets();

/// The JS representation of the [CardanoWallet].
extension type JSCardanoWallet(JSObject _) implements JSObject {
  /// See [CardanoWallet.name].
  external JSString get name;

  /// See [CardanoWallet.icon].
  external JSString get icon;

  /// See [CardanoWallet.apiVersion].
  external JSString get apiVersion;

  /// See [CardanoWallet.supportedExtensions].
  external JSArray<JSCipExtension> get supportedExtensions;

  /// See [CardanoWallet.isEnabled].
  external JSPromise<JSBoolean> isEnabled();

  /// See [CardanoWallet.enable].
  external JSPromise<JSCardanoWalletApi> enable([
    JSCipExtensions? extensions,
  ]);

  /// Converts JS representation to pure dart representation.
  CardanoWallet get toDart => JSCardanoWalletProxy(this);
}

/// The JS representation of the [CardanoWalletApi].
extension type JSCardanoWalletApi(JSObject _) implements JSObject {
  /// See [CardanoWalletApi.getBalance].
  external JSPromise<JSString> getBalance();

  /// See [CardanoWalletApi.getExtensions].
  external JSPromise<JSArray<JSCipExtension>> getExtensions();

  /// See [CardanoWalletApi.getNetworkId].
  external JSPromise<JSNumber> getNetworkId();

  /// See [CardanoWalletApi.getChangeAddress].
  external JSPromise<JSString> getChangeAddress();

  /// See [CardanoWalletApi.getRewardAddresses].
  external JSPromise<JSArray<JSString>> getRewardAddresses();

  /// See [CardanoWalletApi.getUnusedAddresses].
  external JSPromise<JSArray<JSString>> getUnusedAddresses();

  /// See [CardanoWalletApi.getUsedAddresses].
  external JSPromise<JSArray<JSString>> getUsedAddresses([
    JSPaginate? paginate,
  ]);

  /// See [CardanoWalletApi.getUtxos].
  external JSPromise<JSArray<JSString>> getUtxos([
    JSNumber? amount,
    JSPaginate? paginate,
  ]);

  /// See [CardanoWalletApi.signData].
  external JSPromise<JSString> signData(
    JSString address,
    JSString payload,
  );

  /// See [CardanoWalletApi.signTx].
  external JSPromise<JSString> signTx(
    JSString tx, [
    JSBoolean? partialSign,
  ]);

  /// See [CardanoWalletApi.submitTx].
  external JSPromise<JSString> submitTx(JSString tx);

  /// Converts JS representation to pure dart representation.
  CardanoWalletApi get toDart => JSCardanoWalletApiProxy(this);
}

/// Represents wallet extensions to be activated in [JSCardanoWallet.enable].
extension type JSCipExtensions._(JSObject _) implements JSObject {
  /// An array of extensions.
  external JSArray<JSCipExtension> get extensions;

  /// The default constructor for [JSCipExtensions].
  external factory JSCipExtensions({JSArray<JSCipExtension> extensions});

  /// Constructs [JSCipExtensions] from dart representation.
  factory JSCipExtensions.fromDart(List<CipExtension> extensions) {
    return JSCipExtensions(
      extensions: extensions.map(JSCipExtension.fromDart).toList().toJS,
    );
  }

  /// Converts JS representation to pure dart representation.
  List<CipExtension> get toDart =>
      extensions.toDart.map((e) => e.toDart).toList();
}

/// The JS representation of the [CipExtension].
extension type JSCipExtension._(JSObject _) implements JSObject {
  /// See [JSCipExtension.cip].
  external JSNumber get cip;

  /// The default constructor for [JSCipExtension].
  external factory JSCipExtension({JSNumber cip});

  /// Constructs [JSCipExtension] from dart representation.
  factory JSCipExtension.fromDart(CipExtension extension) {
    return JSCipExtension(cip: extension.cip.toJS);
  }

  /// Converts JS representation to pure dart representation.
  CipExtension get toDart => CipExtension(cip: cip.toDartInt);
}

/// The JS representation of the [Paginate].
extension type JSPaginate._(JSObject _) implements JSObject {
  /// The default constructor for [JSPaginate].
  external factory JSPaginate({JSNumber page, JSNumber limit});

  /// Constructs [JSPaginate] from dart representation.
  factory JSPaginate.fromDart(Paginate paginate) {
    return JSPaginate(
      page: paginate.page.toJS,
      limit: paginate.limit.toJS,
    );
  }

  /// See [JSPaginate.page].
  external JSNumber get page;

  /// See [JSPaginate.limit].
  external JSNumber get limit;
}
