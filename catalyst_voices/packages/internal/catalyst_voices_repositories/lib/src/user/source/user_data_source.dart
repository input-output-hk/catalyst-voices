import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/api/api_services.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final class ApiUserDataSource implements UserDataSource {
  final ApiServices _apiServices;

  const ApiUserDataSource(this._apiServices);

  @override
  Future<RecoveredAccount> recoverAccount({
    required CatalystId catalystId,
    required String rbacToken,
  }) async {
    final tokenProvider = _HardcodedAuthTokenProvider(token: rbacToken);
    final publicId = await _recoverCatalystIDPublic(tokenProvider);
    final rbacRegistration =
        await _recoverRbacRegistration(catalystId, tokenProvider);

    return RecoveredAccount(
      username: publicId?.username as String?,
      email: publicId?.email as String?,
      roles: rbacRegistration.roles
          as Set<AccountRole>, // TODO(dtscalac): extract roles
      stakeAddress: rbacRegistration.roles
          as ShelleyAddress, // TODO(dtscalac): extract stake address
    );
  }

  @override
  Future<void> updateEmail(String email) async {
    // TODO(dtscalac): reimplement the endpoint with custom
    // rbac token where catalystId is built with username in it.
    // The reviews module stores the username from the token's
    // catalyst ID and later on allows to recover it in recoverAccount.
    final response = await _apiServices.reviews
        .apiCatalystIdsMePost(body: CatalystIDCreate(email: email));

    response.verifyIsSuccessful();
  }

  Future<CatalystIDPublic?> _recoverCatalystIDPublic(
    AuthTokenProvider tokenProvider,
  ) async {
    final reviews = ApiServices.createReviews(
      reviewsUrl: _apiServices.reviews.client.baseUrl,
      authTokenProvider: tokenProvider,
    );

    final response = await reviews.apiCatalystIdsMeGet();

    if (response.statusCode == ApiErrorResponseException.notFound) {
      // nothing to recover
      return null;
    }
    response.verifyIsSuccessful();

    return response.bodyOrThrow;
  }

  Future<RbacRegistrationChain> _recoverRbacRegistration(
    CatalystId catalystId,
    AuthTokenProvider tokenProvider,
  ) async {
    final gateway = ApiServices.createGateway(
      gatewayUri: _apiServices.gateway.client.baseUrl,
      authTokenProvider: tokenProvider,
    );

    final response = await gateway.apiV1RbacRegistrationGet(
      lookup: catalystId.toUri().toStringWithoutScheme(),
    );

    if (response.statusCode == ApiErrorResponseException.notFound) {
      throw NotFoundException(
        message: 'Registration for $catalystId not found',
      );
    }

    response.verifyIsSuccessful();

    return response.bodyOrThrow;
  }
}

// ignore: one_member_abstracts
abstract interface class UserDataSource {
  Future<RecoveredAccount> recoverAccount({
    required CatalystId catalystId,
    required String rbacToken,
  });

  Future<void> updateEmail(String email);
}

class _HardcodedAuthTokenProvider implements AuthTokenProvider {
  final String token;

  const _HardcodedAuthTokenProvider({required this.token});

  @override
  Future<String?> createRbacToken({bool forceRefresh = false}) async => token;
}
