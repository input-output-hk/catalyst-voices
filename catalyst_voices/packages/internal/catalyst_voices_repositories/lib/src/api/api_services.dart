import 'package:catalyst_voices_models/catalyst_voices_models.dart' show AppEnvironmentType;
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';
import 'package:catalyst_voices_repositories/src/common/content_types.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

typedef InterceptClient = void Function(Dio dio);

/// An interface for accessing Catalyst Voices API.
///
/// It provides access to the following services:
/// - [CatGatewayService]
/// - [CatReviewsService]
final class ApiServices {
  final CatGatewayService gateway;
  final CatReviewsService reviews;

  factory ApiServices.dio({
    required AppEnvironmentType env,
    AuthTokenProvider? authTokenProvider,
    InterceptClient? interceptClient,
  }) {
    final catApiServiceLogger = Logger('CatApiServices');
    final catDioOptions = BaseOptions(contentType: ContentTypes.applicationJson);
    final catInterceptors = [
      if (authTokenProvider != null) RbacAuthInterceptor(authTokenProvider),
      if (kDebugMode) LogInterceptor(logPrint: catApiServiceLogger.fine),
    ];
    final gateway = CatGatewayService.dio(
      baseUrl: env.app.replace(path: '/api/gateway').toString(),
      options: catDioOptions,
      interceptClient: interceptClient,
      interceptors: catInterceptors,
    );
    final reviews = CatReviewsService.dio(
      baseUrl: env.app.replace(path: '/api/reviews').toString(),
      options: catDioOptions,
      interceptClient: interceptClient,
      interceptors: catInterceptors,
    );

    return ApiServices.internal(
      gateway: gateway,
      reviews: reviews,
    );
  }

  @visibleForTesting
  ApiServices.internal({
    required this.gateway,
    required this.reviews,
  });

  void dispose() {
    gateway.close();
    reviews.close();
  }
}
