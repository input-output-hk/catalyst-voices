import 'package:catalyst_voices_repositories/src/api/models/version_info.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:dio/dio.dart';

abstract interface class AppMetaService {
  factory AppMetaService() {
    final dio = Dio();

    return DioAppMetaService(dio);
  }

  void close();

  Future<VersionInfo> versionInfo();
}

class DioAppMetaService implements AppMetaService {
  final Dio _dio;

  const DioAppMetaService(this._dio);

  @override
  void close() => _dio.close();

  @override
  Future<VersionInfo> versionInfo() async {
    final timestamp = DateTimeExt.now().toUtc().millisecondsSinceEpoch;
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/version.json?v=$timestamp',
      );
      return VersionInfo.fromJson(response.data!);
    } catch (e) {
      rethrow;
    }
  }
}
