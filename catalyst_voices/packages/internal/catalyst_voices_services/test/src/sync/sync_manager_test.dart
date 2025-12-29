import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:test/test.dart';

void main() {
  late DocumentsSynchronizer synchronizer;
  late SyncStatsStorage statsStorage;

  late SyncManager syncManager;

  setUpAll(() async {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  setUp(() {
    synchronizer = _MockDocumentsSynchronizer();
    statsStorage = SyncStatsLocalStorage(sharedPreferences: SharedPreferencesAsync());

    syncManager = SyncManager(
      synchronizer,
      statsStorage,
      const CatalystProfiler.noop(),
    );
  });

  tearDown(() async {
    await syncManager.dispose();
  });

  group(SyncManager, () {});
}

class _MockDocumentsSynchronizer extends Mock implements DocumentsSynchronizer {}
