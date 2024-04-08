import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/catalyst_data_gateway_repository.dart';
import 'package:catalyst_voices_services/generated/catalyst_gateway/cat_gateway_api.swagger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:result_type/result_type.dart';
import 'package:test/test.dart';

import 'catalyst_data_gateway_repository_test.mocks.dart';


@GenerateNiceMocks([MockSpec<CatalystDataGatewayRepository>()])
void main() {
  group('CatalystDataGatewayRepository', () {
    final mock = MockCatalystDataGatewayRepository();
    test('getHealthStarted success', () async {
      when(mock.getHealthStarted()).thenAnswer((_) async => Success(null));
      final result = await mock.getHealthStarted();
      expect(result.isSuccess, true);
    });
    test('getHealthStarted Internal Server Error', () async {
      when(mock.getHealthStarted()).thenAnswer((_) async {
        return Failure(NetworkErrors.internalServerError);
      });

      final result = await mock.getHealthStarted();

      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.internalServerError));
    });
    test('getHealthStarted Service Unavailable', () async {
      when(mock.getHealthStarted()).thenAnswer((_) async {
        return Failure(NetworkErrors.serviceUnavailable);
      });
      final result = await mock.getHealthStarted();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.serviceUnavailable));
    });

    test('getHealthReady success', () async {
      when(mock.getHealthReady()).thenAnswer((_) async => Success(null));
      final result = await mock.getHealthReady();
      expect(result.isSuccess, true);
    });
    test('getHealthReady Internal Server Error', () async {
      when(mock.getHealthReady()).thenAnswer((_) async {
        return Failure(NetworkErrors.internalServerError);
      });
      final result = await mock.getHealthReady();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.internalServerError));
    });
    test('getHealthReady Service Unavailable', () async {
      when(mock.getHealthReady()).thenAnswer((_) async {
        return Failure(NetworkErrors.serviceUnavailable);
      });
      final result = await mock.getHealthReady();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.serviceUnavailable));
    });

    test('getHealthLive success', () async {
      when(mock.getHealthLive()).thenAnswer((_) async => Success(null));
      final result = await mock.getHealthLive();
      expect(result.isSuccess, true);
    });
    test('getHealthLive Internal Server Error', () async {
      when(mock.getHealthLive()).thenAnswer((_) async {
        return Failure(NetworkErrors.internalServerError);
      });
      final result = await mock.getHealthLive();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.internalServerError));
    });
    test('getHealthLive Service Unavailable', () async {
      when(mock.getHealthLive()).thenAnswer((_) async {
        return Failure(NetworkErrors.serviceUnavailable);
      });
      final result = await mock.getHealthLive();
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
      when(
        mock.getCardanoStakedAdaStakeAddress(
          stakeAddress: validStakeAddress,
        ),
      ).thenAnswer((_) async => Success(stakeInfo));
      final result = await mock.getCardanoStakedAdaStakeAddress(
        stakeAddress: validStakeAddress,
      );
      expect(result.isSuccess, true);
      expect(result.success, equals(stakeInfo));
    });
    test('getCardanoStakedAdaStakeAddress Bad request', () async {
      when(
        mock.getCardanoStakedAdaStakeAddress(
          stakeAddress: notValidStakeAddress,
        ),
      ).thenAnswer((_) async {
        return Failure(NetworkErrors.badRequest);
      });
      final result = await mock.getCardanoStakedAdaStakeAddress(
        stakeAddress: notValidStakeAddress,
      );
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.badRequest));
    });
    test('getCardanoStakedAdaStakeAddress Not found', () async {
      when(
        mock.getCardanoStakedAdaStakeAddress(
          stakeAddress: validStakeAddress,
        ),
      ).thenAnswer((_) async {
        return Failure(NetworkErrors.notFound);
      });
      final result = await mock.getCardanoStakedAdaStakeAddress(
        stakeAddress: validStakeAddress,
      );
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.notFound));
    });
    test('getCardanoStakedAdaStakeAddress Server Error', () async {
      when(
        mock.getCardanoStakedAdaStakeAddress(
          stakeAddress: validStakeAddress,
        ),
      ).thenAnswer((_) async {
        return Failure(NetworkErrors.internalServerError);
      });
      final result = await mock.getCardanoStakedAdaStakeAddress(
        stakeAddress: validStakeAddress,
      );
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.internalServerError));
    });

    test('getCardanoStakedAdaStakeAddress Service Unavailable', () async {
      when(mock.getCardanoStakedAdaStakeAddress(
        stakeAddress: validStakeAddress,
      ),).thenAnswer((_) async {
        return Failure(NetworkErrors.serviceUnavailable);
      });
      final result = await mock.getCardanoStakedAdaStakeAddress(
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
      when(mock.getCardanoSyncState()).thenAnswer(
        (_) async => Success(syncState),
      );
      final result = await mock.getCardanoSyncState();
      expect(result.isSuccess, true);
      expect(result.success, equals(syncState));
    });
    test('getCardanoSyncState Server Error', () async {
      when(mock.getCardanoSyncState()).thenAnswer(
        (_) async => Failure(NetworkErrors.internalServerError),
      );
      final result = await mock.getCardanoSyncState();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.internalServerError));
    });
    test('getCardanoSyncState Service Unavailable', () async {
      when(mock.getCardanoSyncState()).thenAnswer(
        (_) async => Failure(NetworkErrors.serviceUnavailable),
      );
      final result = await mock.getCardanoSyncState();
      expect(result.isFailure, true);
      expect(result.failure, equals(NetworkErrors.serviceUnavailable));
    });

  });
}
