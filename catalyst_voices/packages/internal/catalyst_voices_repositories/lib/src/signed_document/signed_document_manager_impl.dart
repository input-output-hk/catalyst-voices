import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/document/exception/document_exception.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_manager.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

final class SignedDocumentManagerImpl implements SignedDocumentManager {
  final CatalystCompressor brotli;
  final CatalystCompressor zstd;

  const SignedDocumentManagerImpl({
    required this.brotli,
    required this.zstd,
  });

  @override
  Future<SignedDocument> parseDocument(Uint8List bytes) async {
    final coseSign = CoseSign.fromCbor(cbor.decode(bytes));
    final signers = _CatalystIdListExt.fromCose(
      coseSign.signatures.map((e) => e.protectedHeaders.kid).nonNulls.toList().cast(),
    );

    final metadata = _DocumentMetadataExt.fromCose(
      protectedHeaders: coseSign.protectedHeaders,
      unprotectedHeaders: coseSign.unprotectedHeaders,
      signers: signers,
    );

    final payloadBytes = await _brotliDecompressPayload(coseSign);
    final payload = SignedDocumentPayload.fromBytes(
      payloadBytes,
      contentType: metadata.contentType,
    );

    return _CoseSignedDocument(
      coseSign: coseSign,
      payload: payload,
      metadata: metadata,
      signers: signers,
    );
  }

  @override
  Future<SignedDocument> signDocument(
    SignedDocumentPayload document, {
    required DocumentDataMetadata metadata,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final compressedPayload = await _brotliCompressPayload(document.toBytes());

    final coseSign = await CoseSign.sign(
      protectedHeaders: metadata.asCoseProtectedHeaders,
      unprotectedHeaders: metadata.asCoseUnprotectedHeaders,
      payload: compressedPayload,
      signers: [_CatalystSigner(catalystId, privateKey)],
    );

    return _CoseSignedDocument(
      coseSign: coseSign,
      payload: document,
      metadata: metadata,
      signers: [catalystId],
    );
  }

  Future<Uint8List> _brotliCompressPayload(Uint8List payload) async {
    final compressed = await brotli.compress(payload);
    return Uint8List.fromList(compressed);
  }

  Future<Uint8List> _brotliDecompressPayload(CoseSign coseSign) async {
    if (coseSign.protectedHeaders.contentEncoding == CoseHttpContentEncoding.brotli) {
      final decompressed = await brotli.decompress(coseSign.payload);
      return Uint8List.fromList(decompressed);
    } else {
      return coseSign.payload;
    }
  }
}

final class _CatalystSigner implements CatalystCoseSigner {
  final CatalystId _catalystId;
  final CatalystPrivateKey _privateKey;

  const _CatalystSigner(
    this._catalystId,
    this._privateKey,
  );

  @override
  CoseStringOrInt? get alg => null;

  @override
  Future<CatalystIdKid?> get kid async {
    return CatalystIdKid.fromString(_catalystId.toString());
  }

  @override
  Future<Uint8List> sign(Uint8List data) async {
    final signature = await _privateKey.sign(data);
    return signature.bytes;
  }
}

final class _CatalystVerifier implements CatalystCoseVerifier {
  final CatalystId _catalystId;

  const _CatalystVerifier(this._catalystId);

  @override
  Future<CatalystIdKid?> get kid async {
    return CatalystIdKid.fromString(_catalystId.toString());
  }

  @override
  Future<bool> verify(Uint8List data, Uint8List signature) async {
    // TODO(dt-iohk): obtain the public key corresponding
    // to the private key which generated the signature and use
    // it for verification, most likely the role0Key is not the correct one.
    final catalystSignature = CatalystSignature.factory.create(signature);
    return CatalystPublicKey.factory
        .create(_catalystId.role0Key)
        .verify(data, signature: catalystSignature);
  }
}

final class _CoseSignedDocument with EquatableMixin implements SignedDocument {
  final CoseSign _coseSign;

  @override
  final SignedDocumentPayload payload;

  @override
  final DocumentDataMetadata metadata;

  @override
  final List<CatalystId> signers;

  const _CoseSignedDocument({
    required CoseSign coseSign,
    required this.payload,
    required this.metadata,
    required this.signers,
  }) : _coseSign = coseSign;

  @override
  List<Object?> get props => [_coseSign, payload, metadata, signers];

  @override
  Uint8List toBytes() {
    final bytes = cbor.encode(_coseSign.toCbor(tagged: false));
    return Uint8List.fromList(bytes);
  }

