import 'package:catalyst_voices_services/src/logging/formatter/logs_formatter.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart' show LogRecord;

final class TextLogsFormatter implements LogsFormatter {
  const TextLogsFormatter();

  @override
  String format(Iterable<LogRecord> logs) {
    final sortedLogs = logs.sorted((a, b) => a.sequenceNumber.compareTo(b.sequenceNumber));
    final buffer = StringBuffer();

    for (final log in sortedLogs) {
      // [SyncManager] Synchronization took 0:00:00.864125
      final row = '${log.time.toUtc().toIso8601String()} '
          '[${log.level.name}][${log.loggerName}] '
          '${log.message}';

      buffer.writeln(row);

      final object = log.object;
      if (object != null) {
        buffer.writeln(object);
      }

      final error = log.error;
      if (error != null) {
        buffer.writeln(error);
      }

      final stackTrace = log.stackTrace;
      if (stackTrace != null) {
        buffer.writeln(stackTrace.toString());
      }
    }

    return buffer.toString();
  }
}
