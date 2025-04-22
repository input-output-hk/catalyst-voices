import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.swagger.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/api/api_services.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/user/account_status_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/user/user_dto.dart';
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

  Future<TransactionHash> getPreviousRegistrationTransactionId({
    required CatalystId catalystId,
  });

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
    final body =
        await _apiServices.reviews.apiCatalystIdsMeGet().successBodyOrThrow();
    return body.status!.toModel();
  }

  @override
  Future<TransactionHash> getPreviousRegistrationTransactionId({
    required CatalystId catalystId,
  }) async {
    final lookup = catalystId.toSignificant().toUri().toStringWithoutScheme();

    final rbacChain = await _apiServices.gateway
        .apiV1RbacRegistrationGet(lookup: lookup)
        .successBodyOrThrow();

    final transactionId =
        rbacChain.lastVolatileTxn ?? rbacChain.lastPersistentTxn;

    if (transactionId == null) {
      throw ArgumentError.notNull('transactionId');
    }

    return TransactionHash.fromHex(transactionId);
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
    await _apiServices.reviews
        .apiCatalystIdsMePost(
          body: CatalystIDCreate(
            catalystIdUri: catalystId.toUri().toStringWithoutScheme(),
            email: email,
          ),
        )
        .successBodyOrThrow();
  }

  @override
  Future<RecoveredAccount> recoverAccount({
    required CatalystId catalystId,
    required String rbacToken,
  }) async {
    final tokenProvider = _HardcodedAuthTokenProvider(token: rbacToken);
    // TODO(dtscalac): enable when endpoint works correctly
    // final rbacRegistration =
    //     await _recoverRbacRegistration(catalystId, tokenProvider);
    final publicId = await _recoverCatalystIDPublic(tokenProvider);

    return RecoveredAccount(
      username: publicId?.username as String?,
      email: publicId?.email as String?,
      // TODO(dtscalac): enable when endpoint works correctly
      // roles: rbacRegistration.accountRoles,
      // stakeAddress: rbacRegistration.stakeAddress,
      roles: const {AccountRole.voter, AccountRole.proposer},
      stakeAddress: ShelleyAddress.fromBech32(
        /* cSpell:disable */
        'addr_test1vzpwq95z3xyum8vqndgdd'
        '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
        /* cSpell:enable */
      ),
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
    try {
      final reviews = ApiServices.createReviews(
        reviewsUrl: _apiServices.reviews.client.baseUrl,
        authTokenProvider: tokenProvider,
      );

      return await reviews.apiCatalystIdsMeGet().successBodyOrThrow();
    } on NotFoundException {
      // nothing to recover
      return null;
    }
  }

  // TODO(dtscalac): enable when endpoint works correctly
  // ignore: unused_element
  Future<RbacRegistrationChain> _recoverRbacRegistration(
    CatalystId catalystId,
    AuthTokenProvider tokenProvider,
  ) async {
    final gateway = ApiServices.createGateway(
      gatewayUri: _apiServices.gateway.client.baseUrl,
      authTokenProvider: tokenProvider,
    );

    return gateway
        .apiV1RbacRegistrationGet(
          lookup: catalystId.toUri().toStringWithoutScheme(),
        )
        .successBodyOrThrow();
  }
}

class _HardcodedAuthTokenProvider implements AuthTokenProvider {
  final String token;

  const _HardcodedAuthTokenProvider({required this.token});

  @override
  Future<String?> createRbacToken({bool forceRefresh = false}) async => token;
}
