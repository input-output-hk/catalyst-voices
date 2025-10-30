import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

final class FeatureFlagsCubit extends Cubit<FeatureFlagsState> {
  final FeatureFlagsService _featureFlagsService;

  StreamSubscription<List<FeatureFlagInfo>>? _subscription;

  FeatureFlagsCubit(
    this._featureFlagsService,
    AppEnvironmentType environmentType,
  ) : super(
        FeatureFlagsState(
          environmentType,
          features: _buildFeaturesMap(_featureFlagsService.getAllInfo()),
        ),
      ) {
    _subscribeToChanges();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }

  void _subscribeToChanges() {
    _subscription = _featureFlagsService.allInfoChanges.listen((allFeatures) {
      emit(state.copyWith(features: _buildFeaturesMap(allFeatures)));
    });
  }

  static Map<FeatureType, FeatureFlagInfo> _buildFeaturesMap(List<FeatureFlagInfo> infos) {
    return {for (final info in infos) info.featureType: info};
  }
}
