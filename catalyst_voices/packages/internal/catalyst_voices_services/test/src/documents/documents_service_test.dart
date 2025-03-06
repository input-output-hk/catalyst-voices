import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

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
    test(
        'calls cache documents exactly number '
        'of times are all refs count', () async {
      // Given
      final allRefs = List.generate(
        10,
        (_) => SignedDocumentRef.first(const Uuid().v7()),
      );
      final cachedRefs = <SignedDocumentRef>[];

      // When
      when(documentRepository.getAllDocumentsRefs)
          .thenAnswer((_) => Future.value(allRefs));
      when(documentRepository.getCachedDocumentsRefs)
          .thenAnswer((_) => Future.value(cachedRefs));
      when(() => documentRepository.cacheDocument(ref: any(named: 'ref')))
          .thenAnswer((_) => Future(() {}));

      await service.sync();

      // Then
      verify(() => documentRepository.cacheDocument(ref: any(named: 'ref')))
          .called(allRefs.length);
    });

    test('calls cache documents only for missing refs', () async {
      // Given
      final allRefs = List.generate(
        10,
        (_) => SignedDocumentRef.first(const Uuid().v7()),
      );
      final cachedRefs = allRefs.sublist(0, (allRefs.length / 2).floor());
      final expectedCalls = allRefs.length - cachedRefs.length;

      // When
      when(documentRepository.getAllDocumentsRefs)
          .thenAnswer((_) => Future.value(allRefs));
      when(documentRepository.getCachedDocumentsRefs)
          .thenAnswer((_) => Future.value(cachedRefs));
      when(() => documentRepository.cacheDocument(ref: any(named: 'ref')))
          .thenAnswer((_) => Future(() {}));

      await service.sync();

      // Then
      verify(() => documentRepository.cacheDocument(ref: any(named: 'ref')))
          .called(expectedCalls);
    });

    test('when have more cached refs it returns normally', () async {
      // Given
      final allRefs = List.generate(
        10,
        (_) => SignedDocumentRef.first(const Uuid().v7()),
      );
      final cachedRefs = allRefs +
          List.generate(
            5,
            (_) => SignedDocumentRef.first(const Uuid().v7()),
          );

      // When
      when(documentRepository.getAllDocumentsRefs)
          .thenAnswer((_) => Future.value(allRefs));
      when(documentRepository.getCachedDocumentsRefs)
          .thenAnswer((_) => Future.value(cachedRefs));
      when(() => documentRepository.cacheDocument(ref: any(named: 'ref')))
          .thenAnswer((_) => Future(() {}));

      await service.sync();

      // Then
      verifyNever(
        () => documentRepository.cacheDocument(ref: any(named: 'ref')),
      );
    });

    test('emits progress as expected', () async {
      // Given
      final allRefs = List.generate(
        10,
        (_) => SignedDocumentRef.first(const Uuid().v7()),
      );
      final cachedRefs = <SignedDocumentRef>[];
      var progress = 0.0;

      // When
      when(documentRepository.getAllDocumentsRefs)
          .thenAnswer((_) => Future.value(allRefs));
      when(documentRepository.getCachedDocumentsRefs)
          .thenAnswer((_) => Future.value(cachedRefs));
      when(() => documentRepository.cacheDocument(ref: any(named: 'ref')))
          .thenAnswer((_) => Future(() {}));

      // Then
      await service.sync(
        onProgress: (value) {
          progress = value;
        },
      );

      expect(progress, 1.0);
    });

    test('returns list of new successfully cached refs', () async {
      // Given
      final allRefs = List.generate(
        10,
        (_) => SignedDocumentRef.first(const Uuid().v7()),
      );
      final cachedRefs = allRefs.sublist(0, (allRefs.length / 2).floor());
      final expectedNewRefs = allRefs.sublist(cachedRefs.length);

      // When
      when(documentRepository.getAllDocumentsRefs)
          .thenAnswer((_) => Future.value(allRefs));
      when(documentRepository.getCachedDocumentsRefs)
          .thenAnswer((_) => Future.value(cachedRefs));
      when(() => documentRepository.cacheDocument(ref: any(named: 'ref')))
          .thenAnswer((_) => Future(() {}));

      // Then
      final newRefs = await service.sync();

      expect(
        newRefs,
        allOf(hasLength(expectedNewRefs.length), containsAll(expectedNewRefs)),
      );
    });
  });
}

class _MockDocumentRepository extends Mock implements DocumentRepository {}
