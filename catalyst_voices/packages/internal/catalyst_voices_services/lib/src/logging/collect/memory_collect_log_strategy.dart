import 'dart:math' as math;

import 'package:catalyst_voices_services/src/logging/collect/collect_log_strategy.dart';
import 'package:logging/logging.dart' show LogRecord;

final class MemoryCollectLogStrategy implements CollectLogStrategy {
  final int _maxHistorySize;
  final _history = <LogRecord>[];

  MemoryCollectLogStrategy({
    int maxHistorySize = 500,
  })  : assert(maxHistorySize > 0, 'Have to be positive'),
        _maxHistorySize = maxHistorySize;

  @override
  Future<void> clear() async {
    _history.clear();
  }

  @override
  Future<void> collect(LogRecord log) async {
    _history.add(log);

    if (_history.length > _maxHistorySize) {
      // remove min 50 so we're not doing it every time log happens.
      final diff = _history.length - _maxHistorySize;
      final toRemove = math.max(50, diff).clamp(0, _history.length);
      if (toRemove < 1) {
        _history.clear();
      } else {
        _history.removeRange(0, toRemove);
      }
    }
  }

  @override
  Future<Iterable<LogRecord>> getAll() => Future.value(List.of(_history));
}
