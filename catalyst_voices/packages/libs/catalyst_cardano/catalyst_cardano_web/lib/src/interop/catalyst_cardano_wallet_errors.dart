import 'dart:convert';

import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';

/// Creates a fallback exception from [ex].
WalletApiException fallbackApiException(Object ex) {
  throw WalletApiException(
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

  factory _InfoCodeError.fromJson(Map<String, dynamic> json) {
    return _InfoCodeError(
      code: json['code'] as int,
      info: json['info'] as String,
    );
  }

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

  static _InfoCodeError? tryFrom(Object object) {
    try {
      if (object is _InfoCodeError) {
        return object;
      } else if (object is String) {
        final json = jsonDecode(object) as Map<String, dynamic>;
        return _InfoCodeError.fromJson(json);
      } else if (object is Map<String, dynamic>) {
        return _InfoCodeError.fromJson(object);
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}

/// Matches the following errors:
///
/// - https://cips.cardano.org/cip/CIP-30#paginateerror
final class _PaginateError {
  final int maxSize;

  const _PaginateError({required this.maxSize});

  factory _PaginateError.fromJson(Map<String, dynamic> json) {
    return _PaginateError(
      maxSize: json['maxSize'] as int,
    );
  }

  WalletPaginateException toPaginateException() {
    return WalletPaginateException(maxSize: maxSize);
  }

  static _PaginateError? tryFrom(Object object) {
    try {
      if (object is _PaginateError) {
        return object;
      } else if (object is String) {
        final json = jsonDecode(object) as Map<String, dynamic>;
        return _PaginateError.fromJson(json);
      } else if (object is Map<String, dynamic>) {
        return _PaginateError.fromJson(object);
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}
