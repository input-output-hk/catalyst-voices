import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/api/models/catalyst_id_create.dart';
import 'package:catalyst_voices_repositories/src/api/models/catalyst_id_public.dart';
import 'package:catalyst_voices_repositories/src/api/models/rbac_registration_chain.dart';
import 'package:catalyst_voices_repositories/src/common/future_response_mapper.dart';
import 'package:catalyst_voices_repositories/src/common/rbac_token_ext.dart';
import 'package:catalyst_voices_repositories/src/dto/user/catalyst_id_public_ext.dart';
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

  Future<RbacRegistrationChain> getRbacRegistration({CatalystId? catalystId});

  Future<RecoverableAccount> getRecoverableAccount({
    required CatalystId catalystId,
    required RbacToken rbacToken,
  });

  Future<User> getUser();

  Future<VotingPower> getVotingPower();

  Future<bool> isPubliclyVerified({
    required CatalystId catalystId,
    RbacToken? token,
  });

  /// Throws [EmailAlreadyUsedException] if [email] already taken.
  Future<AccountPublicProfile> publishUserProfile({
    required CatalystId catalystId,
    required String email,
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
    final rbacChain = await getRbacRegistration(catalystId: catalystId);

    final transactionId = rbacChain.lastVolatileTxn ?? rbacChain.lastPersistentTxn;

    if (transactionId == null) {
      throw ArgumentError.notNull('transactionId');
    }

    return TransactionHash.fromHex(transactionId);
  }

  @override
  Future<RbacRegistrationChain> getRbacRegistration({CatalystId? catalystId}) {
    return _apiServices.gateway
        .rbacRegistration(lookup: catalystId?.toUri().toStringWithoutScheme())
        .successBodyOrThrow();
  }

  @override
  Future<RecoverableAccount> getRecoverableAccount({
    required CatalystId catalystId,
    required RbacToken rbacToken,
  }) async {
    final rbacRegistration = await getRbacRegistration(catalystId: catalystId);

    final publicProfile = await _getAccountPublicProfile(
      token: rbacToken,
    ).onError<ForbiddenException>((_, _) => null);

    final username =
        publicProfile?.username ?? await _lookupUsernameFromDocuments(catalystId: catalystId);

    final votingPower = await _getVotingPower(token: rbacToken);

    return RecoverableAccount(
      username: username,
      email: publicProfile?.email,
      roles: rbacRegistration.accountRoles,
      stakeAddress: rbacRegistration.stakeAddress,
      publicStatus: publicProfile?.status ?? AccountPublicStatus.notSetup,
      votingPower: votingPower,
      isPersistent: rbacRegistration.lastPersistentTxn != null,
    );
  }

  @override
  Future<User> getUser() async {
    final dto = await _storage.readUser();
    final user = await dto?.toModel(keychainProvider: _keychainProvider);
    return user ?? const User.empty();
  }

  @override
  Future<VotingPower> getVotingPower() {
    return _getVotingPower();
  }

  @override
  Future<bool> isPubliclyVerified({
    required CatalystId catalystId,
    RbacToken? token,
  }) async {
    final response = await _apiServices.reviews
        .isPubliclyVerified(
          lookup: catalystId.toUri().toStringWithoutScheme(),
          authorization: token?.authHeader(),
        )
        .successBodyOrThrow();

    return response;
  }

  @override
  Future<AccountPublicProfile> publishUserProfile({
    required CatalystId catalystId,
    required String email,
  }) {
    return _apiServices.reviews
        .upsertPublicProfile(
          body: CatalystIdCreate(
            catalystIdUri: catalystId.toUri().toStringWithoutScheme(),
            email: email,
          ),
        )
        .successBodyOrThrow()
        .onError<ResourceConflictException>((_, _) => throw const EmailAlreadyUsedException())
        .then((value) => value.toModel());
  }

  @override
  Future<void> saveUser(User user) {
    final dto = UserDto.fromModel(user);

    return _storage.writeUser(dto);
  }

  /// Looks up reviews module and receives status for active
  /// account if [token] is not specified.
  Future<AccountPublicProfile?> _getAccountPublicProfile({RbacToken? token}) async {
    return _apiServices.reviews
        .getPublicProfile(authorization: token?.authHeader())
        .successBodyOrThrow()
        .then<CatalystIdPublic?>((value) => value)
        .onError<NotFoundException>((error, stackTrace) => null)
        // Review module returns 401 Registration not found for the auth token
        .onError<UnauthorizedException>((error, stackTrace) => null)
        .then((value) => value?.toModel());
  }

  // TODO(dt-iohk): fetch voting power from backend using token
  // ignore: unused_element_parameter
  Future<VotingPower> _getVotingPower({RbacToken? token}) async {
    return VotingPower.dummy();
  }

  Future<String?> _lookupUsernameFromDocuments({
    required CatalystId catalystId,
  }) {
    return _documentRepository
        .findFirst(originalAuthorId: catalystId.toSignificant())
        .then((value) => value?.metadata.authors ?? <CatalystId>[])
        .then(
          (authors) {
            return authors.firstWhereOrNull((id) => id.isSameAs(catalystId));
          },
        )
        .then((value) => value?.username);
  }
}
