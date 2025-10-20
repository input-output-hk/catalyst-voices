import 'package:catalyst_voices_repositories/src/api/api_services.dart';
import 'package:catalyst_voices_repositories/src/api/dio_client.dart';
import 'package:catalyst_voices_repositories/src/common/http_headers.dart';
import 'package:catalyst_voices_repositories/src/common/json.dart';
import 'package:catalyst_voices_repositories/src/models/catalyst_id_create.dart';
import 'package:catalyst_voices_repositories/src/models/catalyst_id_public.dart';
import 'package:dio/dio.dart';

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
  Future<CatalystIdPublic> fetchCurrentCatalystId({String? authorization});

  /// Update info associated with a catalyst id.
  Future<CatalystIdPublic> upsertCatalystId({
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
  Future<CatalystIdPublic> fetchCurrentCatalystId({String? authorization}) {
    return _dio.get<Json, CatalystIdPublic>(
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
  Future<CatalystIdPublic> upsertCatalystId({
    required CatalystIdCreate body,
    String? authorization,
  }) {
    return _dio.post<Json, CatalystIdPublic>(
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
