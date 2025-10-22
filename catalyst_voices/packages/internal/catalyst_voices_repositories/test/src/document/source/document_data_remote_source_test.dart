import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final CatGateway gateway = MockCatGateway();
  final CatReviews reviews = MockCatReviews();
  final SignedDocumentManager signedDocumentManager = _MockedSignedDocumentManager();

  late final ApiServices apiServices;
  // ignore: unused_local_variable
  late final CatGatewayDocumentDataSource source;

  setUpAll(() {
    apiServices = ApiServices.internal(
      gateway: gateway,
      reviews: reviews,
    );

    source = CatGatewayDocumentDataSource(apiServices, signedDocumentManager);
  });

  tearDown(() {
    reset(gateway);
    reset(reviews);
    reset(signedDocumentManager);
  });

  group(CatGatewayDocumentDataSource, () {
    group('index', () {
      // TODO(damian-molinski): bring back unit tests once performance is ready
    });
  });
}

/*DocumentIndexListDto _buildDocumentIndexList({
  int verCount = 2,
  DocumentRefForFilteredDocuments? template,
  DocumentRefForFilteredDocuments? ref,
}) {
  return DocumentIndexListDto(
    id: DocumentRefFactory.randomUuidV7(),
    ver: List.generate(
      verCount,
      (index) {
        return IndividualDocumentVersion(
          ver: DocumentRefFactory.randomUuidV7(),
          type: DocumentRefFactory.randomUuidV7(),
          template: template,
          ref: ref,
        );
      },
    ),
  );
}*/

class _MockedSignedDocumentManager extends Mock implements SignedDocumentManager {}
