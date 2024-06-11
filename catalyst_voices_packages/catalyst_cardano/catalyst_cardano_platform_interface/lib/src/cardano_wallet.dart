import 'package:catalyst_cardano_platform_interface/src/exceptions.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';

/// A cardano wallet extension that has been injected
/// into the browser's cardano.{walletName} object.
///
/// There might be multiple available wallet extensions but typically
/// the user will interact with only one extension at a time.
///
/// Use [name] and [icon] to display a list of extensions to the user
/// and call [enable] after the user decides with which wallet they want
/// to interact.
abstract interface class CardanoWallet {
  /// A name for the wallet which can be used inside of the dApp
  /// for the purpose of asking the user which wallet they would like
  /// to connect with.
  String get name;

  /// A URI image (e.g. data URI base64 or other) for img src for the wallet
  /// which can be used inside of the dApp for the purpose of asking the user
  /// which wallet they would like to connect with.
  String get icon;

  /// The version number of the API that the wallet supports.
  String get apiVersion;

  /// A list of extensions supported by the wallet.
  ///
  /// Extensions may be requested by dApps on initialization.
  /// Some extensions may be mutually conflicting and this list does not
  /// thereby reflect what extensions will be enabled by the wallet.
  /// Yet it informs on what extensions are known and can be
  /// requested by dApps if needed.
  List<CipExtension> get supportedExtensions;

  /// Returns true if the dApp is already connected to the user's wallet,
  /// or if requesting access would return true without user confirmation
  /// (e.g. the dApp is whitelisted), and false otherwise.
  ///
  /// If this function returns true, then any subsequent calls to
  /// wallet.enable() during the current session should succeed
  /// and return the API object.
  Future<bool> isEnabled();

  /// This is the entrypoint to start communication with the user's wallet.
  ///
  /// The wallet should request the user's permission to connect the web page
  /// to the user's wallet, and if permission has been granted, the full API
  /// will be returned to the dApp to use. The wallet can choose to maintain
  /// a whitelist to not necessarily ask the user's permission every time access
  /// is requested, but this behavior is up to the wallet and should be
  /// transparent to web pages using this API. If a wallet is already connected
  /// this function should not request access a second time, and instead just
  /// return the API object.
  Future<CardanoWalletApi> enable({List<CipExtension>? extensions});
}

/// The full API of enabled wallet extension.
abstract interface class CardanoWalletApi {
  /// Returns the total balance available of the wallet.
  ///
  /// This is the same as summing the results of [getUtxos],
  /// but it is both useful to dApps and likely already maintained by the
  /// implementing wallet in a more efficient manner so it has been included
  /// in the API as well.
  Future<Balance> getBalance();

  /// Retrieves the list of extensions enabled by the wallet.
  ///
  /// This may be influenced by the set of extensions requested
  /// in the initial enable request.
  Future<List<CipExtension>> getExtensions();

  /// Returns the network id of the currently connected account.
  ///
  /// 0 is testnet and 1 is mainnet but other networks can possibly
  /// be returned by wallets.
  ///
  /// Those other network ID values are not governed by this document.
  /// This result will stay the same unless the connected account has changed.
  Future<NetworkId> getNetworkId();

  /// Returns an address owned by the wallet that should be used
  /// as a change address to return leftover assets during transaction
  /// creation back to the connected wallet.
  ///
  /// This can be used as a generic receive address as well.
  Future<ShelleyAddress> getChangeAddress();

  /// Returns the reward addresses owned by the wallet.
  ///
  /// This can return multiple addresses e.g. CIP-0018.
  Future<List<ShelleyAddress>> getRewardAddresses();

  /// Returns a list of unused addresses controlled by the wallet.
  Future<List<ShelleyAddress>> getUnusedAddresses();

  /// Returns a list of all used (included in some on-chain transaction)
  /// addresses controlled by the wallet.
  ///
  /// The results can be further paginated by [paginate] if it is not undefined
  Future<List<ShelleyAddress>> getUsedAddresses({Paginate? paginate});

  /// If [amount] is null, this shall return a list of all UTXOs
  /// (unspent transaction outputs) controlled by the wallet.
  ///
  /// If [amount] is not null, this request shall be limited to just the UTXOs
  /// that are required to reach the combined ADA/multiasset value target
  /// specified in amount, and if this cannot be attained,
  /// null shall be returned. The results can be further paginated by
  /// [paginate] if it is not null.
  Future<List<TransactionUnspentOutput>> getUtxos({
    Coin? amount,
    Paginate? paginate,
  });

  /// This endpoint utilizes the CIP-0008 signing spec for
  /// standardization/safety reasons. It allows the dApp to request the user
  /// to sign a payload conforming to said spec. The user's consent should be
  /// requested and the message to sign shown to the user. The payment key
  /// from [address] will be used for base, enterprise and pointer addresses to
  /// determine the EdDSA25519 key used. The staking key will be used for
  /// reward addresses.
  ///
  /// Throws [WalletDataSignException].
  Future<VkeyWitness> signData({
    required ShelleyAddress address,
    required List<int> payload,
  });

  /// Requests that a user sign the unsigned portions
  /// of the supplied transaction.
  ///
  /// The wallet should ask the user for permission, and if given, try to sign
  /// the supplied body and return a signed transaction. If [partialSign] is
  /// true, the wallet only tries to sign what it can. If [partialSign] is false
  /// and the wallet could not sign the entire transaction, [TxSignException]
  /// shall be returned with the ProofGeneration code.
  ///
  /// Likewise if the user declined in either case it shall return the
  /// UserDeclined code. Only the portions of the witness set that were signed
  /// as a result of this call are returned to encourage dApps to verify the
  /// contents returned by this endpoint while building the final transaction.
  Future<TransactionWitnessSet> signTx({
    required Transaction transaction,
    bool partialSign = false,
  });

  /// As wallets should already have this ability, we allow dApps to request
  /// that a transaction be sent through it.
  ///
  /// If the wallet accepts the transaction and tries to send it,
  /// it shall return the transaction id for the dApp to track.
  ///
  /// The wallet is free to return the [TxSendException] with code Refused
  /// if they do not wish to send it, or Failure if there was an error
  /// in sending it (e.g. preliminary checks failed on signatures).
  Future<TransactionHash> submitTx({
    required Transaction transaction,
  });
}

/// Defines the [cip] extension version.
final class CipExtension {
  /// The version of the CIP extension.
  final int cip;

  /// The default constructor for [CipExtension].
  const CipExtension({
    required this.cip,
  });
}

/// Defines the pagination constraints when querying data.
///
/// Instead of fetching the whole data-set at once,
/// the data can be queried in batches.
final class Paginate {
  /// The batch index.
  ///
  /// Starts counting from 0.
  final int page;

  /// The batch size per [page].
  final int limit;

  /// The default constructor for [Paginate].
  const Paginate({
    required this.page,
    required this.limit,
  });
}