  @override
  Future<bool> verifySignature(CatalystId catalystId) async {
    return _coseSign.verify(verifier: _CatalystVerifier(catalystId));
  }
}

extension _CatalystIdExt on CatalystId {
  static CatalystId? fromCose(CatalystIdKid kid) {
    final string = utf8.decode(kid.bytes);
    final uri = Uri.tryParse(string);
    if (uri == null) return null;

    return CatalystId.fromUri(uri);
  }
}

extension _CatalystIdListExt on List<CatalystId> {
  static List<CatalystId> fromCose(List<CatalystIdKid> list) {
    return list.map(_CatalystIdExt.fromCose).nonNulls.toList();
  }
}

extension _DocumentMetadataExt on DocumentDataMetadata {
  CoseHeaders get asCoseProtectedHeaders {
    final id = this.id;
    final version = this.version;
    final ref = this.ref;
    final template = this.template;
    final reply = this.reply;
    final section = this.section;

    return CoseHeaders.protected(
      mediaType: contentType.asCose,
      contentEncoding: CoseHttpContentEncoding.brotli,
      type: CoseDocumentType(type.uuid.asUuidV4),
      id: CoseDocumentId(id.asUuidV7),
      ver: CoseDocumentVer(version.asUuidV7),
      ref: ref == null ? null : [ref].asCose,
      template: template == null ? null : [template].asCose,
      reply: reply == null ? null : [reply].asCose,
      section: section == null ? null : CoseSectionRef(CoseJsonPointer(section)),
      parameters: parameters.set.toList().asCose,
    );
  }

  CoseHeaders get asCoseUnprotectedHeaders {
    return const CoseHeaders.unprotected();
  }

  static DocumentDataMetadata fromCose({
    required CoseHeaders protectedHeaders,
    required CoseHeaders unprotectedHeaders,
    required List<CatalystId> signers,
  }) {
    final type = protectedHeaders.type?.value.format();
    final id = protectedHeaders.id?.value?.format();
    final ver = protectedHeaders.ver?.value?.format();
    final ref = protectedHeaders.ref;
    final template = protectedHeaders.template;
    final reply = protectedHeaders.reply;
    final parameters = protectedHeaders.parameters;

    final malformedReasons = <String>[];
    if (id == null) {
      malformedReasons.add('id is missing');
    }
    if (ver == null) {
      malformedReasons.add('version is missing');
    }

    if (malformedReasons.isNotEmpty) {
      throw DocumentMetadataMalformedException(reasons: malformedReasons);
    }

    return DocumentDataMetadata(
      contentType: _SignedDocumentContentTypeExt.fromCose(protectedHeaders.mediaType),
      type: type == null ? DocumentType.unknown : DocumentType.fromJson(type),
      selfRef: SignedDocumentRef(id: id!, version: ver),
      ref: ref == null ? null : _DocumentRefsExt.fromCose(ref).firstOrNull,
      template: template == null ? null : _DocumentRefsExt.fromCose(template).firstOrNull,
      reply: reply == null ? null : _DocumentRefsExt.fromCose(reply).firstOrNull,
      section: protectedHeaders.section?.value.text,
      parameters: parameters == null
          ? const DocumentParameters()
          : DocumentParameters(_DocumentRefsExt.fromCose(parameters).toSet()),
      authors: signers,
    );
  }
}

extension _DocumentRefExt on DocumentRef {
  CoseDocumentRef get asCose => CoseDocumentRef.optional(
    documentId: id.asUuidV7,
    documentVer: (version ?? id).asUuidV7,
    documentLocator: CoseDocumentLocator.fallback(),
  );

  static SignedDocumentRef fromCose(CoseDocumentRef cose) {
    return SignedDocumentRef(
      id: cose.documentId.format(),
      version: cose.documentVer.format(),
    );
  }
}

extension _DocumentRefsExt on List<DocumentRef> {
  CoseDocumentRefs get asCose => CoseDocumentRefs(map((e) => e.asCose).toList());

  static List<SignedDocumentRef> fromCose(CoseDocumentRefs cose) {
    return cose.refs.map(_DocumentRefExt.fromCose).toList();
  }
}

extension _SignedDocumentContentTypeExt on DocumentContentType {
  /// Maps the [DocumentContentType] into COSE representation.
  CoseMediaType? get asCose {
    switch (this) {
      case DocumentContentType.json:
        return CoseMediaType.json;
      case DocumentContentType.unknown:
        return null;
    }
  }

  static DocumentContentType fromCose(CoseMediaType? mediaType) {
    switch (mediaType) {
      case CoseMediaType.json:
        return DocumentContentType.json;
      case CoseMediaType.cbor:
      case CoseMediaType.cddl:
      case CoseMediaType.schemaJson:
      case CoseMediaType.css:
      case CoseMediaType.cssHandlebars:
      case CoseMediaType.html:
      case CoseMediaType.htmlHandlebars:
      case CoseMediaType.markdown:
      case CoseMediaType.markdownHandlebars:
      case CoseMediaType.plain:
      case CoseMediaType.plainHandlebars:
      case null:
        return DocumentContentType.unknown;
    }
  }
}

extension _UuidExt on String {
  CoseUuidV4 get asUuidV4 => CoseUuidV4.fromString(this);

  CoseUuidV7 get asUuidV7 => CoseUuidV7.fromString(this);
}
