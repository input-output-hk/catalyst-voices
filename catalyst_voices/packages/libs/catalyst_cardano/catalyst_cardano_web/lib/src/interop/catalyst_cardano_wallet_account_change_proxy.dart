import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';

typedef _GetWalletApiCallback = Future<CardanoWalletApi> Function();
typedef _GetWalletCip95ApiCallback = Future<CardanoWalletCip95Api> Function();

/// A proxy to the [CardanoWallet] delegate which handles
/// the [WalletApiErrorCode.accountChange] error.
///
/// The implementation will catch the error once, re-enable the api and retry the request.
/// If that fails the error from the second request is returned.
final class CardanoWalletAccountChangeProxy implements CardanoWallet {
  final CardanoWallet _delegate;

  /// The default constructor for the [CardanoWalletAccountChangeProxy].
  const CardanoWalletAccountChangeProxy(this._delegate);

  @override
  String? get apiVersion => _delegate.apiVersion;

  @override
  String get icon => _delegate.icon;

  @override
  String get name => _delegate.name;

  @override
  List<CipExtension> get supportedExtensions => _delegate.supportedExtensions;

  @override
  Future<CardanoWalletApi> enable({List<CipExtension>? extensions}) async {
    final apiDelegate = await _delegate.enable(extensions: extensions);

    return _CardanoWalletApi(
      delegate: apiDelegate,
      onAccountChange: () => _delegate.enable(extensions: extensions),
    );
  }

  @override
  Future<bool> isEnabled() => _delegate.isEnabled();
}

final class _CardanoWalletApi implements CardanoWalletApi {
  final _GetWalletApiCallback _onAccountChange;
  CardanoWalletApi _delegate;

  _CardanoWalletApi({
    required _GetWalletApiCallback onAccountChange,
    required CardanoWalletApi delegate,
  }) : _onAccountChange = onAccountChange,
       _delegate = delegate;

  @override
  CardanoWalletCip95Api get cip95 => _CardanoWalletCip95Api(
    delegate: _delegate.cip95,
    onAccountChange: () async {
      _delegate = await _onAccountChange();
      return _delegate.cip95;
    },
  );

  @override
  Future<Balance> getBalance() {
    return _handleAccountChange((api) => api.getBalance());
  }

  @override
  Future<ShelleyAddress> getChangeAddress() {
    return _handleAccountChange((api) => api.getChangeAddress());
  }

  @override
  Future<List<CipExtension>> getExtensions() {
    return _handleAccountChange((api) => api.getExtensions());
  }

  @override
  Future<NetworkId> getNetworkId() {
    return _handleAccountChange((api) => api.getNetworkId());
  }

  @override
  Future<List<ShelleyAddress>> getRewardAddresses() {
    return _handleAccountChange((api) => api.getRewardAddresses());
  }

  @override
  Future<List<ShelleyAddress>> getUnusedAddresses() {
    return _handleAccountChange((api) => api.getUnusedAddresses());
  }

  @override
  Future<List<ShelleyAddress>> getUsedAddresses({Paginate? paginate}) {
    return _handleAccountChange((api) => api.getUsedAddresses(paginate: paginate));
  }

  @override
  Future<Set<TransactionUnspentOutput>> getUtxos({Balance? amount, Paginate? paginate}) {
    return _handleAccountChange(
      (api) => api.getUtxos(
        amount: amount,
        paginate: paginate,
      ),
    );
  }

  @override
  Future<DataSignature> signData({required ShelleyAddress address, required List<int> payload}) {
    return _handleAccountChange(
      (api) => api.signData(
        address: address,
        payload: payload,
      ),
    );
  }

  @override
  Future<TransactionWitnessSet> signTx({
    required BaseTransaction transaction,
    bool partialSign = false,
  }) {
    return _handleAccountChange(
      (api) => api.signTx(
        transaction: transaction,
        partialSign: partialSign,
      ),
    );
  }

  @override
  Future<TransactionHash> submitTx({required BaseTransaction transaction}) {
    return _handleAccountChange(
      (api) => api.submitTx(
        transaction: transaction,
      ),
    );
  }

  Future<T> _handleAccountChange<T>(Future<T> Function(CardanoWalletApi api) callback) async {
    try {
      return await callback(_delegate);
    } on WalletApiException catch (e) {
      if (e.code == WalletApiErrorCode.accountChange) {
        _delegate = await _onAccountChange();
        return callback(_delegate);
      }

      rethrow;
    }
  }
}

final class _CardanoWalletCip95Api implements CardanoWalletCip95Api {
  final _GetWalletCip95ApiCallback _onAccountChange;
  CardanoWalletCip95Api _delegate;

  _CardanoWalletCip95Api({
    required _GetWalletCip95ApiCallback onAccountChange,
    required CardanoWalletCip95Api delegate,
  }) : _onAccountChange = onAccountChange,
       _delegate = delegate;

  @override
  Future<PubDRepKey> getPubDRepKey() {
    return _handleAccountChange((api) => api.getPubDRepKey());
  }

  @override
  Future<List<PubStakeKey>> getRegisteredPubStakeKeys() {
    return _handleAccountChange((api) => api.getRegisteredPubStakeKeys());
  }

  @override
  Future<List<PubStakeKey>> getUnregisteredPubStakeKeys() {
    return _handleAccountChange((api) => api.getUnregisteredPubStakeKeys());
  }

  @override
  Future<VkeyWitness> signData({
    required (ShelleyAddress?, DRepID?) address,
    required List<int> payload,
  }) {
    return _handleAccountChange(
      (api) => api.signData(
        address: address,
        payload: payload,
      ),
    );
  }

  @override
  Future<TransactionWitnessSet> signTx({
    required BaseTransaction transaction,
    bool partialSign = false,
  }) {
    return _handleAccountChange(
      (api) => api.signTx(
        transaction: transaction,
        partialSign: partialSign,
      ),
    );
  }

  Future<T> _handleAccountChange<T>(Future<T> Function(CardanoWalletCip95Api api) callback) async {
    try {
      return await callback(_delegate);
    } on WalletApiException catch (e) {
      if (e.code == WalletApiErrorCode.accountChange) {
        _delegate = await _onAccountChange();
        return callback(_delegate);
      }

      rethrow;
    }
  }
}
