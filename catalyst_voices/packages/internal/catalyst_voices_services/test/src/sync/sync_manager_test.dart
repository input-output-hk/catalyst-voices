import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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

    registerFallbackValue(CampaignSyncRequest(Campaign.f15()) as DocumentsSyncRequest);
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

  group(SyncManager, () {
    test('initial state is idle', () {
      expect(syncManager.activeRequest, isNull);
      expect(syncManager.pendingRequests, isEmpty);
    });

    test('queueing a request makes it active and eventually completes', () async {
      final request = CampaignSyncRequest(Campaign.f15());

      when(
        () => synchronizer.start(any(), onProgress: any(named: 'onProgress')),
      ).thenAnswer((_) async => const DocumentsSyncResult());

      syncManager.queue(request);

      // Verify it became active
      expect(syncManager.activeRequest, equals(request));

      final result = await syncManager.waitForActiveRequest;

      expect(result, isTrue);
      expect(syncManager.activeRequest, isNull);
      verify(() => synchronizer.start(request, onProgress: any(named: 'onProgress'))).called(1);
    });

    test('multiple requests execute sequentially', () async {
      final request1 = TargetSyncRequest(SignedDocumentRef.generateFirstRef());
      final request2 = CampaignSyncRequest(Campaign.f15());

      final completer1 = Completer<DocumentsSyncResult>();
      final completer2 = Completer<DocumentsSyncResult>();

      // Request 1 will hang until we complete it
      when(
        () => synchronizer.start(request1, onProgress: any(named: 'onProgress')),
      ).thenAnswer((_) => completer1.future);
      when(
        () => synchronizer.start(request2, onProgress: any(named: 'onProgress')),
      ).thenAnswer((_) => completer2.future);

      syncManager
        ..queue(request1)
        ..queue(request2);

      // Verify first is active, second is pending
      expect(syncManager.activeRequest, equals(request1));
      expect(syncManager.pendingRequests, contains(request2));

      // Finish first request
      completer1.complete(const DocumentsSyncResult());
      await pumpEventQueue();

      // Verify second is now active
      expect(syncManager.activeRequest, equals(request2));

      completer2.complete(const DocumentsSyncResult());
      await pumpEventQueue();

      expect(syncManager.activeRequest, isNull);
    });

    test('activeRequestProgress emits correct sequence', () async {
      final request = CampaignSyncRequest(Campaign.f15());

      when(() => synchronizer.start(any(), onProgress: any(named: 'onProgress'))).thenAnswer((
        invocation,
      ) async {
        final onProgress = invocation.namedArguments[#onProgress] as void Function(double);
        onProgress(0.5);
        return const DocumentsSyncResult();
      });

      // We expect 0.0 (start), 0.5 (synchronizer update), 1.0 (finally block)
      unawaited(
        expectLater(
          syncManager.activeRequestProgress,
          emitsInOrder([0.0, 0.5, 1.0]),
        ),
      );

      syncManager.queue(request);
      await syncManager.waitForActiveRequest;
    });

    test('updates stats correctly on success', () async {
      final request = CampaignSyncRequest(Campaign.f15());
      const expectedCount = 42;

      when(
        () => synchronizer.start(any(), onProgress: any(named: 'onProgress')),
      ).thenAnswer((_) async => const DocumentsSyncResult(newDocumentsCount: expectedCount));

      syncManager.queue(request);

      await syncManager.waitForActiveRequest;

      final stats = await statsStorage.read();
      expect(stats?.lastAddedRefsCount, equals(expectedCount));
      expect(stats?.lastSuccessfulSyncAt, isNotNull);
    });

    test('recovers and continues queue after a failure', () async {
      final failingRequest = TargetSyncRequest(SignedDocumentRef.generateFirstRef());
      final succeedingRequest = CampaignSyncRequest(Campaign.f15());

      when(
        () => synchronizer.start(failingRequest, onProgress: any(named: 'onProgress')),
      ).thenThrow(Exception('Sync failed!'));
      when(
        () => synchronizer.start(succeedingRequest, onProgress: any(named: 'onProgress')),
      ).thenAnswer((_) async => const DocumentsSyncResult());

      syncManager
        ..queue(failingRequest)
        ..queue(succeedingRequest);

      // Wait for the failure to process
      final firstResult = await syncManager.waitForActiveRequest;
      expect(firstResult, isFalse);

      // Wait for next request
      expect(syncManager.activeRequest, equals(succeedingRequest));

      final secondResult = await syncManager.waitForActiveRequest;
      expect(secondResult, isTrue);
    });
  });
}

class _MockDocumentsSynchronizer extends Mock implements DocumentsSynchronizer {}
