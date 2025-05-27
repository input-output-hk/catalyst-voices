import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// All of settings are null by default and should
/// become not null only after conscious decision from user.
///
/// Nulls should fallback to default values.
final class LoggingSettings extends Equatable {
  final bool? printToConsole;
  final Level? level;
  final bool? collectLogs;

  const LoggingSettings({
    this.printToConsole,
    this.level,
    this.collectLogs,
  });

  bool get effectiveCollectLogs => collectLogs ?? false;

  Level get effectiveLevel => level ?? (kDebugMode ? Level.FINER : Level.OFF);

  bool get effectivePrintToConsole => printToConsole ?? kDebugMode;

  @override
  List<Object?> get props => [
        printToConsole,
        level,
        collectLogs,
      ];

  LoggingSettings copyWith({
    Optional<bool>? printToConsole,
    Optional<Level>? level,
    Optional<bool>? collectLogs,
  }) {
    return LoggingSettings(
      printToConsole: printToConsole.dataOr(this.printToConsole),
      level: level.dataOr(this.level),
      collectLogs: collectLogs.dataOr(this.collectLogs),
    );
  }
}
