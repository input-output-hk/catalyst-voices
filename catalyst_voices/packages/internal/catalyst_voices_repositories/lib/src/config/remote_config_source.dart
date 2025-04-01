//ignore_for_file: one_member_abstracts

import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/config/config.dart';
import 'package:http/http.dart' as http;

abstract interface class RemoteConfigSource {
  Future<RemoteConfig> fetch();
}

final class UrlRemoteConfigSource implements RemoteConfigSource {
  final String url;

  UrlRemoteConfigSource({
    required this.url,
  });

  @override
  Future<RemoteConfig> fetch() async {
    final response = await http.get(Uri.parse(url));
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

    if (!isSuccess) {
      throw ApiErrorResponseException(statusCode: response.statusCode);
    }

    final decodedBody = jsonDecode(response.body);
    if (decodedBody is! Map<String, dynamic>) {
      throw const ApiMalformedBodyException();
    }

    return RemoteConfig.fromJson(decodedBody);
  }
}
