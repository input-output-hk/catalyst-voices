import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.swagger.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/api/api_services.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/user_dto.dart';
import 'package:catalyst_voices_repositories/src/user/source/user_storage.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class UserRepository {
  factory UserRepository(
    UserStorage storage,
    KeychainProvider keychainProvider,
    ApiServices apiServices,
  ) {
    return UserRepositoryImpl(
      storage,
      keychainProvider,
      apiServices,
    );
  }

  Future<AccountStatus> getAccountStatus();

  Future<User> getUser();

  Future<void> publishUserProfile({
    required CatalystId catalystId,
    required String email,
  });

  Future<RecoveredAccount> recoverAccount({
    required CatalystId catalystId,
    required String rbacToken,
  });

  Future<void> saveUser(User user);
}

final class UserRepositoryImpl implements UserRepository {
  final UserStorage _storage;
  final KeychainProvider _keychainProvider;
  final ApiServices _apiServices;

  UserRepositoryImpl(
    this._storage,
    this._keychainProvider,
    this._apiServices,
  );

  @override
  Future<AccountStatus> getAccountStatus() async {
    final response = await _apiServices.reviews.apiCatalystIdsMeGet();
    response.verifyIsSuccessful();
    final body = response.bodyOrThrow;
    return body.status!.toModel();
  }

  @override
  Future<User> getUser() async {
    final dto = await _storage.readUser();
    final user = await dto?.toModel(keychainProvider: _keychainProvider);
    return user ?? const User.empty();
  }

  @override
  Future<void> publishUserProfile({
    required CatalystId catalystId,
    required String email,
  }) async {
    final response = await _apiServices.reviews.apiCatalystIdsMePost(
      body: CatalystIDCreate(
        catalystIdUri: catalystId.toUri().toStringWithoutScheme(),
        email: email,
      ),
    );

    response.verifyIsSuccessful();
  }

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
  Future<void> saveUser(User user) {
    final dto = UserDto.fromModel(user);

    return _storage.writeUser(dto);
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

    response.verifyIsSuccessful();

    return response.bodyOrThrow;
  }
}

class _HardcodedAuthTokenProvider implements AuthTokenProvider {
  final String token;

  const _HardcodedAuthTokenProvider({required this.token});

  @override
  Future<String?> createRbacToken({bool forceRefresh = false}) async => token;
}
