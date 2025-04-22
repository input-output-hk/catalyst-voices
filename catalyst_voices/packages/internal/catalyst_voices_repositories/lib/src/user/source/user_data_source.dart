import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/api/api_services.dart';

final class ApiUserDataSource implements UserDataSource {
  final ApiServices _apiServices;

  const ApiUserDataSource(this._apiServices);

  @override
  Future<AccountEmailVerificationStatus> getEmailStatus() async {
    // TODO(damian-molinski): ask review api
    return AccountEmailVerificationStatus.unknown;
  }

  @override
  Future<void> updateEmail(String email) async {
    await _apiServices.reviews
        .apiCatalystIdsMePost(body: CatalystIDCreate(email: email));
  }
}

// ignore: one_member_abstracts
abstract interface class UserDataSource {
  Future<AccountEmailVerificationStatus> getEmailStatus();

  Future<void> updateEmail(String email);
}
