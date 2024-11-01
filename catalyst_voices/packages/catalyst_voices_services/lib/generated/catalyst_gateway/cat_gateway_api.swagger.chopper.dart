// Generated code

part of 'cat_gateway_api.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$CatGatewayApi extends CatGatewayApi {
  _$CatGatewayApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = CatGatewayApi;

  @override
  Future<Response<dynamic>> _apiV1HealthStartedGet() {
    final Uri $url = Uri.parse('/api/v1/health/started');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1HealthReadyGet() {
    final Uri $url = Uri.parse('/api/v1/health/ready');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1HealthLiveGet() {
    final Uri $url = Uri.parse('/api/v1/health/live');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1HealthInspectionPut({
    String? logLevel,
    String? queryInspection,
  }) {
    final Uri $url = Uri.parse('/api/v1/health/inspection');
    final Map<String, dynamic> $params = <String, dynamic>{
      'log_level': logLevel,
      'query_inspection': queryInspection,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<FullStakeInfo>> _apiDraftCardanoStakedAdaStakeAddressGet({
    required String? stakeAddress,
    String? network,
    int? slotNumber,
  }) {
    final Uri $url = Uri.parse('/api/draft/cardano/staked_ada/${stakeAddress}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'network': network,
      'slot_number': slotNumber,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<FullStakeInfo, FullStakeInfo>($request);
  }

  @override
  Future<Response<RegistrationInfo>>
      _apiDraftCardanoRegistrationStakeAddressGet({
    required String? stakeAddress,
    String? network,
    int? slotNumber,
  }) {
    final Uri $url =
        Uri.parse('/api/draft/cardano/registration/${stakeAddress}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'network': network,
      'slot_number': slotNumber,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<RegistrationInfo, RegistrationInfo>($request);
  }

  @override
  Future<Response<SyncState>> _apiDraftCardanoSyncStateGet({String? network}) {
    final Uri $url = Uri.parse('/api/draft/cardano/sync_state');
    final Map<String, dynamic> $params = <String, dynamic>{'network': network};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<SyncState, SyncState>($request);
  }

  @override
  Future<Response<SlotInfo>> _apiDraftCardanoDateTimeToSlotNumberGet({
    DateTime? dateTime,
    String? network,
  }) {
    final Uri $url = Uri.parse('/api/draft/cardano/date_time_to_slot_number');
    final Map<String, dynamic> $params = <String, dynamic>{
      'date_time': dateTime,
      'network': network,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<SlotInfo, SlotInfo>($request);
  }

  @override
  Future<Response<Cip36Reporting>>
      _apiDraftCardanoCip36LatestRegistrationStakeAddrGet(
          {required String? stakeAddr}) {
    final Uri $url =
        Uri.parse('/api/draft/cardano/cip36/latest_registration/stake_addr');
    final Map<String, dynamic> $params = <String, dynamic>{
      'stake_addr': stakeAddr
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Cip36Reporting, Cip36Reporting>($request);
  }

  @override
  Future<Response<Cip36Reporting>>
      _apiDraftCardanoCip36LatestRegistrationStakeKeyHashGet(
          {required String? stakeKeyHash}) {
    final Uri $url = Uri.parse(
        '/api/draft/cardano/cip36/latest_registration/stake_key_hash');
    final Map<String, dynamic> $params = <String, dynamic>{
      'stake_key_hash': stakeKeyHash
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Cip36Reporting, Cip36Reporting>($request);
  }

  @override
  Future<Response<Cip36ReportingList>>
      _apiDraftCardanoCip36LatestRegistrationVoteKeyGet(
          {required String? voteKey}) {
    final Uri $url =
        Uri.parse('/api/draft/cardano/cip36/latest_registration/vote_key');
    final Map<String, dynamic> $params = <String, dynamic>{'vote_key': voteKey};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Cip36ReportingList, Cip36ReportingList>($request);
  }

  @override
  Future<Response<Response$>> _apiDraftRbacChainRootStakeAddressGet(
      {required String? stakeAddress}) {
    final Uri $url = Uri.parse('/api/draft/rbac/chain_root/${stakeAddress}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Response$, Response$>($request);
  }

  @override
  Future<Response<RbacRegistrationsResponse>>
      _apiDraftRbacRegistrationsChainRootGet({required String? chainRoot}) {
    final Uri $url = Uri.parse('/api/draft/rbac/registrations/${chainRoot}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<RbacRegistrationsResponse, RbacRegistrationsResponse>($request);
  }

  @override
  Future<Response<RbacRole0ChainRootResponse>>
      _apiDraftRbacRole0ChainRootRole0KeyGet({required String? role0Key}) {
    final Uri $url = Uri.parse('/api/draft/rbac/role0_chain_root/${role0Key}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<RbacRole0ChainRootResponse, RbacRole0ChainRootResponse>($request);
  }

  @override
  Future<Response<FrontendConfig>> _apiDraftConfigFrontendGet() {
    final Uri $url = Uri.parse('/api/draft/config/frontend');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<FrontendConfig, FrontendConfig>($request);
  }

  @override
  Future<Response<dynamic>> _apiDraftConfigFrontendPut({
    Object? ip,
    required FrontendConfig? body,
  }) {
    final Uri $url = Uri.parse('/api/draft/config/frontend');
    final Map<String, dynamic> $params = <String, dynamic>{'IP': ip};
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<FrontendConfig>> _apiDraftConfigFrontendSchemaGet() {
    final Uri $url = Uri.parse('/api/draft/config/frontend/schema');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<FrontendConfig, FrontendConfig>($request);
  }

  @override
  Future<Response<VoterRegistration>> _apiV1RegistrationVoterVotingKeyGet({
    required String? votingKey,
    int? eventIndex,
    bool? withDelegators,
  }) {
    final Uri $url = Uri.parse('/api/v1/registration/voter/${votingKey}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'event_index': eventIndex,
      'with_delegators': withDelegators,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<VoterRegistration, VoterRegistration>($request);
  }

  @override
  Future<Response<FragmentsProcessingSummary>> _apiV0MessagePost(
      {required Object? body}) {
    final Uri $url = Uri.parse('/api/v0/message');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<FragmentsProcessingSummary, FragmentsProcessingSummary>($request);
  }

  @override
  Future<Response<List<VotePlan>>> _apiV0VoteActivePlansGet() {
    final Uri $url = Uri.parse('/api/v0/vote/active/plans');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<VotePlan>, VotePlan>($request);
  }

  @override
  Future<Response<List<AccountVote>>> _apiV1VotesPlanAccountVotesAccountIdGet(
      {required String? accountId}) {
    final Uri $url = Uri.parse('/api/v1/votes/plan/account-votes/${accountId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<AccountVote>, AccountVote>($request);
  }

  @override
  Future<Response<FragmentsProcessingSummary>> _apiV1FragmentsPost(
      {required FragmentsBatch? body}) {
    final Uri $url = Uri.parse('/api/v1/fragments');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<FragmentsProcessingSummary, FragmentsProcessingSummary>($request);
  }

  @override
  Future<Response<Object>> _apiV1FragmentsStatusesGet(
      {required List<String>? fragmentIds}) {
    final Uri $url = Uri.parse('/api/v1/fragments/statuses');
    final Map<String, dynamic> $params = <String, dynamic>{
      'fragment_ids': fragmentIds
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Object, Object>($request);
  }
}
