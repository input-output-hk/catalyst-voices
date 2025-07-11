import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/common/rbac_token_ext.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/user/catalyst_id_public_ext.dart';
import 'package:catalyst_voices_repositories/src/dto/user/rbac_registration_chain_dto.dart';
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

  Future<AccountPublicProfile?> getAccountPublicProfile();

  Future<TransactionHash> getPreviousRegistrationTransactionId({
    required CatalystId catalystId,
  });

  Future<User> getUser();

  /// Throws [EmailAlreadyUsedException] if [email] already taken.
  Future<AccountPublicProfile> publishUserProfile({
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
  Future<AccountPublicProfile?> getAccountPublicProfile() => _getAccountPublicProfile();

  @override
  Future<TransactionHash> getPreviousRegistrationTransactionId({
    required CatalystId catalystId,
  }) async {
    final lookup = catalystId.toSignificant().toUri().toStringWithoutScheme();

    final rbacChain = await _apiServices.gateway
        .apiGatewayV1RbacRegistrationGet(lookup: lookup)
        .successBodyOrThrow();

    final transactionId = rbacChain.lastVolatileTxn ?? rbacChain.lastPersistentTxn;

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
  Future<AccountPublicProfile> publishUserProfile({
    required CatalystId catalystId,
    required String email,
  }) {
    try {
      return _apiServices.reviews
          .apiCatalystIdsMePost(
            body: CatalystIDCreate(
              catalystIdUri: catalystId.toUri().toStringWithoutScheme(),
              email: email,
            ),
          )
          .successBodyOrThrow()
          .then((value) => value.toModel());
    } on ResourceConflictException {
      throw const EmailAlreadyUsedException();
    }
  }

  @override
  Future<RecoveredAccount> recoverAccount({
    required CatalystId catalystId,
    required RbacToken rbacToken,
  }) async {
    final rbacRegistration = await _apiServices.gateway
        .apiGatewayV1RbacRegistrationGet(lookup: catalystId.toUri().toStringWithoutScheme())
        .successBodyOrThrow();

    final publicProfile = await _getAccountPublicProfile(token: rbacToken);
    final username = publicProfile?.username ??
        await _lookupUsernameFromDocuments(
          catalystId: catalystId,
        );

    return RecoveredAccount(
      username: username,
      email: publicProfile?.email,
      roles: rbacRegistration.accountRoles,
      stakeAddress: rbacRegistration.stakeAddress,
      publicStatus: publicProfile?.status ?? AccountPublicStatus.notSetup,
    );
  }

  @override
  Future<void> saveUser(User user) {
    final dto = UserDto.fromModel(user);

    return _storage.writeUser(dto);
  }

  /// Looks up reviews module and receives status for active
  /// account if [token] is not specified.
  Future<AccountPublicProfile?> _getAccountPublicProfile({
    RbacToken? token,
  }) async {
    return _apiServices.reviews
        .apiCatalystIdsMeGet(authorization: token?.authHeader())
        .successBodyOrThrow()
        .then<CatalystIDPublic?>((value) => value)
        .onError<NotFoundException>((error, stackTrace) => null)
        // Review module returns 401 Registration not found for the auth token
        .onError<UnauthorizedException>((error, stackTrace) => null)
        .then((value) => value?.toModel());
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
        return authors.firstWhereOrNull((id) => id.toSignificant() == significantId);
      },
    ).then((value) => value?.username);
  }
}
