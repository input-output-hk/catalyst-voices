import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/logging/collect/collect_log_strategy.dart';
import 'package:catalyst_voices_services/src/logging/collect/memory_collect_log_strategy.dart';
import 'package:catalyst_voices_services/src/logging/print/console_log_print_strategy.dart';
import 'package:catalyst_voices_services/src/logging/print/log_print_strategy.dart';
import 'package:catalyst_voices_services/src/logging/reporting/log_reporting_strategy.dart';
import 'package:catalyst_voices_services/src/logging/reporting/sentry_errors_reporting_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LoggingService {
  factory LoggingService({
    Logger? root,
    LoggingSettingsStorage? settingsStorage,
    LogsFormatter? exportFormatter,
  }) {
    root ??= Logger.root;
    settingsStorage ??= LoggingSettingsLocalStorage(sharedPreferences: SharedPreferencesAsync());
    exportFormatter ??= const TextLogsFormatter();

    return _LoggingServiceImpl(
      root: root,
      settingsStorage: settingsStorage,
      exportFormatter: exportFormatter,
    );
  }

  Future<void> dispose();

  Future<LoggingSettings> getSettings();

  Future<void> init();

  Future<String> prepareForExportCollectedLogs();

  Future<LoggingSettings> updateSettings({
    Optional<Level>? level,
    Optional<bool>? printToConsole,
    Optional<bool>? collectLogs,
  });
}

final class _LoggingServiceImpl implements LoggingService {
  final Logger root;
  final LoggingSettingsStorage settingsStorage;
  final LogsFormatter exportFormatter;

  StreamSubscription<LogRecord>? _recordsSub;
  Level _printLevel = Level.OFF;

  LogPrintStrategy? _printStrategy;
  CollectLogStrategy? _collectStrategy;
  LogReportingStrategy? _reportingStrategy;

  _LoggingServiceImpl({
    required this.root,
    required this.settingsStorage,
    required this.exportFormatter,
  });

  @override
  Future<void> dispose() async {
    await _recordsSub?.cancel();
    _recordsSub = null;
  }

  @override
  Future<LoggingSettings> getSettings() => settingsStorage.read();

  @override
  Future<void> init() async {
    hierarchicalLoggingEnabled = true;
    root.level = Level.ALL;

    // Do not let LoggingService fail on initialization.
    final settings = await getSettings().catchError((_) => const LoggingSettings());

    _chooseLogLevel(settings.effectiveLevel);
    _choosePrintStrategy(printToConsole: settings.effectivePrintToConsole);
    _chooseCollectStrategy(collect: settings.effectiveCollectLogs);
    _chooseReportStrategy();

    await _recordsSub?.cancel();
    _recordsSub = root.onRecord.listen(_onLogRecord);
  }

  @override
  Future<String> prepareForExportCollectedLogs() async {
    final logs = await (_collectStrategy?.getAll() ?? Future(List<LogRecord>.empty));

    return exportFormatter.format(logs);
  }

  @override
  Future<LoggingSettings> updateSettings({
    Optional<Level>? level,
    Optional<bool>? printToConsole,
    Optional<bool>? collectLogs,
  }) async {
    final settings = await getSettings();
    final updatedSettings = settings.copyWith(
      level: level,
      printToConsole: printToConsole,
      collectLogs: collectLogs,
    );

    if (updatedSettings == settings) {
      return settings;
    }

    if (level != null) {
      _chooseLogLevel(updatedSettings.effectiveLevel);
    }

    if (printToConsole != null) {
      _choosePrintStrategy(printToConsole: printToConsole.data);
    }

    if (collectLogs != null) {
      _chooseCollectStrategy(collect: collectLogs.data);
    }

    await settingsStorage.write(updatedSettings);

    return updatedSettings;
  }

  void _chooseCollectStrategy({bool? collect}) {
    _collectStrategy = switch (collect) {
      true => MemoryCollectLogStrategy(),
      null || false => null,
    };
  }

  //ignore: use_setters_to_change_properties
  void _chooseLogLevel(Level level) {
    _printLevel = level;
  }

  void _choosePrintStrategy({bool? printToConsole}) {
    _printStrategy = switch (printToConsole) {
      true => const ConsoleLogPrintStrategy(),
      null || false => null,
    };
  }

  void _chooseReportStrategy() {
    _reportingStrategy = kReleaseMode ? const SentryErrorsReportingStrategy() : null;
  }

  void _onLogRecord(LogRecord log) {
    if (log.level >= _printLevel && log.level <= Level.OFF) _printStrategy?.print(log);
    _collectStrategy?.collect(log);
    if (log.level >= Level.WARNING && log.level <= Level.OFF) _reportingStrategy?.report(log);
  }
}
