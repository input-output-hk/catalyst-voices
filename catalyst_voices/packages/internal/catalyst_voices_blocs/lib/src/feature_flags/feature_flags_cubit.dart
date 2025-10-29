import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

final class FeatureFlagsCubit extends Cubit<FeatureFlagsState> {
  final FeatureFlagsService _featureFlagsService;

  StreamSubscription<List<FeatureFlagInfo>>? _subscription;

  FeatureFlagsCubit(this._featureFlagsService)
    : super(FeatureFlagsState(features: _buildFeaturesMap(_featureFlagsService.getAllInfo()))) {
    _subscribeToChanges();
  }

  void clearFeatureOverride(Feature feature) {
    _featureFlagsService.setUserOverrideFeature(feature, value: null);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }

  void toggleFeatureOverride(Feature feature) {
    _featureFlagsService.setUserOverrideFeature(
      feature,
      value: !state.isEnabled(feature),
    );
  }

  void _subscribeToChanges() {
    _subscription = _featureFlagsService.changes.listen((allFeatures) {
      emit(state.copyWith(features: _buildFeaturesMap(allFeatures)));
    });
  }

  static Map<String, FeatureFlagInfo> _buildFeaturesMap(List<FeatureFlagInfo> infos) {
    return {for (final info in infos) info.feature.name: info};
  }
}
