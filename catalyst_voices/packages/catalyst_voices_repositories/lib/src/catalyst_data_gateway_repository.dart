import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/generated/catalyst_gateway/cat_gateway_api.enums.swagger.dart' as enums;
import 'package:catalyst_voices_services/generated/catalyst_gateway/cat_gateway_api.swagger.dart';
import 'package:chopper/chopper.dart';
import 'package:result_type/result_type.dart';

final class CatalystDataGatewayRepository {
  final CatGatewayApi _catGatewayApi;

  CatalystDataGatewayRepository(Uri baseUrl)
    : _catGatewayApi = CatGatewayApi.create(baseUrl: baseUrl);

  Future<Result<void, NetworkErrors>> getHealthStarted() async {
    try {
      await _catGatewayApi.apiHealthStartedGet();
      return Success(null);
    } on ChopperHttpException catch (error) {
      return Failure(_getNetworkError(error.response.statusCode));
    }
  }

  Future<Result<StakeInfo, NetworkErrors>> getCardanoStakedAdaStakeAddress({
    required String stakeAddress,
    enums.Network? network,
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

  NetworkErrors _getNetworkError(int statusCode) {
    return NetworkErrors.values.firstWhere(
      (error) => error.code == statusCode,
    );
  }
}
