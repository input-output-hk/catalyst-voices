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
        .apiV1ConfigFrontendGet()
        .successBodyOrThrow()
        .then((value) => value is String ? value : '{}')
        .then((value) => jsonDecode(value) as Map<String, dynamic>)
        .catchError((_) => <String, dynamic>{})
        .then(RemoteConfig.fromJson);
  }
}

abstract interface class RemoteConfigSource {
  Future<RemoteConfig> get();
}
