//ignore_for_file: one_member_abstracts

import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/config/config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract interface class RemoteConfigSource {
  Future<RemoteConfig> get();
}

final class UrlRemoteConfigSource implements RemoteConfigSource {
  @visibleForTesting
  static http.Client? mockClient;

  final Uri baseUrl;

  UrlRemoteConfigSource({
    required this.baseUrl,
  });

  @override
  Future<RemoteConfig> get() async {
    final path = '${baseUrl.path}/api/draft/config/frontend';
    final url = baseUrl.replace(path: path).normalizePath();
    final client = mockClient ?? http.Client();

    try {
      final response = await client.get(url);
      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      if (!isSuccess) {
        throw ApiErrorResponseException(statusCode: response.statusCode);
      }

      final decodedBody = jsonDecode(response.body);
      if (decodedBody is! Map<String, dynamic>) {
        throw const ApiMalformedBodyException();
      }

      return RemoteConfig.fromJson(decodedBody);
    } finally {
      client.close();
    }
  }
}
