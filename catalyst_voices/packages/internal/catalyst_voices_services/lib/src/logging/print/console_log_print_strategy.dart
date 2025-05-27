import 'dart:developer' as developer;

import 'package:catalyst_voices_services/src/logging/print/log_print_strategy.dart';
import 'package:flutter/foundation.dart' show FlutterErrorDetails, ErrorDescription, FlutterError;
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

    developer.log(
      log.message,
      time: log.time,
      sequenceNumber: log.sequenceNumber,
      level: log.level.value,
      name: log.loggerName,
      zone: log.zone,
      error: log.error,
      stackTrace: log.stackTrace,
    );
  }
}
