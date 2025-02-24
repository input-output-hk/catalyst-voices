import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    show ApiConfig;
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.swagger.dart';
import 'package:catalyst_voices_repositories/generated/api/vit.swagger.dart';
import 'package:catalyst_voices_repositories/src/api/interceptors/rbac_auth_interceptor.dart';
import 'package:catalyst_voices_repositories/src/api/review_module.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart'
    show UserObserver;
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

final class ApiServices {
  final CatGateway cat;
  final Vit vit;
  final ReviewModule review;

  factory ApiServices({
    required ApiConfig config,
    required UserObserver userObserver,
  }) {
    final cat = CatGateway.create(
      authenticator: null,
      baseUrl: Uri.parse(config.catGatewayUrl),
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
    final review = ReviewModule.create(
      authenticator: null,
      baseUrl: Uri.parse(config.reviewModuleUrl),
      interceptors: [
        RbacAuthInterceptor(userObserver),
        if (kDebugMode) HttpLoggingInterceptor(onlyErrors: true),
      ],
    );

    return ApiServices._(
      cat: cat,
      vit: vit,
      review: review,
    );
  }

  const ApiServices._({
    required this.cat,
    required this.vit,
    required this.review,
  });
}
