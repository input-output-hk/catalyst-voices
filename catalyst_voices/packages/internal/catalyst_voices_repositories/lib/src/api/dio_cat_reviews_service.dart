import 'package:catalyst_voices_repositories/src/api/api_services.dart';
import 'package:catalyst_voices_repositories/src/api/dio_client.dart';
import 'package:catalyst_voices_repositories/src/api/models/catalyst_id_create.dart';
import 'package:catalyst_voices_repositories/src/api/models/catalyst_id_public.dart';
import 'package:catalyst_voices_repositories/src/common/http_headers.dart';
import 'package:dio/dio.dart';

/// # Catalyst Reviews API.
///
/// Based on OpenAPI Catalyst Reviews API version 0.1.0
/// reviews-api/v1.2.5 - https://github.com/input-output-hk/catalyst-reviews/releases/tag/reviews-api%2Fv1.2.5
abstract interface class CatReviewsService {
  factory CatReviewsService.dio({
    required String baseUrl,
    BaseOptions? options,
    InterceptClient? interceptClient,
    List<Interceptor> interceptors = const [],
  }) {
    final dio = Dio(
      options?.copyWith(baseUrl: baseUrl) ?? BaseOptions(baseUrl: baseUrl),
    )..interceptors.addAll(interceptors);
    interceptClient?.call(dio);
    final dioClient = DioClient(dio);
    return DioCatReviewsService(dioClient);
  }

  void close();

  /// Get a catalyst id from request.
  Future<CatalystIdPublic> getPublicProfile({String? authorization});

  /// Returns true if account with a catalyst id from [lookup] is verified.
  Future<bool> isPubliclyVerified({
    required String lookup,
    String? authorization,
  });

  /// Update info associated with a catalyst id.
  Future<CatalystIdPublic> upsertPublicProfile({
    required CatalystIdCreate body,
    String? authorization,
  });
}

final class DioCatReviewsService implements CatReviewsService {
  final DioClient _dio;

  const DioCatReviewsService(this._dio);

  @override
  void close() => _dio.close();

  @override
  Future<CatalystIdPublic> getPublicProfile({String? authorization}) {
    return _dio.get<Map<String, dynamic>, CatalystIdPublic>(
      '/catalyst-ids/me',
      options: Options(
        headers: {
          HttpHeaders.authorization: ?authorization,
        },
      ),
      mapper: CatalystIdPublic.fromJson,
    );
  }

  @override
  Future<bool> isPubliclyVerified({
    required String lookup,
    String? authorization,
  }) {
    // TODO(damian-molinski): Endpoint do not exist yet. Needs implementation.
    return Future(() => true);
  }

  @override
  Future<CatalystIdPublic> upsertPublicProfile({
    required CatalystIdCreate body,
    String? authorization,
  }) {
    return _dio.post<Map<String, dynamic>, CatalystIdPublic>(
      '/catalyst-ids/me',
      body: body.toJson(),
      options: Options(
        headers: {
          HttpHeaders.authorization: ?authorization,
        },
      ),
      mapper: CatalystIdPublic.fromJson,
    );
  }
}
