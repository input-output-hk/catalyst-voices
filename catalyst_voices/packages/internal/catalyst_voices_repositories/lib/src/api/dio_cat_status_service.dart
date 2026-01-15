import 'package:catalyst_voices_repositories/src/api/api_services.dart';
import 'package:catalyst_voices_repositories/src/api/dio_client.dart';
import 'package:catalyst_voices_repositories/src/api/models/components.dart';
import 'package:dio/dio.dart';

abstract interface class CatStatusService {
  factory CatStatusService.dio({
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
    return DioCatStatusService(dioClient);
  }

  void close();

  Future<Components> componentStatuses();
}

final class DioCatStatusService implements CatStatusService {
  final DioClient _dio;

  const DioCatStatusService(this._dio);

  @override
  void close() => _dio.close();

  @override
  Future<Components> componentStatuses({String? authorization}) {
    return _dio.get<Map<String, dynamic>, Components>(
      '/v2/components.json',
      mapper: Components.fromJson,
    );
  }
}
