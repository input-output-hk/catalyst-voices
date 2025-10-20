//ignore_for_file: one_member_abstracts

import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/api/api_services.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/config/remote_config.dart';

final class ApiConfigSource implements RemoteConfigSource {
  final ApiServices _api;

  ApiConfigSource(this._api);

  @override
  Future<RemoteConfig> get() {
    return _api.gateway
        .fetchFrontendConfig() //
        .successBodyOrThrow()
        .catchError((_) => const RemoteConfig());
  }
}

abstract interface class RemoteConfigSource {
  Future<RemoteConfig> get();
}
