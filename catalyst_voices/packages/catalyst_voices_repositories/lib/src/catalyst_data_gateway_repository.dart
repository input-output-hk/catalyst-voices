import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/generated/catalyst_gateway/cat_gateway_api.enums.swagger.dart'
    as enums;
import 'package:catalyst_voices_services/generated/catalyst_gateway/cat_gateway_api.swagger.dart';
import 'package:chopper/chopper.dart';
import 'package:result_type/result_type.dart';

// The [CatalystDataGatewayRepository] provides a structured interface to
// interact with the `catalyst-gateway` backend API.
// Network communication and error handling is abstracted allowing the
// integration of API calls in an easy way.
// All methods return `Future` objects to allow async execution.
//
// The repository uses, under the hood, the [CatGatewayApi] directly generated
// from backend OpenAPI specification.
//
// To use the repository is necessary to initialize it by specifying the API
// base URL:
//
// ```dart
// final repository = CatalystDataGatewayRepository(Uri.parse('https://example.org/api'));
// ```
//
// Once initialized it is possible, for example, to check the health status of
// the service:
//
// ```dart
// final health_status = await repository.getHealthLive();
// ```
//
// fetch staked ADA by stake address:
//
// ```dart
// final stake_info = await repository.getCardanoStakedAdaStakeAddress(
//   // cspell: disable-next-line
//   stakeAddress:'stake1uyehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gh6ffgw',
// );
// ```
//
// or get the sync state:
//
// ```dart
// final sync_state = await repository.getCardanoSyncState();
// ```

final class CatalystDataGatewayRepository {
  final CatGatewayApi _catGatewayApi;

  CatalystDataGatewayRepository(
    Uri baseUrl, {
    CatGatewayApi? catGatewayApiInstance,
  }) : _catGatewayApi =
            catGatewayApiInstance ?? CatGatewayApi.create(baseUrl: baseUrl);

  Future<Result<void, NetworkErrors>> getHealthStarted() async {
    try {
      final heathStarted = await _catGatewayApi.apiHealthStartedGet();
      return _emptyBodyOrThrow(heathStarted);
    } on ChopperHttpException catch (error) {
      return Failure(_getNetworkError(error.response.statusCode));
    }
  }

  Future<Result<void, NetworkErrors>> getHealthReady() async {
    try {
      final heathReady = await _catGatewayApi.apiHealthReadyGet();
      return _emptyBodyOrThrow(heathReady);
    } on ChopperHttpException catch (error) {
      return Failure(_getNetworkError(error.response.statusCode));
    }
  }

  Future<Result<void, NetworkErrors>> getHealthLive() async {
    try {
      final healthLive = await _catGatewayApi.apiHealthLiveGet();
      return _emptyBodyOrThrow(healthLive);
    } on ChopperHttpException catch (error) {
      return Failure(_getNetworkError(error.response.statusCode));
    }
  }

  Future<Result<FullStakeInfo, NetworkErrors>> getCardanoStakedAdaStakeAddress({
    required String stakeAddress,
    enums.Network network = enums.Network.mainnet,
    int? slotNumber,
  }) async {
    try {
      final stakeInfo = await _catGatewayApi.apiCardanoStakedAdaStakeAddressGet(
        stakeAddress: stakeAddress,
        network: network,
        slotNumber: slotNumber,
      );
      return Success(stakeInfo.bodyOrThrow);
    } on ChopperHttpException catch (error) {
      return Failure(_getNetworkError(error.response.statusCode));
    }
  }

  Future<Result<SyncState, NetworkErrors>> getCardanoSyncState({
    enums.Network network = enums.Network.mainnet,
  }) async {
    try {
      final syncState = await _catGatewayApi.apiCardanoSyncStateGet(
        network: network,
      );
      return Success(syncState.bodyOrThrow);
    } on ChopperHttpException catch (error) {
      return Failure(_getNetworkError(error.response.statusCode));
    }
  }

  NetworkErrors _getNetworkError(int statusCode) {
    return NetworkErrors.values.firstWhere(
      (error) => error.code == statusCode,
    );
  }

  Result<void, NetworkErrors> _emptyBodyOrThrow(Response<dynamic> response) {
    // `bodyOrThrow` from chopper can't be used when the body is empty (like in
    // case the endpoint replies with 204) because it would throw an exception
    // as a false positive.
    if (response.isSuccessful) {
      return Success(null);
    }
    throw ChopperHttpException(response);
  }
}
