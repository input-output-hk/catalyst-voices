import 'dart:convert';

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
    // TODO(LynxLynxx): This will be replaced with DioClient implementation and better error handling
    final timestamp = DateTimeExt.now().toUtc().millisecondsSinceEpoch;
    try {
      final response = await _dio.get<String>(
        '/version.json?v=$timestamp',
      );
      final jsonData = json.decode(response.data!) as Map<String, dynamic>;
      return VersionInfo.fromJson(jsonData);
    } catch (e) {
      rethrow;
    }
  }
}
