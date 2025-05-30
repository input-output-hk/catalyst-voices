import 'package:logging/logging.dart';

abstract interface class CollectLogStrategy {
  Future<void> clear();

  void collect(LogRecord log);

  Future<Iterable<LogRecord>> getAll();
}
