import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:mocktail/mocktail.dart';

class FakeUserRepository extends Fake implements UserRepository {
  User? _user;

  AccountPublicStatus defaultPublishStatus = AccountPublicStatus.notSetup;

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

  void reset() {
    _user = null;
  }

  @override
  Future<void> saveUser(User user) async {
    _user = user;
  }
}

class MockUserRepository extends Mock implements UserRepository {}
