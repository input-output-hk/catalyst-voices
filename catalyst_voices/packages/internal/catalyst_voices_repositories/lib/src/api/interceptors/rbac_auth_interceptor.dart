import 'dart:async';

import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
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

  final UserObserver _userObserver;
  final AuthTokenProvider _authTokenProvider;

  const RbacAuthInterceptor(
    this._userObserver,
    this._authTokenProvider,
  );

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final keychain = _userObserver.user.activeAccount?.keychain;
    final isUnlocked = await keychain?.isUnlocked ?? false;

    if (!isUnlocked) {
      return chain.proceed(chain.request);
    }

    final token = await _authTokenProvider.createRbacToken();
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
      if (retryCount > 0) {
        _logger.severe('Giving up on ${request.uri} auth retry[$retryCount]');
        return null;
      }

      final newToken = await _authTokenProvider.createRbacToken(
        forceRefresh: true,
      );

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
  Request applyAuthToken(String value) {
    return applyHeader(
      name: 'Authorization',
      value: 'Bearer $value',
    );
  }

  Request applyHeader({
    required String name,
    required String value,
  }) {
    return utils.applyHeader(this, name, value);
  }
}
