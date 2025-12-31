import 'dart:async';

import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_repositories/src/common/http_headers.dart';
import 'package:catalyst_voices_repositories/src/common/rbac_token_ext.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

final _logger = Logger('RbacAuthInterceptor');

/// Token specification:
/// https://github.com/input-output-hk/catalyst-voices/blob/main/docs/src/catalyst-standards/permissionless-auth/auth-header.md
///
/// - 401: The token is either invalidly formatted, or we don't know who that is
/// (likely they have not registered on chain).
/// - 403: The token is valid, we know who they are but either the timestamp is
/// wrong (out of date) or the signature is wrong.
final class RbacAuthInterceptor extends Interceptor {
  @visibleForTesting
  static const retryCountExtra = 'Rbac-Retry-Count';
  @visibleForTesting
  static const interceptorAuthExtra = 'Rbac-Interceptor-Auth';
  static const _retryStatusCodes = [401, 403];
  static const _maxRetries = 1;

  final AuthTokenProvider _authTokenProvider;

  const RbacAuthInterceptor(this._authTokenProvider);

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    if (statusCode == null || !_retryStatusCodes.contains(statusCode)) {
      handler.next(err);
      return;
    }

    final options = err.requestOptions;

    // If authorization came from different source. eg direct token lookup, don't try to
    // force token from _authTokenProvider as it may be locked or null.
    if (!options.extra.containsKey(interceptorAuthExtra)) {
      handler.next(err);
      return;
    }

    final rawRetryCount = options.extra[retryCountExtra];
    final retryCount = int.tryParse(rawRetryCount?.toString() ?? '') ?? 0;
    if (retryCount >= _maxRetries) {
      _logger.severe('Giving up on ${options.uri} auth retry[$retryCount]');
      return handler.next(err);
    }

    try {
      final newToken = await _authTokenProvider.createRbacToken(forceRefresh: true);
      if (newToken == null) {
        throw StateError(
          'Could not create a new RBAC token, '
          'did the keychain become locked in the meantime?',
        );
      }

      options.headers[HttpHeaders.authorization] = newToken.authHeader();
      options.extra[retryCountExtra] = '${retryCount + 1}';

      final response = await Dio().fetch<dynamic>(options);
      return handler.resolve(response);
    } catch (error, stack) {
      _logger.severe('Re-authentication failed', error, stack);
      return handler.next(err);
    }
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.headers[HttpHeaders.authorization] != null) {
      // token is already added
      return handler.next(options);
    }

    final token = await _authTokenProvider.createRbacToken();
    if (token == null) {
      // keychain locked or not existing
      return handler.next(options);
    }

    options.headers[HttpHeaders.authorization] = token.authHeader();
    options.extra[interceptorAuthExtra] = true;

    handler.next(options);
  }
}
