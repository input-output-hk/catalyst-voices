import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_repositories/src/common/http_headers.dart';
import 'package:catalyst_voices_repositories/src/common/rbac_token_ext.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:chopper/chopper.dart' as utils show applyHeader;
import 'package:chopper/chopper.dart' hide applyHeader;

final _logger = Logger('RbacAuthInterceptor');

/// Token specification:
/// https://github.com/input-output-hk/catalyst-voices/blob/main/docs/src/catalyst-standards/permissionless-auth/auth-header.md
///
/// - 401: The token is either invalidly formatted, or we don't know who that is
/// (likely they have not registered on chain).
/// - 403: The token is valid, we know who they are but either the timestamp is
/// wrong (out of date) or the signature is wrong.
final class RbacAuthInterceptor implements Interceptor {
  static const _retryCountHeaderName = 'Retry-Count';
  static const _retryStatusCodes = [401, 403];
  static const _maxRetries = 1;

  final AuthTokenProvider _authTokenProvider;

  const RbacAuthInterceptor(this._authTokenProvider);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    if (chain.request.headers[HttpHeaders.authorization] != null) {
      // token is already added
      return chain.proceed(chain.request);
    }

    final token = await _authTokenProvider.createRbacToken();
    if (token == null) {
      // keychain locked or not existing
      return chain.proceed(chain.request);
    }

    final updatedRequest = chain.request.applyAuthToken(token);
    final response = await chain.proceed(updatedRequest);

    if (_retryStatusCodes.contains(response.statusCode)) {
      final retryRequest = await _retryRequest(chain.request);
      if (retryRequest != null) {
        return await chain.proceed(retryRequest);
      }
    }

    return response;
  }

  Future<Request?> _retryRequest(Request request) async {
    try {
      final rawRetryCount = request.headers[_retryCountHeaderName];
      final retryCount = int.tryParse(rawRetryCount ?? '') ?? 0;
      if (retryCount >= _maxRetries) {
        _logger.severe('Giving up on ${request.uri} auth retry[$retryCount]');
        return null;
      }

      final newToken = await _authTokenProvider.createRbacToken(
        forceRefresh: true,
      );

      if (newToken == null) {
        throw StateError(
          'Could not create a new RBAC token, '
          'did the keychain become locked in the meantime?',
        );
      }

      return request
          .applyAuthToken(newToken)
          .applyHeader(name: _retryCountHeaderName, value: '${retryCount + 1}');
    } catch (error, stack) {
      _logger.severe('Re-authentication failed', error, stack);
      return null;
    }
  }
}

extension on Request {
  Request applyAuthToken(RbacToken token) {
    return applyHeader(
      name: RbacAuthInterceptor._authHeaderName,
      value: token.authHeader(),
    );
  }

  Request applyHeader({
    required String name,
    required String value,
  }) {
    return utils.applyHeader(this, name, value);
  }
}
