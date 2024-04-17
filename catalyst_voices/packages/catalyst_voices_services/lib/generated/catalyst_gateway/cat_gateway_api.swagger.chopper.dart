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
  Future<Response<dynamic>> _apiTestTestIdTestActionGet({
    required int? id,
    required String? action,
    List<Object?>? pet,
  }) {
    final Uri $url = Uri.parse('/api/test/test/${id}/test/${action}');
    final Map<String, dynamic> $params = <String, dynamic>{'pet': pet};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiTestTestIdTestActionPost({
    required int? id,
    required String? action,
  }) {
    final Uri $url = Uri.parse('/api/test/test/${id}/test/${action}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiHealthStartedGet() {
    final Uri $url = Uri.parse('/api/health/started');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiHealthReadyGet() {
    final Uri $url = Uri.parse('/api/health/ready');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiHealthLiveGet() {
    final Uri $url = Uri.parse('/api/health/live');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StakeInfo>> _apiCardanoStakedAdaStakeAddressGet({
    required String? stakeAddress,
    String? network,
    int? slotNumber,
  }) {
    final Uri $url = Uri.parse('/api/cardano/staked_ada/${stakeAddress}');
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
    return client.send<StakeInfo, StakeInfo>($request);
  }

  @override
  Future<Response<RegistrationInfo>> _apiCardanoRegistrationStakeAddressGet({
    required String? stakeAddress,
    String? network,
    int? slotNumber,
  }) {
    final Uri $url = Uri.parse('/api/cardano/registration/${stakeAddress}');
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
  Future<Response<SyncState>> _apiCardanoSyncStateGet({String? network}) {
    final Uri $url = Uri.parse('/api/cardano/sync_state');
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
  Future<Response<SlotInfo>> _apiCardanoDateTimeToSlotNumberGet({
    DateTime? dateTime,
    String? network,
  }) {
    final Uri $url = Uri.parse('/api/cardano/date_time_to_slot_number');
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
  Future<Response<VoterRegistration>> _apiRegistrationVoterVotingKeyGet({
    required String? votingKey,
    int? eventId,
    bool? withDelegators,
  }) {
    final Uri $url = Uri.parse('/api/registration/voter/${votingKey}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'event_id': eventId,
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
