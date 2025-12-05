@JS('catalyst_cardano')
library catalyst_cardano_interop;

import 'dart:js_interop';

import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';
import 'package:catalyst_cardano_web/src/interop/catalyst_cardano_wallet_js_to_dart_proxy.dart';

/// Lists all injected Cardano wallet extensions that are reachable
/// via window.cardano.{walletName} in javascript.
@JS()
external JSArray<JSCardanoWallet> getWallets();

/// The JS representation of the [CardanoWallet].
extension type JSCardanoWallet(JSObject _) implements JSObject {
  /// See [CardanoWallet.apiVersion].
  external JSString? get apiVersion;

  /// See [CardanoWallet.icon].
  external JSString get icon;

  /// See [CardanoWallet.name].
  external JSString get name;

  /// See [CardanoWallet.supportedExtensions].
  external JSArray<JSCipExtension>? get supportedExtensions;

  /// Converts JS representation to pure dart representation.
  CardanoWallet get toDart => JSCardanoWalletProxy(this);

  /// See [CardanoWallet.enable].
  external JSPromise<JSCardanoWalletApi> enable([
    JSCipExtensions? extensions,
  ]);

  /// See [CardanoWallet.isEnabled].
  external JSPromise<JSBoolean> isEnabled();
}

/// The JS representation of the [CardanoWalletApi].
extension type JSCardanoWalletApi(JSObject _) implements JSObject {
  /// See [CardanoWalletApi.cip95].
  external JSCardanoWalletCip95Api get cip95;

  /// Converts JS representation to pure dart representation.
  CardanoWalletApi get toDart => JSCardanoWalletApiProxy(this);

  /// See [CardanoWalletApi.getBalance].
  external JSPromise<JSString> getBalance();

  /// See [CardanoWalletApi.getChangeAddress].
  external JSPromise<JSString> getChangeAddress();

  /// See [CardanoWalletApi.getExtensions].
  external JSPromise<JSArray<JSCipExtension>> getExtensions();

  /// See [CardanoWalletApi.getNetworkId].
  external JSPromise<JSNumber> getNetworkId();

  /// See [CardanoWalletApi.getRewardAddresses].
  external JSPromise<JSArray<JSString>> getRewardAddresses();

  /// See [CardanoWalletApi.getUnusedAddresses].
  external JSPromise<JSArray<JSString>> getUnusedAddresses();

  /// See [CardanoWalletApi.getUsedAddresses].
  external JSPromise<JSArray<JSString>> getUsedAddresses([
    JSAny? paginate,
  ]);

  /// See [CardanoWalletApi.getUtxos].
  external JSPromise<JSArray<JSString>>? getUtxos([
    JSAny? amount,
    JSAny? paginate,
  ]);

  /// See [CardanoWalletApi.signData].
  external JSPromise<JSDataSignature> signData(
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
}

/// The JS representation of the [CardanoWalletCip95Api].
extension type JSCardanoWalletCip95Api(JSObject _) implements JSObject {
  /// Converts JS representation to pure dart representation.
  CardanoWalletCip95Api get toDart => JSCardanoWalletCip95ApiProxy(this);

  /// See [CardanoWalletCip95Api.getPubDRepKey].
  external JSPromise<JSString> getPubDRepKey();

  /// See [CardanoWalletCip95Api.getRegisteredPubStakeKeys].
  external JSPromise<JSArray<JSString>> getRegisteredPubStakeKeys();

  /// See [CardanoWalletCip95Api.getUnregisteredPubStakeKeys].
  external JSPromise<JSArray<JSString>> getUnregisteredPubStakeKeys();

  /// See [CardanoWalletCip95Api.signData].
  external JSPromise<JSString> signData(
    JSString address,
    JSString payload,
  );

  /// See [CardanoWalletCip95Api.signTx].
  external JSPromise<JSString> signTx(
    JSString tx, [
    JSBoolean? partialSign,
  ]);
}

/// The JS representation of the [CipExtension].
extension type JSCipExtension._(JSObject _) implements JSObject {
  /// The default constructor for [JSCipExtension].
  external factory JSCipExtension({JSNumber cip});

  /// Constructs [JSCipExtension] from dart representation.
  factory JSCipExtension.fromDart(CipExtension extension) {
    return JSCipExtension(cip: extension.cip.toJS);
  }

  /// See [JSCipExtension.cip].
  external JSNumber get cip;

  /// Converts JS representation to pure dart representation.
  CipExtension get toDart => CipExtension(cip: cip.toDartInt);
}

/// Represents wallet extensions to be activated in [JSCardanoWallet.enable].
extension type JSCipExtensions._(JSObject _) implements JSObject {
  /// The default constructor for [JSCipExtensions].
  external factory JSCipExtensions({JSArray<JSCipExtension> extensions});

  /// Constructs [JSCipExtensions] from dart representation.
  factory JSCipExtensions.fromDart(List<CipExtension> extensions) {
    return JSCipExtensions(
      extensions: extensions.map(JSCipExtension.fromDart).toList().toJS,
    );
  }

  /// An array of extensions.
  external JSArray<JSCipExtension> get extensions;

  /// Converts JS representation to pure dart representation.
  List<CipExtension> get toDart => extensions.toDart.map((e) => e.toDart).toList();
}

/// The JS representation of the [DataSignature].
extension type JSDataSignature._(JSObject _) implements JSObject {
  /// The default constructor for [JSDataSignature].
  external factory JSDataSignature({JSString key, JSString signature});

  /// See [DataSignature.key].
  external JSString get key;

  /// See [DataSignature.signature].
  external JSString get signature;

  /// Converts JS representation to pure dart representation.
  DataSignature get toDart => DataSignature(
    key: key.toDart,
    signature: signature.toDart,
  );
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

  /// See [JSPaginate.limit].
  external JSNumber get limit;

  /// See [JSPaginate.page].
  external JSNumber get page;
}
