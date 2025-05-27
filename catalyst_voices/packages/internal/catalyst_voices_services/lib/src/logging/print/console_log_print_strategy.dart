import 'package:catalyst_voices_services/src/logging/print/log_print_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' show Level, LogRecord;

final class ConsoleLogPrintStrategy implements LogPrintStrategy {
  const ConsoleLogPrintStrategy();

  @override
  void print(LogRecord log) {
    if (log.level >= Level.SEVERE) {
      final error = log.error;
      final errorDetails = FlutterErrorDetails(
        exception: error is Exception ? error : Exception(error),
        stack: log.stackTrace,
        library: log.loggerName,
        context: ErrorDescription(log.message),
      );
      FlutterError.dumpErrorToConsole(errorDetails);
      return;
    }

    debugPrint('[${log.loggerName}] ${log.message}');

    final object = log.object;
    if (object != null) {
      debugPrint(object.toString());
    }

    final error = log.error;
    if (error != null) {
      debugPrint(error.toString());
    }

    final stackTrace = log.stackTrace;
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
