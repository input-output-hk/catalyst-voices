import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

mixin InternalErrorCatGatewayMixin implements CatGateway {
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
  Future<Response<dynamic>> apiGatewayV2DocumentIndexPost({
    int? page,
    int? limit,
    dynamic authorization,
    dynamic contentType,
    required DocumentIndexQueryFilterV2? body,
  }) async {
    return Response<Object>(http.Response('{}', 500), const <String, dynamic>{});
  }
}
