import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.swagger.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/common/rbac_token_ext.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/user/reviews_catalyst_id_status_ext.dart';
import 'package:catalyst_voices_repositories/src/dto/user/user_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';

abstract interface class UserRepository {
  const factory UserRepository(
    UserStorage storage,
    KeychainProvider keychainProvider,
    ApiServices apiServices,
    DocumentRepository documentRepository,
  ) = UserRepositoryImpl;

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
  final DocumentRepository _documentRepository;

  const UserRepositoryImpl(
    this._storage,
    this._keychainProvider,
    this._apiServices,
    this._documentRepository,
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

    final username = (publicId?.username as String?) ??
        await _lookupUsernameFromDocuments(
          catalystId: catalystId,
        );

    return RecoveredAccount(
      username: username,
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

  Future<String?> _lookupUsernameFromDocuments({
    required CatalystId catalystId,
  }) {
    final significantId = catalystId.toSignificant();
    return _documentRepository
        .getLatestDocument(authorId: significantId)
        .then((value) => value?.metadata.authors ?? <CatalystId>[])
        .then(
      (authors) {
        return authors
            .firstWhereOrNull((id) => id.toSignificant() == significantId);
      },
    ).then((value) => value?.username);
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
