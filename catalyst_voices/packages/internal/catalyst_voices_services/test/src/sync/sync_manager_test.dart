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
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  late AppMetaStorage appMetaStorage;
  late SyncStatsStorage statsStorage;
  late DocumentsService documentsService;
  late CampaignService campaignService;
  late SyncManager syncManager;

  setUpAll(() async {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();

    registerFallbackValue(Campaign.f15());
    registerFallbackValue(const Uuid().v7());
    registerFallbackValue(SignedDocumentRef.first(const Uuid().v7()));
  });

  setUp(() {
    statsStorage = SyncStatsLocalStorage(sharedPreferences: SharedPreferencesAsync());
    appMetaStorage = AppMetaStorageLocalStorage(sharedPreferences: SharedPreferencesAsync());

    documentsService = _MockDocumentsService();
    campaignService = _MockCampaignService();

    syncManager = SyncManager(
      appMetaStorage,
      statsStorage,
      documentsService,
      campaignService,
      const CatalystProfiler.noop(),
    );
  });

  tearDown(() async {
    await syncManager.dispose();
  });

  group(SyncManager, () {
    group('start', () {
      test(
        'given active campaign, '
        'when start is called, '
        'then it syncs documents and updates stats',
        () async {
          // Given
          final campaign = Campaign.f15();
          when(() => campaignService.getActiveCampaign()).thenAnswer((_) async => campaign);
          when(
            () => documentsService.clear(keepLocalDrafts: any(named: 'keepLocalDrafts')),
          ).thenAnswer((_) async => 0);

          when(
            () => documentsService.sync(
              campaign: any(named: 'campaign'),
              onProgress: any(named: 'onProgress'),
            ),
          ).thenAnswer(
            (_) async => const DocumentsSyncResult(
              newDocumentsCount: 5,
              // ignore: avoid_redundant_argument_values
              failedDocumentsCount: 0,
            ),
          );

          // When
          await syncManager.start();
          final success = await syncManager.waitForSync;

          // Then
          expect(success, isTrue);

          verify(
            () => documentsService.sync(
              campaign: campaign,
              onProgress: any(named: 'onProgress'),
            ),
          ).called(1);

          final stats = await statsStorage.read();
          expect(stats?.lastAddedRefsCount, 5);
          expect(stats?.lastSuccessfulSyncAt, isNotNull);
        },
      );

      test(
        'given stored campaign differs from active campaign, '
        'when start is called, '
        'then it clears local storage and updates active campaign',
        () async {
          // Given
          const oldCampaignId = SignedDocumentRef.first('campaign_old');
          await appMetaStorage.write(const AppMeta(activeCampaign: oldCampaignId));

          final newCampaign = Campaign.f15();
          when(() => campaignService.getActiveCampaign()).thenAnswer((_) async => newCampaign);

          when(
            () => documentsService.clear(keepLocalDrafts: any(named: 'keepLocalDrafts')),
          ).thenAnswer((_) async => 0);

          when(
            () => documentsService.sync(
              campaign: any(named: 'campaign'),
              onProgress: any(named: 'onProgress'),
            ),
          ).thenAnswer((_) async => const DocumentsSyncResult());

          // When
          await syncManager.start();

          // Then
          verify(() => documentsService.clear(keepLocalDrafts: true)).called(1);

          final storedMeta = await appMetaStorage.read();
          expect(storedMeta.activeCampaign, newCampaign.id);
        },
      );

      test(
        'given documents service throws error, '
        'when start is called, '
        'then it rethrows error and completes waitForSync with false',
        () async {
          // Given
          when(() => campaignService.getActiveCampaign()).thenAnswer((_) async => Campaign.f15());

          when(
            () => documentsService.sync(
              campaign: any(named: 'campaign'),
              onProgress: any(named: 'onProgress'),
            ),
          ).thenThrow(Exception('Sync failed'));

          // When & Then
          // Expect the immediate future to fail (rethrow)
          expect(syncManager.start(), throwsException);

          // Wait to ensure internal state settles (if needed)
          try {
            await syncManager.waitForSync;
          } catch (_) {}

          // Verify the completer status
          expect(await syncManager.waitForSync, isFalse);
        },
      );

      test(
        'given sync is already in progress, '
        'when start is called again, '
        'then second call is ignored (locked)',
        () async {
          // Given
          when(() => campaignService.getActiveCampaign()).thenAnswer((_) async => Campaign.f15());

          final syncCompleter = Completer<DocumentsSyncResult>();
          when(
            () => documentsService.sync(
              campaign: any(named: 'campaign'),
              onProgress: any(named: 'onProgress'),
            ),
          ).thenAnswer((_) => syncCompleter.future);

          // When
          final firstCall = syncManager.start();
          final secondCall = syncManager.start(); // This should be locked

          syncCompleter.complete(const DocumentsSyncResult());
          await firstCall;
          await secondCall;

          // Then
          verify(
            () => documentsService.sync(
              campaign: any(named: 'campaign'),
              onProgress: any(named: 'onProgress'),
            ),
          ).called(1);
        },
      );
    });
  });
}

class _MockCampaignService extends Mock implements CampaignService {}

class _MockDocumentsService extends Mock implements DocumentsService {}
