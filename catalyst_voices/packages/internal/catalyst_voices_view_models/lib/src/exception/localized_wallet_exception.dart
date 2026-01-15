import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

abstract base class LocalizedWalletException extends LocalizedException {
  const LocalizedWalletException();

  factory LocalizedWalletException.from(CardanoWalletException exception) {
    if (exception is TxSendException) return _LocalizedWalletTxSendException(exception);
    if (exception is TxSignException) return _LocalizedWalletTxSignException(exception);
    if (exception is WalletApiException) return _LocalizedWalletLinkException(exception);
    if (exception is WalletDataSignException) return _LocalizeWalletDataSignException(exception);
    if (exception is WalletPaginateException) return _LocalizeWalletPaginateException(exception);

    return const _LocalizedWalletUnknownException();
  }
}

final class _LocalizedWalletLinkException extends LocalizedWalletException {
  final WalletApiErrorCode code;
  final String info;
  final int? sourceCode;

  _LocalizedWalletLinkException(WalletApiException source)
    : code = source.code,
      info = source.info,
      sourceCode = source.sourceCode;

  @override
  String message(BuildContext context) {
    return switch (code) {
      WalletApiErrorCode.invalidRequest when sourceCode != null =>
        context.l10n.errorWalletLinkInvalidRequestCode(sourceCode!),
      WalletApiErrorCode.invalidRequest => context.l10n.errorWalletLinkInvalidRequest,
      WalletApiErrorCode.internalError => context.l10n.errorWalletLinkInternalError,
      WalletApiErrorCode.refused => context.l10n.errorWalletLinkRefused,
      WalletApiErrorCode.accountChange => context.l10n.errorWalletLinkAccountChange,
    };
  }

  @override
  String toString() => 'LocalizedWalletLinkException(code=$code,info=$info)';
}

final class _LocalizedWalletTxSendException extends LocalizedWalletException {
  final TxSendErrorCode code;
  final String info;

  _LocalizedWalletTxSendException(TxSendException source) : code = source.code, info = source.info;

  @override
  String message(BuildContext context) {
    return switch (code) {
      TxSendErrorCode.refused => context.l10n.errorWalletTxSendRefused,
      TxSendErrorCode.failure => context.l10n.errorWalletTxSendFailure,
    };
  }

  @override
  String toString() => 'LocalizedWalletTxSendException(code=$code,info=$info)';
}

final class _LocalizedWalletTxSignException extends LocalizedWalletException {
  final TxSignErrorCode code;
  final String info;

  _LocalizedWalletTxSignException(TxSignException source) : code = source.code, info = source.info;

  @override
  String message(BuildContext context) {
    return switch (code) {
      TxSignErrorCode.proofGeneration => context.l10n.errorWalletTxSignProofGeneration,
      TxSignErrorCode.userDeclined => context.l10n.errorWalletTxSignUserDeclined,
      TxSignErrorCode.depreciatedCertificate =>
        context.l10n.errorWalletTxSignDepreciatedCertificate,
    };
  }

  @override
  String toString() => 'LocalizedWalletTxSignException(code=$code,info=$info)';
}

final class _LocalizedWalletUnknownException extends LocalizedWalletException {
  const _LocalizedWalletUnknownException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorCardanoWalletUnknown;
  }
}

final class _LocalizeWalletDataSignException extends LocalizedWalletException {
  final WalletDataSignErrorCode code;
  final String info;

  _LocalizeWalletDataSignException(WalletDataSignException source)
    : code = source.code,
      info = source.info;

  @override
  String message(BuildContext context) {
    return switch (code) {
      WalletDataSignErrorCode.proofGeneration => context.l10n.errorWalletDataSignProofGeneration,
      WalletDataSignErrorCode.addressNotPk => context.l10n.errorWalletDataSignAddressNotPk,
      WalletDataSignErrorCode.userDeclined => context.l10n.errorWalletDataSignUserDeclined,
    };
  }

  @override
  String toString() => 'LocalizedWalletDataSignException(code=$code,info=$info)';
}

final class _LocalizeWalletPaginateException extends LocalizedWalletException {
  final int maxSize;

  _LocalizeWalletPaginateException(WalletPaginateException source) : maxSize = source.maxSize;

  @override
  String message(BuildContext context) {
    return context.l10n.errorWalletPaginationMaxSize(maxSize);
  }

  @override
  String toString() => 'LocalizeWalletPaginateException(maxSize=$maxSize)';
}
