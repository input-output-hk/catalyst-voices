import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_reviews.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/api/api_services.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';

final class ApiUserDataSource implements UserDataSource {
  final ApiServices _apiServices;

  const ApiUserDataSource(this._apiServices);

  @override
  Future<RecoveredAccount?> recoverAccount({required String rbacToken}) async {
    final reviews = ApiServices.createReviews(
      reviewsUrl: _apiServices.reviews.client.baseUrl,
      authTokenProvider: _HardcodedAuthTokenProvider(token: rbacToken),
    );

    final response = await reviews.apiCatalystIdsMeGet();
    response.verifyIsSuccessful();

    final body = response.body;
    if (body == null) {
      // nothing to recover
      return null;
    }

    return RecoveredAccount(
      username: body.username as String?,
      email: body.email as String?,
    );
  }

  @override
  Future<void> updateEmail(String email) async {
    final response = await _apiServices.reviews
        .apiCatalystIdsMePost(body: CatalystIDCreate(email: email));

    response.verifyIsSuccessful();
  }
}

// ignore: one_member_abstracts
abstract interface class UserDataSource {
  Future<RecoveredAccount?> recoverAccount({required String rbacToken});

  Future<void> updateEmail(String email);
}

class _HardcodedAuthTokenProvider implements AuthTokenProvider {
  final String token;

  const _HardcodedAuthTokenProvider({required this.token});

  @override
  Future<String?> createRbacToken({bool forceRefresh = false}) async => token;
}
