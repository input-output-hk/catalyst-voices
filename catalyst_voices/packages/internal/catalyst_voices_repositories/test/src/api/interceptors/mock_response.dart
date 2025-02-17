import 'package:chopper/chopper.dart';
import 'package:mocktail/mocktail.dart';

final class MockResponse<BodyType> extends Mock
    with MockResponseMixin<BodyType> {}
