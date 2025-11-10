import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

class CatalystRuntimeProfiler extends CatalystBaseProfiler {
  CatalystRuntimeProfiler(super.delegate);

  @override
  void start({
    required DateTime at,
  }) {
    assert(!ongoing, 'Runtime profiler already initialized');

    timeline = delegate.startTransaction(
      'Runtime',
      arguments: CatalystProfilerTimelineArguments(
        operation: 'runtime_operations',
        description: 'Measuring performance of runtime operations throughout app lifecycle',
        startTimestamp: at,
      ),
    );
  }
}
