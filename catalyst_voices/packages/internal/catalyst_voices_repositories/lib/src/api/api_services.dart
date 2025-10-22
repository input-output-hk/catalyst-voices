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
/// - [CatStatusService]
final class ApiServices {
  final CatGatewayService gateway;
  final CatReviewsService reviews;
  final CatStatusService status;

  factory ApiServices.dio({
    required AppEnvironmentType env,
    AuthTokenProvider? authTokenProvider,
    InterceptClient? interceptClient,
  }) {
    final catApiServiceLogger = Logger('CatApiServices');
    final catDioOptions = BaseOptions(contentType: ContentTypes.applicationJson);
    final rbacAuthInterceptor = authTokenProvider != null
        ? RbacAuthInterceptor(authTokenProvider)
        : null;
    final catLogInterceptor = kDebugMode
        ? LogInterceptor(logPrint: catApiServiceLogger.fine)
        : null;
    final gateway = CatGatewayService.dio(
      baseUrl: env.app.replace(path: '/api/gateway').toString(),
      options: catDioOptions,
      interceptClient: interceptClient,
      interceptors: [
        ?rbacAuthInterceptor,
        ?catLogInterceptor,
      ],
    );
    final reviews = CatReviewsService.dio(
      baseUrl: env.app.replace(path: '/api/reviews').toString(),
      options: catDioOptions,
      interceptClient: interceptClient,
      interceptors: [
        ?rbacAuthInterceptor,
        ?catLogInterceptor,
      ],
    );
    final status = CatStatusService.dio(
      baseUrl: env.status.toString(),
      options: catDioOptions,
      interceptClient: interceptClient,
      interceptors: [?catLogInterceptor],
    );

    return ApiServices.internal(
      gateway: gateway,
      reviews: reviews,
      status: status,
    );
  }

  @visibleForTesting
  const ApiServices.internal({
    required this.gateway,
    required this.reviews,
    required this.status,
  });

  void dispose() {
    gateway.close();
    reviews.close();
    status.close();
  }
}
