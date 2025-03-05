import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    show ApiConfig;
import 'package:catalyst_voices_repositories/generated/api/client_index.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart'
    show UserObserver;
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

final class ApiServices {
  final CatGateway gateway;
  final Vit vit;
  final CatReviews reviews;

  factory ApiServices({
    required ApiConfig config,
    required UserObserver userObserver,
  }) {
    final cat = CatGateway.create(
      authenticator: null,
      baseUrl: Uri.parse(config.gatewayUrl),
      interceptors: [
        RbacAuthInterceptor(userObserver),
        if (kDebugMode) HttpLoggingInterceptor(onlyErrors: true),
      ],
    );
    final vit = Vit.create(
      baseUrl: Uri.parse(config.vitUrl),
      interceptors: [
        if (kDebugMode) HttpLoggingInterceptor(onlyErrors: true),
      ],
    );
    final review = CatReviews.create(
      authenticator: null,
      baseUrl: Uri.parse(config.reviewsUrl),
      interceptors: [
        RbacAuthInterceptor(userObserver),
        if (kDebugMode) HttpLoggingInterceptor(onlyErrors: true),
      ],
    );

    return ApiServices._(
      gateway: cat,
      vit: vit,
      reviews: review,
    );
  }

  const ApiServices._({
    required this.gateway,
    required this.vit,
    required this.reviews,
  });
}
