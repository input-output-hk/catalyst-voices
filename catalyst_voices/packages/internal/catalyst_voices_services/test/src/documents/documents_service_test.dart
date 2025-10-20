import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  final DocumentRepository documentRepository = _MockDocumentRepository();
  late final DocumentsService service;

  setUpAll(() {
    service = DocumentsService(documentRepository);

    registerFallbackValue(SignedDocumentRef.first(const Uuid().v7()));
  });

  tearDown(() {
    reset(documentRepository);
  });

  group(DocumentsService, () {
    // TODO(damian-molinski): rewrite test once performance work is finished
  });
}

class _MockDocumentRepository extends Mock implements DocumentRepository {}
