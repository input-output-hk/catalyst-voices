import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:mocktail/mocktail.dart';

/// A fake implementation of [UserRepository] for testing.
///
/// This fake provides a simple in-memory implementation with configurable
/// behavior for common operations.
///
/// Example usage:
/// ```dart
/// final repository = FakeUserRepository()
///   ..defaultPublishStatus = AccountPublicStatus.verifying;
///
/// await repository.saveUser(user);
/// final savedUser = await repository.getUser();
/// ```
class FakeUserRepository extends Fake implements UserRepository {
  User? _user;

  /// The default status to return from [publishUserProfile].
  AccountPublicStatus defaultPublishStatus = AccountPublicStatus.notSetup;

  /// The transaction hash to return from [getPreviousRegistrationTransactionId].
  TransactionHash? previousRegistrationTransactionId;

  @override
  Future<TransactionHash> getPreviousRegistrationTransactionId({
    required CatalystId catalystId,
  }) async {
    if (previousRegistrationTransactionId != null) {
      return previousRegistrationTransactionId!;
    }
    throw UnimplementedError(
      'previousRegistrationTransactionId not configured',
    );
  }

  @override
  Future<RbacRegistrationChain> getRbacRegistration({
    CatalystId? catalystId,
  }) async {
    throw const UnauthorizedException();
  }

  @override
  Future<User> getUser() async => _user ?? const User.empty();

  @override
  Future<AccountPublicProfile> publishUserProfile({
    required CatalystId catalystId,
    required String email,
  }) async {
    return AccountPublicProfile(
      email: email,
      status: defaultPublishStatus,
    );
  }

  /// Resets the repository to its initial state.
  void reset() {
    _user = null;
  }

  @override
  Future<void> saveUser(User user) async {
    _user = user;
  }
}

/// A mock implementation of [UserRepository] for testing.
///
/// This mock uses mocktail's Mock base class to allow configuring
/// method stubs and verifying calls in tests.
class MockUserRepository extends Mock implements UserRepository {}
