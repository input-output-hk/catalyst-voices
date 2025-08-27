import 'package:catalyst_voices_models/catalyst_voices_models.dart' show AppEnvironmentType;
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.swagger.dart';
import 'package:catalyst_voices_repositories/generated/api/client_index.dart';
import 'package:catalyst_voices_repositories/generated/api/client_mapping.dart';
import 'package:catalyst_voices_repositories/src/api/converters/cbor_or_json_converter.dart';
import 'package:catalyst_voices_repositories/src/api/converters/cbor_serializable_converter.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/path_trim_interceptor.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// swagger_dart_code_generator does not add this model to mapping list.
// TODO(damian-molinski): investigate if this can be removed.
void _fixModelsMapping() {
  generatedMapping.putIfAbsent(
    DocumentIndexList,
    () => DocumentIndexList.fromJsonFactory,
  );
}

/// An interface for accessing Catalyst Voices API.
///
/// It provides access to the following services:
/// - [CatGateway]
/// - [CatReviews]
final class ApiServices {
  final CatGateway gateway;
  final CatReviews reviews;

  factory ApiServices({
    required AppEnvironmentType env,
    AuthTokenProvider? authTokenProvider,
    ValueGetter<http.Client?>? httpClient,
  }) {
    _fixModelsMapping();

    return ApiServices.internal(
      gateway: CatGateway.create(
        httpClient: httpClient?.call(),
        baseUrl: env.app,
        converter: CborOrJsonDelegateConverter(
          cborConverter: CborSerializableConverter(),
          jsonConverter: $JsonSerializableConverter(),
        ),
        interceptors: [
          if (authTokenProvider != null) RbacAuthInterceptor(authTokenProvider),
          if (kDebugMode) HttpLoggingInterceptor(onlyErrors: true),
        ],
      ),
      reviews: CatReviews.create(
        httpClient: httpClient?.call(),
        baseUrl: env.app.replace(path: '/api/reviews'),
        interceptors: [
          PathTrimInterceptor(),
          if (authTokenProvider != null) RbacAuthInterceptor(authTokenProvider),
          if (kDebugMode) HttpLoggingInterceptor(onlyErrors: true),
        ],
      ),
    );
  }

  @visibleForTesting
  const ApiServices.internal({
    required this.gateway,
    required this.reviews,
  });

  Future<void> dispose() async {
    gateway.client.dispose();
    reviews.client.dispose();
  }
}
