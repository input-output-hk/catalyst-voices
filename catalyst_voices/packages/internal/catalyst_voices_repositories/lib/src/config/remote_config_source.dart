//ignore_for_file: one_member_abstracts

import 'dart:convert';

import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/config/config.dart';

final class ApiConfigSource implements RemoteConfigSource {
  final ApiServices _api;

  ApiConfigSource(
    this._api,
  );

  @override
  Future<RemoteConfig> get() {
    return _api.gateway
        .apiGatewayV1ConfigFrontendGet()
        .successBodyOrThrow()
        .then((value) {
          if (value is Map<String, dynamic>) {
            return value;
          }
          final encoded = value is String ? value : '{}';
          return jsonDecode(encoded) as Map<String, dynamic>;
        })
        .catchError((_) => <String, dynamic>{})
        .then(RemoteConfig.fromJson);
  }
}

abstract interface class RemoteConfigSource {
  Future<RemoteConfig> get();
}
