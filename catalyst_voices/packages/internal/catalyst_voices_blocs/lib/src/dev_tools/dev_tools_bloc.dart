import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

const _requiredTapCount = 6;

final class DevToolsBloc extends Bloc<DevToolsEvent, DevToolsState>
    with BlocSignalEmitterMixin<DevToolsSignal, DevToolsState> {
  final DevToolsService _devToolsService;

  Timer? _resetCountTimer;

  DevToolsBloc(
    this._devToolsService,
  ) : super(const DevToolsState()) {
    on<DevToolsEnablerTappedEvent>(_handleEnablerTap);
    on<DevToolsEnablerTapResetEvent>(_handleTapCountReset);
    on<RecoverConfigEvent>(_handleRecoverConfig);

    add(const RecoverConfigEvent());
  }

  @override
  Future<void> close() {
    _resetCountTimer?.cancel();
    _resetCountTimer = null;

    return super.close();
  }

  Future<void> _handleEnablerTap(
    DevToolsEnablerTappedEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    _resetCountTimer?.cancel();
    _resetCountTimer = null;

    if (state.isDeveloper) {
      emitSignal(const AlreadyEnabledSignal());
      return;
    }

    final count = state.enableTapCount + 1;
    final isDeveloper = count >= _requiredTapCount;

    if (isDeveloper) {
      await _devToolsService.updateDevTools(isEnabled: true);
      emit(state.copyWith(enableTapCount: count, isDeveloper: isDeveloper));
      emitSignal(const BecameDeveloperSignal());
      return;
    }

    if (count > 1) {
      emitSignal(TapsLeftSignal(count: _requiredTapCount - count));
    }

    emit(state.copyWith(enableTapCount: count));

    _resetCountTimer = Timer(
      const Duration(seconds: 1),
      () => add(const DevToolsEnablerTapResetEvent()),
    );
  }

  Future<void> _handleRecoverConfig(
    RecoverConfigEvent event,
    Emitter<DevToolsState> emit,
  ) async {
    final isDeveloper = await _devToolsService.isDeveloper();

    if (!isClosed) {
      emit(state.copyWith(isDeveloper: isDeveloper));
    }
  }

  void _handleTapCountReset(
    DevToolsEnablerTapResetEvent event,
    Emitter<DevToolsState> emit,
  ) {
    _resetCountTimer?.cancel();
    _resetCountTimer = null;

    emit(state.copyWith(enableTapCount: 0));
  }
}
