import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.enums.swagger.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/api/local/local_documents_cat_gateway_mixin.dart';
import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

final class LocalCatGateway with LocalDocumentsCatGatewayMixin implements CatGateway {
  @override
  ChopperClient client;

  factory LocalCatGateway.create({
    // ignore: avoid_unused_constructor_parameters
    ChopperClient? client,
    // ignore: avoid_unused_constructor_parameters
    http.Client? httpClient,
    // ignore: avoid_unused_constructor_parameters
    Authenticator? authenticator,
    // ignore: avoid_unused_constructor_parameters
    ErrorConverter? errorConverter,
    // ignore: avoid_unused_constructor_parameters
    Converter? converter,
    // ignore: avoid_unused_constructor_parameters
    Uri? baseUrl,
    // ignore: avoid_unused_constructor_parameters
    List<Interceptor>? interceptors,
  }) {
    return LocalCatGateway._(ChopperClient());
  }

  LocalCatGateway._(this.client);

  @override
  Type get definitionType => CatGateway;

  @override
  Future<Response<FullStakeInfo>> apiGatewayV1CardanoAssetsStakeAddressGet({
    required String? stakeAddress,
    Network? network,
    String? asat,
    dynamic authorization,
    dynamic contentType,
  }) async {
    const body = FullStakeInfo(
      volatile: StakeInfo(
        adaAmount: 9992646426,
        slotNumber: 104243495,
        assets: [],
      ),
      persistent: StakeInfo(
        adaAmount: 9992646426,
        slotNumber: 104243495,
        assets: [],
      ),
    );
    return Response<FullStakeInfo>(http.Response('{}', 200), body);
  }

  @override
  Future<Response<Object>> apiGatewayV1ConfigFrontendGet({
    dynamic authorization,
    dynamic contentType,
  }) async {
    return Response<Object>(http.Response('{}', 200), const <String, dynamic>{});
  }

  @override
  Future<Response<dynamic>> apiGatewayV1HealthLiveGet({
    dynamic authorization,
    dynamic contentType,
  }) async {
    return Response<Object>(http.Response('{}', 500), const <String, dynamic>{});
  }

  @override
  Future<Response<dynamic>> apiGatewayV1HealthReadyGet({
    dynamic authorization,
    dynamic contentType,
  }) async {
    return Response<Object>(http.Response('{}', 500), const <String, dynamic>{});
  }

  @override
  Future<Response<dynamic>> apiGatewayV1HealthStartedGet({
    dynamic authorization,
    dynamic contentType,
  }) async {
    return Response<Object>(http.Response('{}', 500), const <String, dynamic>{});
  }

  @override
  Future<Response<RbacRegistrationChain>> apiGatewayV1RbacRegistrationGet({
    String? lookup,
    dynamic authorization,
    dynamic contentType,
  }) async {
    final body = RbacRegistrationChain(
      catalystId: lookup!,
      lastPersistentTxn: '0x784433f2735daf8d2cc28c383c49f195cbe7913c8e242cc47d900a11407e3ced',
      purpose: ['ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c'],
      roles: {
        '0': {
          'payment_addresses': [
            {
              'address':
                  'addr_test1qpmezqgmgrpr79yltv05nrxzcfz4x5cmq936wftp5zvdz34fe77rv376n6wqpuf77es9t2xlwx5cmf0grv47ted2m3yqdfy2ra',
              'is_persistent': true,
              'time': '2025-10-08T12:31:35+00:00',
            },
          ],
          'signing_keys': [
            {
              'is_persistent': true,
              'key_type': 'x509',
              'key_value':
                  '0x308201173081caa00302010202046c59e362300506032b657030003022180f32303235313030383132333130375a180f39393939313233313233353935395a3000302a300506032b65700321007acd769a3df35a98921901b8bba58b0c7d284a1a439c5b4aba7e68de3b1195f6a3623060305e0603551d110457305586537765622b63617264616e6f3a2f2f616464722f7374616b655f7465737431757a35756c30706b676c64666138717137796c3076637a343472306872327664356835706b326c39756b3464636a71706b63736d37300506032b657003410045a38c8c40ec45786d9add539853cd461b7b98ae150b07c61f5f954647d95b358b35e7b96a1cc4d047b41b491c27d19306f682f7c3fcbc48318b13742b93da0d',
              'time': '2025-10-08T12:31:35+00:00',
            },
          ],
        },
        '3': {
          'payment_addresses': [
            {
              'address':
                  'addr_test1qpmezqgmgrpr79yltv05nrxzcfz4x5cmq936wftp5zvdz34fe77rv376n6wqpuf77es9t2xlwx5cmf0grv47ted2m3yqdfy2ra',
              'is_persistent': true,
              'time': '2025-10-08T12:31:35+00:00',
            },
          ],
          'signing_keys': [
            {
              'is_persistent': true,
              'key_type': 'pubkey',
              'key_value': '0x4dc09a04607b6915424f22ee815dcc9b18213f49d8ed4bd231bc9d040eb248ae',
              'time': '2025-10-08T12:31:35+00:00',
            },
          ],
        },
      },
    );
    return Response<RbacRegistrationChain>(
      http.Response('{}', 200),
      body,
    );
  }

  @override
  Future<Response<dynamic>> apiGatewayV2DocumentIndexPost({
    int? page,
    int? limit,
    dynamic authorization,
    dynamic contentType,
    required DocumentIndexQueryFilterV2? body,
  }) async {
    return Response<Object>(http.Response('{}', 500), const <String, dynamic>{});
  }

  @override
  Future<Response<RbacRegistrationChainV2>> apiGatewayV2RbacRegistrationGet({
    String? lookup,
    bool? showAllInvalid,
    dynamic authorization,
    dynamic contentType,
  }) async {
    final body = RbacRegistrationChainV2(
      catalystId: lookup!,
      purpose: [],
      roles: [],
      invalid: [],
      stakeAddresses: [],
    );

    return Response<RbacRegistrationChainV2>(http.Response('{}', 500), body);
  }
}
