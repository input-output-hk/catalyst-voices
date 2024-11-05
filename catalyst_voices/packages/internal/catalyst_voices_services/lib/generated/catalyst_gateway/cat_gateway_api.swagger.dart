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

  ///Get registration info.
  ///@param stake_address The stake address of the user. Should be a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
  ///@param network Cardano network type. If omitted network type is identified from the stake address. If specified it must be correspondent to the network type encoded in the stake address. As `preprod` and `preview` network types in the stake address encoded as a `testnet`, to specify `preprod` or `preview` network type use this query parameter.
  ///@param slot_number Slot number at which the staked ADA amount should be calculated. If omitted latest slot number is used.
  Future<chopper.Response<RegistrationInfo>>
      apiDraftCardanoRegistrationStakeAddressGet({
    required String? stakeAddress,
    enums.Network? network,
    int? slotNumber,
  }) {
    generatedMapping.putIfAbsent(
        RegistrationInfo, () => RegistrationInfo.fromJsonFactory);

    return _apiDraftCardanoRegistrationStakeAddressGet(
        stakeAddress: stakeAddress,
        network: network?.value?.toString(),
        slotNumber: slotNumber);
  }

  ///Get registration info.
  ///@param stake_address The stake address of the user. Should be a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
  ///@param network Cardano network type. If omitted network type is identified from the stake address. If specified it must be correspondent to the network type encoded in the stake address. As `preprod` and `preview` network types in the stake address encoded as a `testnet`, to specify `preprod` or `preview` network type use this query parameter.
  ///@param slot_number Slot number at which the staked ADA amount should be calculated. If omitted latest slot number is used.
  @Get(path: '/api/draft/cardano/registration/{stake_address}')
  Future<chopper.Response<RegistrationInfo>>
      _apiDraftCardanoRegistrationStakeAddressGet({
    @Path('stake_address') required String? stakeAddress,
    @Query('network') String? network,
    @Query('slot_number') int? slotNumber,
  });

  ///Get Cardano follower's sync state.
  ///@param network Cardano network type. If omitted `mainnet` network type is defined. As `preprod` and `preview` network types in the stake address encoded as a `testnet`, to specify `preprod` or `preview` network type use this query parameter.
  Future<chopper.Response<SyncState>> apiDraftCardanoSyncStateGet(
      {enums.Network? network}) {
    generatedMapping.putIfAbsent(SyncState, () => SyncState.fromJsonFactory);

    return _apiDraftCardanoSyncStateGet(network: network?.value?.toString());
  }

  ///Get Cardano follower's sync state.
  ///@param network Cardano network type. If omitted `mainnet` network type is defined. As `preprod` and `preview` network types in the stake address encoded as a `testnet`, to specify `preprod` or `preview` network type use this query parameter.
  @Get(path: '/api/draft/cardano/sync_state')
  Future<chopper.Response<SyncState>> _apiDraftCardanoSyncStateGet(
      {@Query('network') String? network});

  ///Get Cardano slot info to the provided date-time.
  ///@param date_time The date-time for which the slot number should be calculated. If omitted current date time is used.
  ///@param network Cardano network type. If omitted `mainnet` network type is defined. As `preprod` and `preview` network types in the stake address encoded as a `testnet`, to specify `preprod` or `preview` network type use this query parameter.
  Future<chopper.Response<SlotInfo>> apiDraftCardanoDateTimeToSlotNumberGet({
    DateTime? dateTime,
    enums.Network? network,
  }) {
    generatedMapping.putIfAbsent(SlotInfo, () => SlotInfo.fromJsonFactory);

    return _apiDraftCardanoDateTimeToSlotNumberGet(
        dateTime: dateTime, network: network?.value?.toString());
  }

  ///Get Cardano slot info to the provided date-time.
  ///@param date_time The date-time for which the slot number should be calculated. If omitted current date time is used.
  ///@param network Cardano network type. If omitted `mainnet` network type is defined. As `preprod` and `preview` network types in the stake address encoded as a `testnet`, to specify `preprod` or `preview` network type use this query parameter.
  @Get(path: '/api/draft/cardano/date_time_to_slot_number')
  Future<chopper.Response<SlotInfo>> _apiDraftCardanoDateTimeToSlotNumberGet({
    @Query('date_time') DateTime? dateTime,
    @Query('network') String? network,
  });

  ///Get latest CIP36 registrations from stake address.
  ///@param stake_pub_key Stake Public Key to find the latest registration for.
  Future<chopper.Response<Cip36Reporting>>
      apiDraftCardanoCip36LatestRegistrationStakeAddrGet(
          {required String? stakePubKey}) {
    generatedMapping.putIfAbsent(
        Cip36Reporting, () => Cip36Reporting.fromJsonFactory);

    return _apiDraftCardanoCip36LatestRegistrationStakeAddrGet(
        stakePubKey: stakePubKey);
  }

  ///Get latest CIP36 registrations from stake address.
  ///@param stake_pub_key Stake Public Key to find the latest registration for.
  @Get(path: '/api/draft/cardano/cip36/latest_registration/stake_addr')
  Future<chopper.Response<Cip36Reporting>>
      _apiDraftCardanoCip36LatestRegistrationStakeAddrGet(
          {@Query('stake_pub_key') required String? stakePubKey});

  ///Get latest CIP36 registrations from a stake key hash.
  ///@param stake_key_hash Stake Key Hash to find the latest registration for.
  Future<chopper.Response<Cip36Reporting>>
      apiDraftCardanoCip36LatestRegistrationStakeKeyHashGet(
          {required String? stakeKeyHash}) {
    generatedMapping.putIfAbsent(
        Cip36Reporting, () => Cip36Reporting.fromJsonFactory);

    return _apiDraftCardanoCip36LatestRegistrationStakeKeyHashGet(
        stakeKeyHash: stakeKeyHash);
  }

  ///Get latest CIP36 registrations from a stake key hash.
  ///@param stake_key_hash Stake Key Hash to find the latest registration for.
  @Get(path: '/api/draft/cardano/cip36/latest_registration/stake_key_hash')
  Future<chopper.Response<Cip36Reporting>>
      _apiDraftCardanoCip36LatestRegistrationStakeKeyHashGet(
          {@Query('stake_key_hash') required String? stakeKeyHash});

  ///Get latest CIP36 registrations from voting key.
  ///@param vote_key Voting Key to find CIP36 registrations for.
  Future<chopper.Response<Cip36ReportingList>>
      apiDraftCardanoCip36LatestRegistrationVoteKeyGet(
          {required String? voteKey}) {
    generatedMapping.putIfAbsent(
        Cip36ReportingList, () => Cip36ReportingList.fromJsonFactory);

    return _apiDraftCardanoCip36LatestRegistrationVoteKeyGet(voteKey: voteKey);
  }

  ///Get latest CIP36 registrations from voting key.
  ///@param vote_key Voting Key to find CIP36 registrations for.
  @Get(path: '/api/draft/cardano/cip36/latest_registration/vote_key')
  Future<chopper.Response<Cip36ReportingList>>
      _apiDraftCardanoCip36LatestRegistrationVoteKeyGet(
          {@Query('vote_key') required String? voteKey});

  ///Get RBAC chain root
  ///@param stake_address Stake address to get the chain root for.
  Future<chopper.Response<Response$>> apiDraftRbacChainRootStakeAddressGet(
      {required String? stakeAddress}) {
    generatedMapping.putIfAbsent(Response$, () => Response$.fromJsonFactory);

    return _apiDraftRbacChainRootStakeAddressGet(stakeAddress: stakeAddress);
  }

  ///Get RBAC chain root
  ///@param stake_address Stake address to get the chain root for.
  @Get(path: '/api/draft/rbac/chain_root/{stake_address}')
  Future<chopper.Response<Response$>> _apiDraftRbacChainRootStakeAddressGet(
      {@Path('stake_address') required String? stakeAddress});

  ///Get registrations by RBAC chain root
  ///@param chain_root Chain root to get the registrations for.
  Future<chopper.Response<RbacRegistrationsResponse>>
      apiDraftRbacRegistrationsChainRootGet({required String? chainRoot}) {
    generatedMapping.putIfAbsent(RbacRegistrationsResponse,
        () => RbacRegistrationsResponse.fromJsonFactory);

    return _apiDraftRbacRegistrationsChainRootGet(chainRoot: chainRoot);
  }

  ///Get registrations by RBAC chain root
  ///@param chain_root Chain root to get the registrations for.
  @Get(path: '/api/draft/rbac/registrations/{chain_root}')
  Future<chopper.Response<RbacRegistrationsResponse>>
      _apiDraftRbacRegistrationsChainRootGet(
          {@Path('chain_root') required String? chainRoot});

  ///Get RBAC chain root for a given role0 key.
  ///@param role0_key Role0 key to get the chain root for.
  Future<chopper.Response<RbacRole0ChainRootResponse>>
      apiDraftRbacRole0ChainRootRole0KeyGet({required String? role0Key}) {
    generatedMapping.putIfAbsent(RbacRole0ChainRootResponse,
        () => RbacRole0ChainRootResponse.fromJsonFactory);

    return _apiDraftRbacRole0ChainRootRole0KeyGet(role0Key: role0Key);
  }

  ///Get RBAC chain root for a given role0 key.
  ///@param role0_key Role0 key to get the chain root for.
  @Get(path: '/api/draft/rbac/role0_chain_root/{role0_key}')
  Future<chopper.Response<RbacRole0ChainRootResponse>>
      _apiDraftRbacRole0ChainRootRole0KeyGet(
          {@Path('role0_key') required String? role0Key});

  ///Get staked ADA amount.
  ///@param stake_address The stake address of the user. Should be a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
  ///@param network Cardano network type. If omitted network type is identified from the stake address. If specified it must be correspondent to the network type encoded in the stake address. As `preprod` and `preview` network types in the stake address encoded as a `testnet`, to specify `preprod` or `preview` network type use this query parameter.
  ///@param slot_number Slot number at which the staked ADA amount should be calculated. If omitted latest slot number is used.
  Future<chopper.Response<FullStakeInfo>> apiDraftCardanoAssetsStakeAddressGet({
    required String? stakeAddress,
    enums.Network? network,
    int? slotNumber,
  }) {
    generatedMapping.putIfAbsent(
        FullStakeInfo, () => FullStakeInfo.fromJsonFactory);

    return _apiDraftCardanoAssetsStakeAddressGet(
        stakeAddress: stakeAddress,
        network: network?.value?.toString(),
        slotNumber: slotNumber);
  }

  ///Get staked ADA amount.
  ///@param stake_address The stake address of the user. Should be a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
  ///@param network Cardano network type. If omitted network type is identified from the stake address. If specified it must be correspondent to the network type encoded in the stake address. As `preprod` and `preview` network types in the stake address encoded as a `testnet`, to specify `preprod` or `preview` network type use this query parameter.
  ///@param slot_number Slot number at which the staked ADA amount should be calculated. If omitted latest slot number is used.
  @Get(path: '/api/draft/cardano/assets/{stake_address}')
  Future<chopper.Response<FullStakeInfo>>
      _apiDraftCardanoAssetsStakeAddressGet({
    @Path('stake_address') required String? stakeAddress,
    @Query('network') String? network,
    @Query('slot_number') int? slotNumber,
  });

  ///Get the configuration for the frontend.
  Future<chopper.Response<FrontendConfig>> apiDraftConfigFrontendGet() {
    generatedMapping.putIfAbsent(
        FrontendConfig, () => FrontendConfig.fromJsonFactory);

    return _apiDraftConfigFrontendGet();
  }

  ///Get the configuration for the frontend.
  @Get(path: '/api/draft/config/frontend')
  Future<chopper.Response<FrontendConfig>> _apiDraftConfigFrontendGet();

  ///Set the frontend configuration.
  ///@param IP *OPTIONAL* The IP Address to set the configuration for.
  Future<chopper.Response> apiDraftConfigFrontendPut({
    Object? ip,
    required FrontendConfig? body,
  }) {
    return _apiDraftConfigFrontendPut(ip: ip, body: body);
  }

  ///Set the frontend configuration.
  ///@param IP *OPTIONAL* The IP Address to set the configuration for.
  @Put(
    path: '/api/draft/config/frontend',
    optionalBody: true,
  )
  Future<chopper.Response> _apiDraftConfigFrontendPut({
    @Query('IP') Object? ip,
    @Body() required FrontendConfig? body,
  });

  ///Get the frontend configuration JSON schema.
  Future<chopper.Response<FrontendConfig>> apiDraftConfigFrontendSchemaGet() {
    generatedMapping.putIfAbsent(
        FrontendConfig, () => FrontendConfig.fromJsonFactory);

    return _apiDraftConfigFrontendSchemaGet();
  }

  ///Get the frontend configuration JSON schema.
  @Get(path: '/api/draft/config/frontend/schema')
  Future<chopper.Response<FrontendConfig>> _apiDraftConfigFrontendSchemaGet();

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
