import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/generated/catalyst_gateway/cat_gateway_api.enums.swagger.dart' as enums;
import 'package:catalyst_voices_services/generated/catalyst_gateway/cat_gateway_api.swagger.dart';
import 'package:chopper/chopper.dart';
import 'package:result_type/result_type.dart';

interface class CatalystDataGatewayRepository {
  final CatGatewayApi _catGatewayApi;

  CatalystDataGatewayRepository(Uri baseUrl)
    : _catGatewayApi = CatGatewayApi.create(baseUrl: baseUrl);

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

  Future<Result<StakeInfo, NetworkErrors>> getCardanoStakedAdaStakeAddress({
    required String stakeAddress,
    enums.Network network = enums.Network.mainnet,
    DateTime? dateTime,
  }) async {
    try {
      final stakeInfo = await _catGatewayApi.apiCardanoStakedAdaStakeAddressGet(
        stakeAddress: stakeAddress,
        network: network,
        dateTime: dateTime,
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
