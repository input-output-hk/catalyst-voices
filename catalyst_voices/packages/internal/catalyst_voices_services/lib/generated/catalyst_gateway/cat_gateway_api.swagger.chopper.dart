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
