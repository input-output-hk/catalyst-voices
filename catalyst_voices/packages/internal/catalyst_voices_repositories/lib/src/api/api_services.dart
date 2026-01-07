import 'package:catalyst_voices_models/catalyst_voices_models.dart' show ApiConfig;
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/dio_interceptor_factory.dart';
import 'package:catalyst_voices_repositories/src/api/local/local_cat_gateway.dart';
import 'package:catalyst_voices_repositories/src/common/content_types.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
  final AppMetaService appMeta;

  factory ApiServices.dio({
    required ApiConfig config,
    DioInterceptorFactory? interceptorFactory,
    AuthTokenProvider? authTokenProvider,
    InterceptClient? interceptClient,
  }) {
    interceptorFactory ??= DioInterceptorFactory();

    final catDioOptions = BaseOptions(contentType: ContentTypes.applicationJson);
    final authInterceptor = interceptorFactory.authInterceptor(authTokenProvider);
    final retryInterceptor = interceptorFactory.retryInterceptor(authInterceptor);
    final logInterceptor = interceptorFactory.logInterceptor(Logger('CatApiServices'));

    final CatGatewayService gateway = config.localGateway.isEnabled
        ? LocalCatGateway.create(
            initialProposalsCount: config.localGateway.proposalsCount,
            decompressedDocuments: config.localGateway.decompressedDocuments,
          )
        : CatGatewayService.dio(
            baseUrl: config.env.app.replace(path: '/api/gateway').toString(),
            options: catDioOptions,
            interceptClient: interceptClient,
            interceptors: [
              ?authInterceptor,
              retryInterceptor,
              ?logInterceptor,
            ],
          );
    final reviews = CatReviewsService.dio(
      baseUrl: config.env.app.replace(path: '/api/reviews').toString(),
      options: catDioOptions,
      interceptClient: interceptClient,
      interceptors: [
        ?authInterceptor,
        retryInterceptor,
        ?logInterceptor,
      ],
    );
    final status = CatStatusService.dio(
      baseUrl: config.env.status.toString(),
      interceptClient: interceptClient,
      interceptors: [
        retryInterceptor,
        ?logInterceptor,
      ],
    );

    final appMeta = AppMetaService();

    return ApiServices.internal(
      gateway: gateway,
      reviews: reviews,
      status: status,
      appMeta: appMeta,
    );
  }

  @visibleForTesting
  const ApiServices.internal({
    required this.gateway,
    required this.reviews,
    required this.status,
    required this.appMeta,
  });

  Future<void> dispose() async {
    gateway.close();
    reviews.close();
    status.close();
    appMeta.close();
  }
}
