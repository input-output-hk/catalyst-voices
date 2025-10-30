import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final CatGateway gateway = MockCatGateway();
  final CatReviews reviews = MockCatReviews();
  final CatStatus status = MockedCatStatus();

  final SignedDocumentManager signedDocumentManager = _MockedSignedDocumentManager();

  late final ApiServices apiServices;
  // ignore: unused_local_variable
  late final CatGatewayDocumentDataSource source;

  setUpAll(() {
    apiServices = ApiServices.internal(
      gateway: gateway,
      reviews: reviews,
      status: status,
    );

    source = CatGatewayDocumentDataSource(apiServices, signedDocumentManager);
  });

  tearDown(() {
    reset(gateway);
    reset(reviews);
    reset(status);
    reset(signedDocumentManager);
  });

  group(CatGatewayDocumentDataSource, () {
    group('index', () {
      // TODO(damian-molinski): bring back unit tests once performance is ready
    });
  });
}

class _MockedSignedDocumentManager extends Mock implements SignedDocumentManager {}
