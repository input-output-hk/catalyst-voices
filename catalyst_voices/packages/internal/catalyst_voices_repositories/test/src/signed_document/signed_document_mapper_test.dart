// ignore_for_file: avoid_redundant_argument_values

import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/document/exception/document_exception.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignedDocumentMapper', () {
    // Test Data Setup
    const uuidV4Str = '3e4808cc-c86e-467b-9702-d60baa9d1fca';
    const uuidV7Str = '019273a8-3339-7604-b12e-86625513f0f0';

    // Catalyst IDs
    /* cSpell:disable */
    const catalystIdStr = 'id.catalyst://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE';
    final catalystId = CatalystId.fromUri(Uri.parse(catalystIdStr));
    final catalystIdKid = CatalystIdKid(Uint8List.fromList(utf8.encode(catalystIdStr)));
    /* cSpell:enable */

    // Common Objects
    const signedDocRef = SignedDocumentRef(id: uuidV7Str, ver: uuidV7Str);

    group('applyCoseProtectedHeadersUpdates', () {
      test('applies id and ver update', () {
        // Given
        final newId = DocumentRefFactory.randomUuidV7();
        final newVer = DocumentRefFactory.randomUuidV7();

        final headers = CoseHeaders.protected(
          id: CoseDocumentId(CoseUuidV7.fromString(uuidV7Str)),
          ver: CoseDocumentVer(CoseUuidV7.fromString(uuidV7Str)),
        );
        final updates = DocumentDataMetadataUpdate(
          id: Optional(
            SignedDocumentRef(id: newId, ver: newVer),
          ),
        );

        // When
        final result = SignedDocumentMapper.applyCoseProtectedHeadersUpdates(
          headers,
          updates,
        );

        // Then
        expect(result.id?.value.format(), newId);
        expect(result.ver?.value.format(), newVer);
      });

      test('applies collaborators update', () {
        // Given
        const headers = CoseHeaders.protected(
          collaborators: null,
        );
        final updates = DocumentDataMetadataUpdate(
          collaborators: Optional([catalystId]),
        );

        // When
        final result = SignedDocumentMapper.applyCoseProtectedHeadersUpdates(
          headers,
          updates,
        );

        // Then
        expect(result.collaborators?.list, hasLength(1));
        expect(result.collaborators?.list.first.bytes, catalystIdKid.bytes);
      });

      test('does not modify fields if they are not provided', () {
        // Given
        final headers = CoseHeaders.protected(
          id: CoseDocumentId(CoseUuidV7.fromString(uuidV7Str)),
          ver: CoseDocumentVer(CoseUuidV7.fromString(uuidV7Str)),
          collaborators: null,
        );
        const emptyUpdates = DocumentDataMetadataUpdate();

        // When
        final result = SignedDocumentMapper.applyCoseProtectedHeadersUpdates(
          headers,
          emptyUpdates,
        );

        // Then
        expect(result.id, headers.id);
        expect(result.ver, headers.ver);
        expect(result.collaborators, equals(headers.collaborators));
      });
    });

    group('buildCoseProtectedHeaders', () {
      test('maps all fields correctly when fully populated', () {
        // Arrange
        final metadata = DocumentDataMetadata(
          contentType: DocumentContentType.json,
          type: DocumentType.proposalDocument,
          id: signedDocRef,
          ref: signedDocRef,
          template: signedDocRef,
          reply: signedDocRef,
          section: '/payload/title',
          collaborators: [catalystId],
          parameters: DocumentParameters({signedDocRef}),
          authors: [catalystId],
        );

        // Act
        final headers = SignedDocumentMapper.buildCoseProtectedHeaders(metadata);

        // Assert
        expect(headers.mediaType, CoseMediaType.json);
        expect(headers.contentEncoding, CoseHttpContentEncoding.brotli);
        expect(headers.id?.value.format(), uuidV7Str);
        expect(headers.ver?.value.format(), uuidV7Str);

        // Check Lists mapping (ref, template, reply)
        expect(headers.ref?.refs, hasLength(1));
        expect(headers.ref?.refs.first.documentId.format(), uuidV7Str);

        expect(headers.template?.refs, hasLength(1));
        expect(headers.reply?.refs, hasLength(1));

        // Check Section
        expect(headers.section?.value.text, '/payload/title');

        // Check Collaborators
        expect(headers.collaborators?.list, hasLength(1));
        expect(headers.collaborators?.list.first.bytes, catalystIdKid.bytes);

        // Check Parameters
        expect(headers.parameters?.refs, hasLength(1));
      });

      test('handles nullable fields correctly', () {
        // Arrange
        final metadata = DocumentDataMetadata(
          contentType: DocumentContentType.unknown,
          type: DocumentType.proposalDocument,
          id: signedDocRef,
          // All optional fields null
          ref: null,
          template: null,
          reply: null,
          section: null,
          collaborators: null,
          parameters: const DocumentParameters({}),
          authors: const [],
        );

        // Act
        final headers = SignedDocumentMapper.buildCoseProtectedHeaders(metadata);

        // Assert
        expect(headers.mediaType, isNull, reason: 'Unknown content type maps to null');
        expect(headers.ref, isNull);
        expect(headers.template, isNull);
        expect(headers.reply, isNull);
        expect(headers.section, isNull);
        expect(headers.collaborators, isNull);
        expect(headers.parameters, isNull);
      });
    });

    group('buildMetadata', () {
      test('reconstructs metadata correctly from valid COSE headers', () {
        // Arrange
        final coseRef = CoseDocumentRef.optional(
          documentId: CoseUuidV7.fromString(uuidV7Str),
          documentVer: CoseUuidV7.fromString(uuidV7Str),
          documentLocator: CoseDocumentLocator.fallback(),
        );

        final protectedHeaders = CoseHeaders.protected(
          mediaType: CoseMediaType.json,
          type: CoseDocumentType(CoseUuidV4.fromString(uuidV4Str)),
          id: CoseDocumentId(CoseUuidV7.fromString(uuidV7Str)),
          ver: CoseDocumentVer(CoseUuidV7.fromString(uuidV7Str)),
          ref: CoseDocumentRefs([coseRef]),
          template: CoseDocumentRefs([coseRef]),
          reply: CoseDocumentRefs([coseRef]),
          section: const CoseSectionRef(CoseJsonPointer('/section')),
          collaborators: CoseCollaborators([catalystIdKid]),
          parameters: CoseDocumentRefs([coseRef]),
        );

        const unprotectedHeaders = CoseHeaders.unprotected();
        final signers = [catalystIdKid];

        // Act
        final metadata = SignedDocumentMapper.buildMetadata(
          protectedHeaders: protectedHeaders,
          unprotectedHeaders: unprotectedHeaders,
          signers: signers,
        );

        // Assert
        expect(metadata.contentType, DocumentContentType.json);
        expect(metadata.id.id, signedDocRef.id);
        expect(metadata.id.ver, signedDocRef.ver);

        // Verify single item extraction from lists
        expect(metadata.ref?.id, signedDocRef.id);
        expect(metadata.template?.id, signedDocRef.id);
        expect(metadata.reply?.id, signedDocRef.id);

        expect(metadata.section, '/section');
        expect(metadata.collaborators, contains(catalystId));
        expect(metadata.parameters.set, hasLength(1));
        expect(metadata.authors, contains(catalystId));
      });

      test('throws DocumentMetadataMalformedException when ID is missing', () {
        // Arrange
        final headers = CoseHeaders.protected(
          ver: CoseDocumentVer(CoseUuidV7.fromString(uuidV7Str)),
          // Missing ID
        );

        // Act & Assert
        expect(
          () => SignedDocumentMapper.buildMetadata(
            protectedHeaders: headers,
            unprotectedHeaders: const CoseHeaders.unprotected(),
            signers: [],
          ),
          throwsA(
            isA<DocumentMetadataMalformedException>().having(
              (e) => e.reasons,
              'reasons',
              contains('id is missing'),
            ),
          ),
        );
      });

      test('throws DocumentMetadataMalformedException when Version is missing', () {
        // Arrange
        final headers = CoseHeaders.protected(
          id: CoseDocumentId(CoseUuidV7.fromString(uuidV7Str)),
          // Missing Version
        );

        // Act & Assert
        expect(
          () => SignedDocumentMapper.buildMetadata(
            protectedHeaders: headers,
            unprotectedHeaders: const CoseHeaders.unprotected(),
            signers: [],
          ),
          throwsA(
            isA<DocumentMetadataMalformedException>().having(
              (e) => e.reasons,
              'reasons',
              contains('version is missing'),
            ),
          ),
        );
      });

      test('maps various CoseMediaTypes to DocumentContentType.unknown', () {
        final unsupportedTypes = [
          CoseMediaType.markdown,
          CoseMediaType.html,
          CoseMediaType.cbor,
          null,
        ];

        for (final type in unsupportedTypes) {
          final headers = CoseHeaders.protected(
            id: CoseDocumentId(CoseUuidV7.fromString(uuidV7Str)),
            ver: CoseDocumentVer(CoseUuidV7.fromString(uuidV7Str)),
            mediaType: type,
          );

          final metadata = SignedDocumentMapper.buildMetadata(
            protectedHeaders: headers,
            unprotectedHeaders: const CoseHeaders.unprotected(),
            signers: [],
          );

          expect(
            metadata.contentType,
            DocumentContentType.unknown,
            reason: 'Failed to map $type to unknown',
          );
        }
      });

      test('filters out invalid CatalystId signers gracefully', () {
        // Arrange
        final invalidBytes = Uint8List.fromList([0xFF, 0xFE]); // Invalid UTF-8
        final invalidKid = CatalystIdKid(invalidBytes);

        final headers = CoseHeaders.protected(
          id: CoseDocumentId(CoseUuidV7.fromString(uuidV7Str)),
          ver: CoseDocumentVer(CoseUuidV7.fromString(uuidV7Str)),
        );

        // Act
        final metadata = SignedDocumentMapper.buildMetadata(
          protectedHeaders: headers,
          unprotectedHeaders: const CoseHeaders.unprotected(),
          signers: [catalystIdKid, invalidKid],
        );

        // Assert
        expect(metadata.authors, hasLength(1));
        expect(metadata.authors?.first, catalystId);
      });
    });
  });
}
