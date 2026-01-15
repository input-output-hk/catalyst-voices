import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockCatGateway extends Mock implements CatGatewayService {}

class MockCatReviews extends Mock implements CatReviewsService {}

class MockedAppMetaService extends Mock implements AppMetaService {}

class MockedCatStatus extends Mock implements CatStatusService {}
