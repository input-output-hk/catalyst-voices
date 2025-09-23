import 'dart:async';
import 'dart:io';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:test/test.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  final DocumentRepository documentRepository = _MockDocumentRepository();

  late final AppMetaStorage appMetaStorage;
  late final SyncStatsStorage statsStorage;
  late final DocumentsService documentsService;
  late final CampaignService campaignService;
  late final SyncManager syncManager;

  setUpAll(() async {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();

    statsStorage = SyncStatsLocalStorage(sharedPreferences: SharedPreferencesAsync());
    appMetaStorage = AppMetaStorageLocalStorage(sharedPreferences: SharedPreferencesAsync());

    documentsService = DocumentsService(documentRepository);
    campaignService = _MockCampaignService();

    registerFallbackValue(SignedDocumentRef.first(const Uuid().v7()));

    await appMetaStorage.write(const AppMeta(activeCampaign: Campaign.f15Ref));
    when(() => campaignService.getActiveCampaign()).thenAnswer((_) => Future.value(Campaign.f15()));
  });

  setUp(() {
    syncManager = SyncManager(
      appMetaStorage,
      statsStorage,
      documentsService,
      campaignService,
    );
  });

  tearDown(() async {
    await syncManager.dispose();
    reset(documentRepository);
  });

  group(SyncManager, () {
    test('sync throws error when documents sync fails', () async {
      // Given
      final allRefs = List.generate(
        10,
        (_) => SignedDocumentRef.first(const Uuid().v7()).toTyped(DocumentType.proposalDocument),
      );
      final cachedRefs = <TypedDocumentRef>[];

      // When
      when(
        () => documentRepository.getAllDocumentsRefs(campaign: Campaign.f15()),
      ).thenAnswer((_) => Future.value(allRefs));
      when(documentRepository.getCachedDocumentsRefs).thenAnswer((_) => Future.value(cachedRefs));
      when(
        () => documentRepository.cacheDocument(ref: any(named: 'ref')),
      ).thenAnswer((_) => Future.error(const HttpException('Unknown ref')));

      // Then
      expect(
        () => syncManager.start(),
        throwsA(isA<RefsSyncException>()),
      );
    });
  });
}

class _MockCampaignService extends Mock implements CampaignService {}

class _MockDocumentRepository extends Mock implements DocumentRepository {}
