import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

final class FeatureFlagsCubit extends Cubit<FeatureFlagsState> {
  final FeatureFlagsService _featureFlagsService;

  StreamSubscription<List<FeatureFlagInfo>>? _subscription;

  FeatureFlagsCubit(this._featureFlagsService)
    : super(
        FeatureFlagsState(
          featureFlags: _buildFeatureFlagsMap(
            _featureFlagsService.getAllInfo(),
          ),
        ),
      ) {
    _subscribeToChanges();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;
    return super.close();
  }

  void setUserOverride(
    FeatureFlag featureFlag, {
    required bool? value,
  }) {
    _featureFlagsService.setUserOverride(
      featureFlag,
      value: value,
    );
  }

  void _subscribeToChanges() {
    _subscription = _featureFlagsService.allInfoChanges.listen((allFeatures) {
      emit(state.copyWith(featureFlags: _buildFeatureFlagsMap(allFeatures)));
    });
  }

  static Map<FeatureType, FeatureFlagInfo> _buildFeatureFlagsMap(List<FeatureFlagInfo> infos) {
    return {for (final info in infos) info.featureFlag.type: info};
  }
}
