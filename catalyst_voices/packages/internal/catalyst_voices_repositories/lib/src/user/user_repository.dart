import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.swagger.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/api/api_services.dart';
import 'package:catalyst_voices_repositories/src/common/rbac_token_ext.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/user/reviews_catalyst_id_status_ext.dart';
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

  Future<AccountPublicStatus> getAccountPublicStatus();

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
    required RbacToken rbacToken,
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
  Future<AccountPublicStatus> getAccountPublicStatus() {
    return _getReviewsCatalystIDPublic()
        .then((value) => value?.status?.toModel())
        .then((value) => value ?? AccountPublicStatus.notSetup);
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
    required RbacToken rbacToken,
  }) async {
    // TODO(dtscalac): enable when endpoint works correctly
    // final rbacRegistration =
    //     await _recoverRbacRegistration(catalystId, rbacToken);
    final publicId = await _getReviewsCatalystIDPublic(token: rbacToken);

    return RecoveredAccount(
      // TODO(damian-molinski): check latest document and see if there is username.
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
      publicStatus: publicId?.status?.toModel() ?? AccountPublicStatus.notSetup,
    );
  }

  @override
  Future<void> saveUser(User user) {
    final dto = UserDto.fromModel(user);

    return _storage.writeUser(dto);
  }

  /// Looks up reviews module and receives status for active
  /// account of [token] is not specified.
  Future<CatalystIDPublic?> _getReviewsCatalystIDPublic({
    RbacToken? token,
  }) {
    return _apiServices.reviews
        .apiCatalystIdsMeGet(authorization: token?.authHeader())
        .successBodyOrThrow()
        .then<CatalystIDPublic?>((value) => value)
        .onError<NotFoundException>((error, stackTrace) => null);
  }

  // TODO(dtscalac): enable when endpoint works correctly
  // ignore: unused_element
  Future<RbacRegistrationChain> _recoverRbacRegistration(
    CatalystId catalystId,
    RbacToken token,
  ) {
    return _apiServices.gateway
        .apiV1RbacRegistrationGet(
          lookup: catalystId.toUri().toStringWithoutScheme(),
          authorization: token.authHeader(),
        )
        .successBodyOrThrow();
  }
}
