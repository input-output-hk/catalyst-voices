import 'dart:convert';

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:convert/convert.dart';
import 'package:drift/drift.dart';

final class SignedDocumentMapper {
  /// A temporary map of [DocumentRef.id] (uuidv7) to [CoseDocumentLocator.cid] (hex).
  ///
  /// Allows to map documents to their document locators.
  // TODO(dt-iohk): instead of hardcoding, parse or calculate the CID
  // and pass it to the document parameters when publishing a document.
  static const Map<String, String> _documentIdToCidMap = {
    '019b2b86-7507-7b95-929e-74e3bffb030d':
        '015512207fcfec2e5a60f061cf26959c032799cf842bcf94c1fce648a1aec8096a150797',
  };

  SignedDocumentMapper._();

  /// Returns a copy of [headers] with applied changes from [updates].
  static CoseHeaders applyCoseProtectedHeadersUpdates(
    CoseHeaders headers,
    DocumentDataMetadataUpdate updates,
  ) {
    final id = updates.id;
    final collaborators = updates.collaborators;

    return headers.copyWith(
      id: id == null
          ? null
          : () {
              final uuid = id.data?.id.asUuidV7;
              return uuid == null ? null : CoseDocumentId(uuid);
            },
      ver: id == null
          ? null
          : () {
              final uuid = id.data?.ver?.asUuidV7;
              return uuid == null ? null : CoseDocumentVer(uuid);
            },
      collaborators: collaborators == null
          ? null
          : () => _mapCollaboratorsToCose(collaborators.data),
    );
  }

  /// Maps domain [DocumentDataMetadata] into [CoseHeaders].
  ///
  /// Unprotected headers are not permitted by the specification,
  /// so this method focuses strictly on the Protected Headers.
  static CoseHeaders buildCoseProtectedHeaders(DocumentDataMetadata metadata) {
    return CoseHeaders.protected(
      mediaType: _mapContentTypeToCose(metadata.contentType),
      contentEncoding: CoseHttpContentEncoding.brotli,
      type: CoseDocumentType(metadata.type.uuid.asUuidV4),
      id: CoseDocumentId(metadata.id.id.asUuidV7),
      ver: CoseDocumentVer(metadata.id.ver!.asUuidV7),
      ref: _mapRefToCoseList(metadata.ref),
      template: _mapRefToCoseList(metadata.template),
      reply: _mapRefToCoseList(metadata.reply),
      section: metadata.section != null ? CoseSectionRef(CoseJsonPointer(metadata.section!)) : null,
      collaborators: _mapCollaboratorsToCose(metadata.collaborators),
      parameters: _mapRefsToCose(metadata.parameters.set.toList()),
    );
  }

  /// Maps COSE headers and signers back into domain [DocumentDataMetadata].
  static DocumentDataMetadata buildMetadata({
    required CoseHeaders protectedHeaders,
    required CoseHeaders unprotectedHeaders,
    required List<CatalystIdKid> signers,
  }) {
    // Validation: ID and Version are required fields.
    final typeStr = protectedHeaders.type?.value.format();
    final idStr = protectedHeaders.id?.value.format();
    final verStr = protectedHeaders.ver?.value.format();

    final malformedReasons = <String>[];
    if (idStr == null) malformedReasons.add('id is missing');
    if (verStr == null) malformedReasons.add('version is missing');

    if (malformedReasons.isNotEmpty) {
      throw DocumentMetadataMalformedException(reasons: malformedReasons);
    }

    return DocumentDataMetadata(
      contentType: _mapContentTypeFromCose(protectedHeaders.mediaType),
      type: typeStr == null ? DocumentType.unknown : DocumentType.fromJson(typeStr),
      id: SignedDocumentRef(id: idStr!, ver: verStr),
      // The domain model expects single references for these fields,
      // even though COSE supports lists.
      ref: _mapRefsFromCose(protectedHeaders.ref).firstOrNull,
      template: _mapRefsFromCose(protectedHeaders.template).firstOrNull,
      reply: _mapRefsFromCose(protectedHeaders.reply).firstOrNull,
      section: protectedHeaders.section?.value.text,
      collaborators: _mapCollaboratorsFromCose(protectedHeaders.collaborators),
      parameters: DocumentParameters(_mapRefsFromCose(protectedHeaders.parameters).toSet()),
      authors: _mapSignersFromCose(signers),
    );
  }

