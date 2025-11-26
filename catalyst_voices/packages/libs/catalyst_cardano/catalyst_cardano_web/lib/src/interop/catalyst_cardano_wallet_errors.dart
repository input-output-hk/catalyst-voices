import 'dart:convert';

import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';

/// Creates a fallback exception from [ex].
WalletApiException fallbackApiException(Object ex) {
  final infoCode = _InfoCodeError.tryFrom(ex);
  if (infoCode != null) {
    return WalletApiException(
      code: WalletApiErrorCode.invalidRequest,
      info: infoCode.info,
      sourceCode: infoCode.code,
    );
  }

  return WalletApiException(
    code: WalletApiErrorCode.invalidRequest,
    info: ex.toString(),
  );
}

/// Creates a [WalletApiException] from [ex] or returns null when it was not possible.
WalletApiException? mapApiException(Object ex) {
  try {
    final error = _InfoCodeError.tryFrom(ex);
    return error?.toApiException();
  } catch (_) {
    return null;
  }
}

/// Creates a [WalletDataSignException] from [ex] or returns null when it was not possible.
WalletDataSignException? mapDataSignException(Object ex) {
  try {
    final error = _InfoCodeError.tryFrom(ex);
    return error?.toDataSignException();
  } catch (_) {
    return null;
  }
}

/// Creates a [WalletPaginateException] from [ex] or returns null when it was not possible.
WalletPaginateException? mapPaginateException(Object ex) {
  try {
    final error = _PaginateError.tryFrom(ex);
    return error?.toPaginateException();
  } catch (_) {
    return null;
  }
}

/// Creates a [TxSendException] from [ex] or returns null when it was not possible.
TxSendException? mapTxSendException(Object ex) {
  try {
    final error = _InfoCodeError.tryFrom(ex);
    return error?.toTxSendException();
  } catch (_) {
    return null;
  }
}

/// Creates a [TxSignException] from [ex] or returns null when it was not possible.
TxSignException? mapTxSignException(Object ex) {
  try {
    final error = _InfoCodeError.tryFrom(ex);
    return error?.toTxSignException();
  } catch (_) {
    return null;
  }
}

/// Matches the following errors:
///
/// - https://cips.cardano.org/cip/CIP-30#apierror
/// - https://cips.cardano.org/cip/CIP-30#datasignerror
/// - https://cips.cardano.org/cip/CIP-30#txsenderror
/// - https://cips.cardano.org/cip/CIP-30#txsignerror
final class _InfoCodeError {
  final int code;
  final String info;

  const _InfoCodeError({required this.code, required this.info});

  WalletApiException toApiException() {
    return WalletApiException(
      code: WalletApiErrorCode.fromTag(code),
      info: info,
    );
  }

  WalletDataSignException toDataSignException() {
    return WalletDataSignException(
      code: WalletDataSignErrorCode.fromTag(code),
      info: info,
    );
  }

  TxSendException toTxSendException() {
    return TxSendException(
      code: TxSendErrorCode.fromTag(code),
      info: info,
    );
  }

  TxSignException toTxSignException() {
    return TxSignException(
      code: TxSignErrorCode.fromTag(code),
      info: info,
    );
  }

  static _InfoCodeError? tryFrom(Object? object) {
    switch (object) {
      case final _InfoCodeError instance:
        return instance;
      case {'code': final int code, 'info': final String info}:
        return _InfoCodeError(code: code, info: info);
      case final String jsonString:
        try {
          final decoded = jsonDecode(jsonString);
          return tryFrom(decoded);
        } catch (_) {
          return null;
        }

      case null:
        return null;
      case _:
        // The JS error is converted into `JSValue` which we can't catch directly because
        // it's wasm internal type, instead convert it to a String which should be the json
        // and try to parse it.
        return tryFrom(object.toString());
    }
  }
}

/// Matches the following errors:
///
/// - https://cips.cardano.org/cip/CIP-30#paginateerror
final class _PaginateError {
  final int maxSize;

  const _PaginateError({required this.maxSize});

  WalletPaginateException toPaginateException() {
    return WalletPaginateException(maxSize: maxSize);
  }

  static _PaginateError? tryFrom(Object? object) {
    switch (object) {
      case final _PaginateError instance:
        return instance;
      case {'maxSize': final int maxSize}:
        return _PaginateError(maxSize: maxSize);
      case final String jsonString:
        try {
          final decoded = jsonDecode(jsonString);
          return tryFrom(decoded);
        } catch (_) {
          return null;
        }

      case null:
        return null;
      case _:
        // The JS error is converted into `JSValue` which we can't catch directly because
        // it's wasm internal type, instead convert it to a String which should be the json
        // and try to parse it.
        return tryFrom(object.toString());
    }
  }
}
