import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/api.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/component_status/component_ext.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class SystemStatusRepository {
  const factory SystemStatusRepository(ApiServices apiServices) = SystemStatusRepositoryImpl;

  Future<AppVersion> currentAppVersion();

  Future<List<ComponentStatus>> getComponentStatuses();

  Stream<List<ComponentStatus>> pollComponentStatuses({Duration interval});
}

final class SystemStatusRepositoryImpl implements SystemStatusRepository {
  final ApiServices _apiServices;

  const SystemStatusRepositoryImpl(this._apiServices);

  @override
  Future<AppVersion> currentAppVersion() {
    return _apiServices.appMeta.versionInfo().then((e) => e.toModel());
  }

  @override
  Future<List<ComponentStatus>> getComponentStatuses() {
    return _apiServices.status.v2ComponentsJsonGet().successBodyOrThrow().then(
      (e) => e.components.map((c) => c.toModel()).toList(),
    );
  }

  @override
  Stream<List<ComponentStatus>> pollComponentStatuses({
    Duration interval = const Duration(seconds: 120),
  }) {
    return Stream<void>.periodic(
      interval,
    ).startWith(null).asyncMap((_) async => getComponentStatuses()).asBroadcastStream();
  }
}