  static CatalystId? _catalystIdFromKid(CatalystIdKid kid) {
    try {
      final string = utf8.decode(kid.bytes);
      final uri = Uri.tryParse(string);
      if (uri == null) return null;
      return CatalystId.fromUri(uri);
    } catch (_) {
      return null;
    }
  }

  static CoseDocumentLocator _getDocumentLocatorForRef(DocumentRef ref) {
    final customCid = _documentIdToCidMap[ref.id];
    if (customCid != null) {
      return CoseDocumentLocator(cid: Uint8List.fromList(hex.decode(customCid)));
    }

    return CoseDocumentLocator.fallback();
  }

  static List<CatalystId>? _mapCollaboratorsFromCose(
    CoseCollaborators? collaborators,
  ) {
    if (collaborators == null) return null;
    return _mapSignersFromCose(collaborators.list);
  }

  static CoseCollaborators? _mapCollaboratorsToCose(
    List<CatalystId>? collaborators,
  ) {
    if (collaborators == null) return null;
    return CoseCollaborators(
      collaborators.map((e) => CatalystIdKid.fromString(e.toString())).toList(),
    );
  }

  static DocumentContentType _mapContentTypeFromCose(CoseMediaType? type) {
    return switch (type) {
      CoseMediaType.json => DocumentContentType.json,
      CoseMediaType.schemaJson => DocumentContentType.schemaJson,
      // Note: Spec supports Markdown/HTML, but Domain model currently treats them as unknown.
      CoseMediaType.cbor ||
      CoseMediaType.cddl ||
      CoseMediaType.css ||
      CoseMediaType.cssHandlebars ||
      CoseMediaType.html ||
      CoseMediaType.htmlHandlebars ||
      CoseMediaType.markdown ||
      CoseMediaType.markdownHandlebars ||
      CoseMediaType.plain ||
      CoseMediaType.plainHandlebars ||
      null => DocumentContentType.unknown,
    };
  }

  static CoseMediaType? _mapContentTypeToCose(DocumentContentType type) {
    return switch (type) {
      DocumentContentType.json => CoseMediaType.json,
      DocumentContentType.schemaJson => CoseMediaType.schemaJson,
      DocumentContentType.unknown => null,
    };
  }

  static List<SignedDocumentRef> _mapRefsFromCose(CoseDocumentRefs? coseRefs) {
    if (coseRefs == null) return const [];
    return coseRefs.refs.map((e) {
      return SignedDocumentRef(
        id: e.documentId.format(),
        ver: e.documentVer.format(),
      );
    }).toList();
  }

  static CoseDocumentRefs? _mapRefsToCose(List<DocumentRef> refs) {
    if (refs.isEmpty) return null;
    return CoseDocumentRefs(refs.map(_mapRefToCose).toList());
  }

  static CoseDocumentRef _mapRefToCose(DocumentRef ref) {
    return CoseDocumentRef.optional(
      documentId: ref.id.asUuidV7,
      documentVer: (ref.ver ?? ref.id).asUuidV7,
      documentLocator: _getDocumentLocatorForRef(ref),
    );
  }

  static CoseDocumentRefs? _mapRefToCoseList(DocumentRef? ref) {
    if (ref == null) return null;
    return CoseDocumentRefs([_mapRefToCose(ref)]);
  }

  static List<CatalystId> _mapSignersFromCose(List<CatalystIdKid> kids) {
    return kids.map(_catalystIdFromKid).nonNulls.toList();
  }
}

extension _UuidStringExt on String {
  CoseUuidV4 get asUuidV4 => CoseUuidV4.fromString(this);

  CoseUuidV7 get asUuidV7 => CoseUuidV7.fromString(this);
}
