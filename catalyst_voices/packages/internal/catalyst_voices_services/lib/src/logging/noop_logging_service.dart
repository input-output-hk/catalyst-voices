import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final class NoopLoggingService implements LoggingService {
  LoggingSettings _settings = const LoggingSettings();

  @override
  Future<void> dispose() async {}

  @override
  Future<LoggingSettings> getSettings() => Future.value(_settings);

  @override
  Future<void> init() async {}

  @override
  Future<String> prepareForExportCollectedLogs() {
    return Future(() => '');
  }

  @override
  Future<LoggingSettings> updateSettings({
    Optional<Level>? level,
    Optional<bool>? printToConsole,
    Optional<bool>? collectLogs,
  }) async {
    return _settings = _settings.copyWith(printToConsole: printToConsole, collectLogs: collectLogs);
  }
}
