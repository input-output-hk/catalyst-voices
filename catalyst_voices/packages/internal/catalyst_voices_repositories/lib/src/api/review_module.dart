import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

part 'review_module.chopper.dart';

@chopperApi
abstract class ReviewModule extends ChopperService {
  static ReviewModule create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$ReviewModule(client);
    }

    final newClient = ChopperClient(
      services: [_$ReviewModule()],
      converter: converter,
      interceptors: interceptors ?? [],
      client: httpClient,
      authenticator: authenticator,
      errorConverter: errorConverter,
      baseUrl: baseUrl ?? Uri.parse('http://'),
    );

    return _$ReviewModule(newClient);
  }
}
