import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/catalyst_data_gateway_repository.dart';
import 'package:catalyst_voices_services/generated/catalyst_gateway/cat_gateway_api.swagger.dart';
import 'package:chopper/chopper.dart' as chopper;
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'catalyst_data_gateway_repository_test.mocks.dart';


@GenerateNiceMocks([MockSpec<CatGatewayApi>()])
void main() {
  
  provideDummy(chopper.Response<dynamic>(http.Response('', 204), ''));
  final baseUrl = Uri.parse('https://localhost/api');
  late MockCatGatewayApi mockCatGatewayApi;
  late CatalystDataGatewayRepository repository;
  setUpAll(() {
    mockCatGatewayApi = MockCatGatewayApi();
    repository = CatalystDataGatewayRepository(
      baseUrl,
      catGatewayApiInstance: mockCatGatewayApi,
    );
  });
  group('CatalystDataGatewayRepository', () {
    
    test('getHealthStarted success', () async {
      when(mockCatGatewayApi.apiHealthStartedGet()).thenAnswer((_) async =>
        chopper.Response(http.Response('', 204), null),
      );
      final result = await repository.getHealthStarted();
      expect(result.isSuccess, true);
    });
    test('getHealthStarted Internal Server Error', () async {
      when(mockCatGatewayApi.apiHealthStartedGet()).thenAnswer((_) async =>
        chopper.Response(http.Response('', 500), null),
      );

      final result = await repository.getHealthStarted();

      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.internalServerError));
    });
    test('getHealthStarted Service Unavailable', () async {
      when(mockCatGatewayApi.apiHealthStartedGet()).thenAnswer((_) async =>
        chopper.Response(http.Response('', 503), null),
      );
      final result = await repository.getHealthStarted();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.serviceUnavailable));
    });
    test('getHealthReady success', () async {
      when(mockCatGatewayApi.apiHealthReadyGet()).thenAnswer((_) async =>
        chopper.Response(http.Response('', 204), null),
      );
      final result = await repository.getHealthReady();
      expect(result.isSuccess, true);
    });
    test('getHealthReady Internal Server Error', () async {
      when(mockCatGatewayApi.apiHealthReadyGet()).thenAnswer((_) async =>
        chopper.Response(http.Response('', 500), null),
      );
      final result = await repository.getHealthReady();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.internalServerError));
    });
    test('getHealthReady Service Unavailable', () async {
      when(mockCatGatewayApi.apiHealthReadyGet()).thenAnswer((_) async =>
        chopper.Response(http.Response('', 503), null),
      );
      final result = await repository.getHealthReady();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.serviceUnavailable));
    });

    test('getHealthLive success', () async {
      when(mockCatGatewayApi.apiHealthLiveGet()).thenAnswer((_) async =>
        chopper.Response(http.Response('', 204), null),
      );
      final result = await repository.getHealthLive();
      expect(result.isSuccess, true);
    });
    test('getHealthLive Internal Server Error', () async {
      when(mockCatGatewayApi.apiHealthLiveGet()).thenAnswer((_) async =>
        chopper.Response(http.Response('', 500), null),
      );
      final result = await repository.getHealthLive();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.internalServerError));
    });
    test('getHealthLive Service Unavailable', () async {
      when(mockCatGatewayApi.apiHealthLiveGet()).thenAnswer((_) async =>
        chopper.Response(http.Response('', 503), null),
      );
      final result = await repository.getHealthLive();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.serviceUnavailable));
    });

    // cspell: disable
    const validStakeAddress = 
      'stake1uyehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gh6ffgw';
    // cspell: enable
    const notValidStakeAddress = 'stake1wrong1stake';
    test('getCardanoStakedAdaStakeAddress success', () async {
      const stakeInfo = StakeInfo(
        amount: 1,
        slotNumber: 5,
      );
      provideDummy(
        chopper.Response<StakeInfo>(http.Response('', 200), stakeInfo),
      );
      when(
        mockCatGatewayApi.apiCardanoStakedAdaStakeAddressGet(
          stakeAddress: validStakeAddress,
        ),
      ).thenAnswer(
        (_) async => chopper.Response<StakeInfo>(
          http.Response('', 200), stakeInfo,
        ),
      );
      final result = await repository.getCardanoStakedAdaStakeAddress(
        stakeAddress: validStakeAddress,
      );
      expect(result.isSuccess, true);
      expect(result.success, equals(stakeInfo));
    });
    test('getCardanoStakedAdaStakeAddress Bad request', () async {
      provideDummy(chopper.Response<StakeInfo>(http.Response('', 400), null));
      when(
        mockCatGatewayApi.apiCardanoStakedAdaStakeAddressGet(
          stakeAddress: notValidStakeAddress,
        ),
      ).thenAnswer(
        (_) async => chopper.Response(http.Response('', 400), null),
      );
      final result = await repository.getCardanoStakedAdaStakeAddress(
        stakeAddress: notValidStakeAddress,
      );
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.badRequest));
    });
    test('getCardanoStakedAdaStakeAddress Not found', () async {
      provideDummy(chopper.Response<StakeInfo>(http.Response('', 404), null));
      when(
        mockCatGatewayApi.apiCardanoStakedAdaStakeAddressGet(
          stakeAddress: notValidStakeAddress,
        ),
      ).thenAnswer(
        (_) async => chopper.Response(http.Response('', 404), null),
      );
      final result = await repository.getCardanoStakedAdaStakeAddress(
        stakeAddress: notValidStakeAddress,
      );
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.notFound));
    });
    test('getCardanoStakedAdaStakeAddress Server Error', () async {
      provideDummy(chopper.Response<StakeInfo>(http.Response('', 500), null));
      when(
        mockCatGatewayApi.apiCardanoStakedAdaStakeAddressGet(
          stakeAddress: validStakeAddress,
        ),
      ).thenAnswer(
        (_) async => chopper.Response(http.Response('', 500), null),
      );
      final result = await repository.getCardanoStakedAdaStakeAddress(
        stakeAddress: validStakeAddress,
      );
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.internalServerError));
    });
    test('getCardanoStakedAdaStakeAddress Service Unavailable', () async {
      provideDummy(chopper.Response<StakeInfo>(http.Response('', 503), null));
      when(
        mockCatGatewayApi.apiCardanoStakedAdaStakeAddressGet(
          stakeAddress: validStakeAddress,
        ),
      ).thenAnswer(
        (_) async => chopper.Response(http.Response('', 503), null),
      );
      final result = await repository.getCardanoStakedAdaStakeAddress(
        stakeAddress: validStakeAddress,
      );
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.serviceUnavailable));
    });
    test('getCardanoSyncState success', () async {
      final syncState = SyncState(
        slotNumber: 5,
        blockHash: 
          '0x0000000000000000000000000000000000000000000000000000000000000000',
        lastUpdated: DateTime.utc(1970),
      );
      provideDummy(
        chopper.Response<SyncState>(http.Response('', 200), syncState),
      );
      when(
        mockCatGatewayApi.apiCardanoSyncStateGet(),
      ).thenAnswer(
        (_) async => chopper.Response(http.Response('', 200), syncState),
      );
      final result = await repository.getCardanoSyncState();
      expect(result.isSuccess, true);
      expect(result.success, equals(syncState));
    });
    test('getCardanoSyncState Server Error', () async {
      provideDummy(chopper.Response<SyncState>(http.Response('', 500), null));
      when(
        mockCatGatewayApi.apiCardanoSyncStateGet(),
      ).thenAnswer(
        (_) async => chopper.Response(http.Response('', 500), null),
      );
      final result = await repository.getCardanoSyncState();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.internalServerError));
    });
    test('getCardanoSyncState Service Unavailable', () async {
      provideDummy(chopper.Response<SyncState>(http.Response('', 503), null));
      when(
        mockCatGatewayApi.apiCardanoSyncStateGet(),
      ).thenAnswer(
        (_) async => chopper.Response(http.Response('', 503), null),
      );
      final result = await repository.getCardanoSyncState();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.serviceUnavailable));
    });
  });
}
