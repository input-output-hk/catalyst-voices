import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';
import 'package:equatable/equatable.dart';

/// {@template cardano_wallet_exception}
/// A base class for all exceptions related to the Cardano wallet functionality.
/// {@endtemplate}
abstract base class CardanoWalletException extends Equatable implements Exception {
  /// {@macro cardano_wallet_exception}
  const CardanoWalletException();
}

/// A specific error code related to the [TxSendException].
enum TxSendErrorCode {
  /// Wallet refuses to send the tx (could be rate limiting).
  refused(tag: 1),

  /// Wallet could not send the tx.
  failure(tag: 2);

  /// The error code number.
  final int tag;

  const TxSendErrorCode({required this.tag});

  /// Maps a [tag] to the [TxSendErrorCode].
  static TxSendErrorCode fromTag(int tag) {
    return values.firstWhere(
      (e) => e.tag == tag,
      orElse: () => throw UnsupportedError('TxSendErrorCode: unsupported tag $tag'),
    );
  }
}

/// Exception thrown when submitting the transaction fails.
final class TxSendException extends CardanoWalletException {
  /// A more specific failure reason.
  final TxSendErrorCode code;

  /// The human readable info about the exception.
  final String info;

  /// The default constructor for [TxSendException].
  const TxSendException({
    required this.code,
    required this.info,
  });

  @override
  List<Object?> get props => [code, info];

  @override
  String toString() => 'TxSendException(code=$code,info=$info)';
}

/// A specific error code related to the [TxSignException].
enum TxSignErrorCode {
  ///  User has accepted the transaction sign,
  /// but the wallet was unable to sign the transaction
  /// (e.g. not having some of the private keys).
  proofGeneration(tag: 1),

  /// User declined to sign the transaction.
  userDeclined(tag: 2),

  /// Returned regardless of user consent
  /// if the transaction contains a depreciated certificate.
  depreciatedCertificate(tag: 3);

  /// The error code number.
  final int tag;

  const TxSignErrorCode({required this.tag});

  /// Maps a [tag] to the [TxSignErrorCode].
  static TxSignErrorCode fromTag(int tag) {
    return values.firstWhere(
      (e) => e.tag == tag,
      orElse: () => throw UnsupportedError('TxSignErrorCode: unsupported tag $tag'),
    );
  }
}

/// Exception thrown when signing the transaction fails.
final class TxSignException extends CardanoWalletException {
  /// A more specific failure reason.
  final TxSignErrorCode code;

  /// The human readable info about the exception.
  final String info;

  /// The default constructor for [TxSignException].
  const TxSignException({
    required this.code,
    required this.info,
  });

  @override
  List<Object?> get props => [code, info];

  @override
  String toString() => 'TxSignException(code=$code,info=$info)';
}

/// A specific error code related to the [WalletApiException].
enum WalletApiErrorCode {
  /// Inputs do not conform to this spec or are otherwise invalid.
  invalidRequest(tag: -1),

  /// An error occurred during execution of this API call.
  internalError(tag: -2),

  /// The request was refused due to lack of access - e.g. wallet disconnects.
  refused(tag: -3),

  /// The account has changed. The dApp should call wallet.enable()
  /// to reestablish connection to the new account. The wallet should not ask
  /// for confirmation as the user was the one who initiated the account change
  /// in the first place.
  accountChange(tag: -4);

  /// The error code number.
  final int tag;

  const WalletApiErrorCode({required this.tag});

  /// Maps a [tag] to the [WalletApiErrorCode].
  static WalletApiErrorCode fromTag(int tag) {
    return values.firstWhere(
      (e) => e.tag == tag,
      orElse: () => throw UnsupportedError('WalletApiErrorCode: unsupported tag $tag'),
    );
  }
}

/// Defines a set of possible exceptions that might occur when
/// interacting with the wallet extension api.
final class WalletApiException extends CardanoWalletException {
  /// A more specific failure reason.
  final WalletApiErrorCode code;

  /// The human readable info about the exception.
  final String info;

  /// The optional code which may have caused exception in first place.
  /// For example when wallet used unsupported tag code.
  final int? sourceCode;

  /// The default constructor for [WalletApiException].
  const WalletApiException({
    required this.code,
    required this.info,
    this.sourceCode,
  });

  @override
  List<Object?> get props => [code, info, sourceCode];

  @override
  String toString() => sourceCode == null
      ? 'WalletApiException(code=$code,info=$info)'
      : 'WalletApiException(code=$code,info=$info,sourceCode=$sourceCode)';
}

/// A specific error code related to the [WalletDataSignException].
enum WalletDataSignErrorCode {
  /// Wallet could not sign the data; because the wallet does not
  ///  have the secret key to the associated with the address or DRep ID.
  proofGeneration(tag: 1),

  /// Address was not a P2PK address and thus had no SK associated with it.
  addressNotPk(tag: 2),

  /// User declined to sign the data
  userDeclined(tag: 3);

  /// The error code number.
  final int tag;

  const WalletDataSignErrorCode({required this.tag});

  /// Maps a [tag] to the [WalletDataSignErrorCode].
  static WalletDataSignErrorCode fromTag(int tag) {
    return values.firstWhere(
      (e) => e.tag == tag,
      orElse: () => throw UnsupportedError('WalletDataSignErrorCode: unsupported tag $tag'),
    );
  }
}

/// Defines a set of possible exceptions that might occur when
/// calling the [CardanoWalletApi.signData] method.
final class WalletDataSignException extends CardanoWalletException {
  /// A more specific failure reason.
  final WalletDataSignErrorCode code;

  /// The human readable info about the exception.
  final String info;

  /// The default constructor for [WalletDataSignException].
  const WalletDataSignException({
    required this.code,
    required this.info,
  });

  @override
  List<Object?> get props => [code, info];

  @override
  String toString() => 'WalletDataSignException(code=$code,info=$info)';
}

/// [maxSize] is the maximum size for pagination and if the dApp
/// tries to request pages outside of this boundary this error is thrown.
final class WalletPaginateException extends CardanoWalletException {
  /// The maximum allowed value of the [Paginate.page].
  final int maxSize;

  /// The default constructor for [WalletPaginateException].
  const WalletPaginateException({required this.maxSize});

  @override
  List<Object?> get props => [maxSize];

  @override
  String toString() => 'WalletPaginateException(maxSize=$maxSize)';
}
