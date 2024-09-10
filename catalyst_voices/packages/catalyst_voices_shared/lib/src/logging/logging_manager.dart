import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

export 'package:logging/logging.dart' show Level, Logger;

abstract interface class LoggingManager {
  factory LoggingManager() {
    return _LoggingManagerImpl(root: Logger.root);
  }

  set level(Level newValue);

  set printLogs(bool newValue);

  void dispose();
}

final class _LoggingManagerImpl implements LoggingManager {
  final Logger root;

  StreamSubscription<LogRecord>? _recordsSub;

  _LoggingManagerImpl({
    required this.root,
  }) : _printLogs = false {
    hierarchicalLoggingEnabled = true;

    root.level = Level.OFF;
    _recordsSub = root.onRecord.listen(_onLogRecord);
  }

  @override
  set level(Level newValue) {
    if (root.level == newValue) {
      return;
    }
    root.level = newValue;
  }

  bool get printLogs => _printLogs;

  bool _printLogs;

  @override
  set printLogs(bool newValue) {
    if (_printLogs == newValue) {
      return;
    }
    _printLogs = newValue;
  }

  @override
  void dispose() {
    _recordsSub?.cancel();
    _recordsSub = null;

    root.clearListeners();
  }

  void _onLogRecord(LogRecord log) {
    if (_printLogs) {
      _printLogRecord(log);
    }
  }

  void _printLogRecord(LogRecord log) {
    if (log.level >= Level.SEVERE) {
      final error = log.error;
      final errorDetails = FlutterErrorDetails(
        exception: error is Exception ? error : Exception(error),
        stack: log.stackTrace,
        library: log.loggerName,
        context: ErrorDescription(log.message),
      );
      FlutterError.dumpErrorToConsole(errorDetails);
    } else {
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
}
