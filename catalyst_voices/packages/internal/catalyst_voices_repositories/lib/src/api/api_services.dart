import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    show ApiConfig;
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.swagger.dart';
import 'package:catalyst_voices_repositories/generated/api/client_index.dart';
import 'package:catalyst_voices_repositories/generated/api/client_mapping.dart';
import 'package:catalyst_voices_repositories/src/api/converters/cbor_or_json_converter.dart';
import 'package:catalyst_voices_repositories/src/api/converters/cbor_serializable_converter.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';
import 'package:catalyst_voices_repositories/src/auth/auth_token_provider.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

// swagger_dart_code_generator does not add this model to mapping list.
// TODO(damian-molinski): investigate if this can be removed.
void _fixModelsMapping() {
  generatedMapping.putIfAbsent(
    DocumentIndexList,
    () => DocumentIndexList.fromJsonFactory,
  );
}

final class ApiServices {
  final CatGateway gateway;
  final Vit vit;
  final CatReviews reviews;

  factory ApiServices({
    required ApiConfig config,
    required AuthTokenProvider authTokenProvider,
  }) {
    _fixModelsMapping();

    return ApiServices.internal(
      gateway: createGateway(
        gatewayUri: Uri.parse(config.gatewayUrl),
        authTokenProvider: authTokenProvider,
      ),
      vit: createVit(
        vitUri: Uri.parse(config.vitUrl),
      ),
      reviews: createReviews(
        reviewsUrl: Uri.parse(config.reviewsUrl),
        authTokenProvider: authTokenProvider,
      ),
    );
  }

  @visibleForTesting
  const ApiServices.internal({
    required this.gateway,
    required this.vit,
    required this.reviews,
  });

  static CatGateway createGateway({
    required Uri gatewayUri,
    required AuthTokenProvider authTokenProvider,
  }) {
    return CatGateway.create(
      authenticator: null,
      baseUrl: gatewayUri,
      converter: CborOrJsonDelegateConverter(
        cborConverter: CborSerializableConverter(),
        jsonConverter: $JsonSerializableConverter(),
      ),
      interceptors: [
        RbacAuthInterceptor(authTokenProvider),
        if (kDebugMode) HttpLoggingInterceptor(onlyErrors: true),
      ],
    );
  }

  static CatReviews createReviews({
    required Uri reviewsUrl,
    required AuthTokenProvider authTokenProvider,
  }) {
    return CatReviews.create(
      authenticator: null,
      baseUrl: reviewsUrl,
      interceptors: [
        RbacAuthInterceptor(authTokenProvider),
        if (kDebugMode) HttpLoggingInterceptor(onlyErrors: true),
      ],
    );
  }

  static Vit createVit({
    required Uri vitUri,
  }) {
    return Vit.create(
      baseUrl: vitUri,
      interceptors: [
        if (kDebugMode) HttpLoggingInterceptor(onlyErrors: true),
      ],
    );
  }
}
