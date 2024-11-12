// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'cat_gateway_api.models.swagger.dart';
import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;
import 'cat_gateway_api.enums.swagger.dart' as enums;
export 'cat_gateway_api.enums.swagger.dart';
export 'cat_gateway_api.models.swagger.dart';

part 'cat_gateway_api.swagger.chopper.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class CatGatewayApi extends ChopperService {
  static CatGatewayApi create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    Iterable<dynamic>? interceptors,
  }) {
    if (client != null) {
      return _$CatGatewayApi(client);
    }

    final newClient = ChopperClient(
        services: [_$CatGatewayApi()],
        converter: converter ?? $JsonSerializableConverter(),
        interceptors: interceptors ?? [],
        client: httpClient,
        authenticator: authenticator,
        errorConverter: errorConverter,
        baseUrl: baseUrl ?? Uri.parse('http://'));
    return _$CatGatewayApi(newClient);
  }

  ///Service Started
  Future<chopper.Response> apiV1HealthStartedGet() {
    return _apiV1HealthStartedGet();
  }

  ///Service Started
  @Get(path: '/api/v1/health/started')
  Future<chopper.Response> _apiV1HealthStartedGet();

  ///Service Ready
  Future<chopper.Response> apiV1HealthReadyGet() {
    return _apiV1HealthReadyGet();
  }

  ///Service Ready
  @Get(path: '/api/v1/health/ready')
  Future<chopper.Response> _apiV1HealthReadyGet();

  ///Service Live
  Future<chopper.Response> apiV1HealthLiveGet() {
    return _apiV1HealthLiveGet();
  }

  ///Service Live
  @Get(path: '/api/v1/health/live')
  Future<chopper.Response> _apiV1HealthLiveGet();

  ///Service Inspection Control.
  ///@param log_level The log level to use for the service.  Controls what detail gets logged.
  ///@param query_inspection Enable or disable Verbose Query inspection in the logs.  Used to find query performance issues.
  Future<chopper.Response> apiV1HealthInspectionPut({
    enums.LogLevel? logLevel,
    enums.DeepQueryInspectionFlag? queryInspection,
  }) {
    return _apiV1HealthInspectionPut(
        logLevel: logLevel?.value?.toString(),
        queryInspection: queryInspection?.value?.toString());
  }

  ///Service Inspection Control.
  ///@param log_level The log level to use for the service.  Controls what detail gets logged.
  ///@param query_inspection Enable or disable Verbose Query inspection in the logs.  Used to find query performance issues.
  @Put(
    path: '/api/v1/health/inspection',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1HealthInspectionPut({
    @Query('log_level') String? logLevel,
    @Query('query_inspection') String? queryInspection,
  });

  ///Voter's info
  ///@param voting_key A Voters Public ED25519 Key (as registered in their most recent valid [CIP-15](https://cips.cardano.org/cips/cip15) or [CIP-36](https://cips.cardano.org/cips/cip36) registration).
  ///@param event_index The Event Index to return results for. See [GET Events](Link to events endpoint) for details on retrieving all valid event IDs.
  ///@param with_delegators If this optional flag is set, the response will include the delegator's list in the response. Otherwise, it will be omitted.
  @deprecated
  Future<chopper.Response<VoterRegistration>>
      apiV1RegistrationVoterVotingKeyGet({
    required String? votingKey,
    int? eventIndex,
    bool? withDelegators,
  }) {
    generatedMapping.putIfAbsent(
        VoterRegistration, () => VoterRegistration.fromJsonFactory);

    return _apiV1RegistrationVoterVotingKeyGet(
        votingKey: votingKey,
        eventIndex: eventIndex,
        withDelegators: withDelegators);
  }

  ///Voter's info
  ///@param voting_key A Voters Public ED25519 Key (as registered in their most recent valid [CIP-15](https://cips.cardano.org/cips/cip15) or [CIP-36](https://cips.cardano.org/cips/cip36) registration).
  ///@param event_index The Event Index to return results for. See [GET Events](Link to events endpoint) for details on retrieving all valid event IDs.
  ///@param with_delegators If this optional flag is set, the response will include the delegator's list in the response. Otherwise, it will be omitted.
  @deprecated
  @Get(path: '/api/v1/registration/voter/{voting_key}')
  Future<chopper.Response<VoterRegistration>>
      _apiV1RegistrationVoterVotingKeyGet({
    @Path('voting_key') required String? votingKey,
    @Query('event_index') int? eventIndex,
    @Query('with_delegators') bool? withDelegators,
  });

  ///Posts a signed transaction.
  @deprecated
  Future<chopper.Response<FragmentsProcessingSummary>> apiV0MessagePost(
      {required Object? body}) {
    generatedMapping.putIfAbsent(FragmentsProcessingSummary,
        () => FragmentsProcessingSummary.fromJsonFactory);

    return _apiV0MessagePost(body: body);
  }

  ///Posts a signed transaction.
  @deprecated
  @Post(
    path: '/api/v0/message',
    optionalBody: true,
  )
  Future<chopper.Response<FragmentsProcessingSummary>> _apiV0MessagePost(
      {@Body() required Object? body});

  ///Get all active vote plans endpoint.
  @deprecated
  Future<chopper.Response<List<VotePlan>>> apiV0VoteActivePlansGet() {
    generatedMapping.putIfAbsent(VotePlan, () => VotePlan.fromJsonFactory);

    return _apiV0VoteActivePlansGet();
  }

  ///Get all active vote plans endpoint.
  @deprecated
  @Get(path: '/api/v0/vote/active/plans')
  Future<chopper.Response<List<VotePlan>>> _apiV0VoteActivePlansGet();

  ///Get Account Votes
  ///@param account_id A account ID to get the votes for.
  @deprecated
  Future<chopper.Response<List<AccountVote>>>
      apiV1VotesPlanAccountVotesAccountIdGet({required String? accountId}) {
    generatedMapping.putIfAbsent(
        AccountVote, () => AccountVote.fromJsonFactory);

    return _apiV1VotesPlanAccountVotesAccountIdGet(accountId: accountId);
  }

  ///Get Account Votes
  ///@param account_id A account ID to get the votes for.
  @deprecated
  @Get(path: '/api/v1/votes/plan/account-votes/{account_id}')
  Future<chopper.Response<List<AccountVote>>>
      _apiV1VotesPlanAccountVotesAccountIdGet(
          {@Path('account_id') required String? accountId});

  ///Process fragments
  @deprecated
  Future<chopper.Response<FragmentsProcessingSummary>> apiV1FragmentsPost(
      {required FragmentsBatch? body}) {
    generatedMapping.putIfAbsent(FragmentsProcessingSummary,
        () => FragmentsProcessingSummary.fromJsonFactory);

    return _apiV1FragmentsPost(body: body);
  }

  ///Process fragments
  @deprecated
  @Post(
    path: '/api/v1/fragments',
    optionalBody: true,
  )
  Future<chopper.Response<FragmentsProcessingSummary>> _apiV1FragmentsPost(
      {@Body() required FragmentsBatch? body});

  ///Get Fragment Statuses
  ///@param fragment_ids Comma-separated list of fragment ids for which the statuses will be retrieved.
  @deprecated
  Future<chopper.Response<Object>> apiV1FragmentsStatusesGet(
      {required List<String>? fragmentIds}) {
    return _apiV1FragmentsStatusesGet(fragmentIds: fragmentIds);
  }

  ///Get Fragment Statuses
  ///@param fragment_ids Comma-separated list of fragment ids for which the statuses will be retrieved.
  @deprecated
  @Get(path: '/api/v1/fragments/statuses')
  Future<chopper.Response<Object>> _apiV1FragmentsStatusesGet(
      {@Query('fragment_ids') required List<String>? fragmentIds});
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
      chopper.Response response) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
          body: DateTime.parse((response.body as String).replaceAll('"', ''))
              as ResultType);
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);
