import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_manager.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

const _brotliEncoding = CoseStringValue(CoseValues.brotliContentEncoding);

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
    final metadata = _SignedDocumentMetadataExt.fromCose(
      protectedHeaders: coseSign.protectedHeaders,
      unprotectedHeaders: coseSign.unprotectedHeaders,
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
      signers: coseSign.signatures.map((e) => e.decodeCatalystId()).nonNulls.toList(),
    );
  }

  @override
  Future<SignedDocument> signDocument(
    SignedDocumentPayload document, {
    required SignedDocumentMetadata metadata,
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
    if (coseSign.protectedHeaders.contentEncoding == _brotliEncoding) {
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
  Future<Uint8List?> get kid async {
    final string = _catalystId.toUri().toString();
    return utf8.encode(string);
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
  Future<Uint8List?> get kid async {
    final string = _catalystId.toUri().toString();
    return utf8.encode(string);
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
  final SignedDocumentMetadata metadata;

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

extension _CoseSignatureExt on CoseSignature {
  CatalystId? decodeCatalystId() {
    final kid = protectedHeaders.kid;
    if (kid == null) return null;

    final string = utf8.decode(kid);
    final uri = Uri.tryParse(string);
    if (uri == null) return null;

    return CatalystId.fromUri(uri);
  }
}

extension _SignedDocumentContentTypeExt on SignedDocumentContentType {
  /// Maps the [SignedDocumentContentType] into COSE representation.
  CoseStringOrInt? get asCose {
    switch (this) {
      case SignedDocumentContentType.json:
        return const CoseIntValue(CoseValues.jsonContentType);
      case SignedDocumentContentType.unknown:
        return null;
    }
  }

  static SignedDocumentContentType fromCose(CoseStringOrInt? contentType) {
    switch (contentType) {
      case CoseIntValue():
        return switch (contentType.value) {
          CoseValues.jsonContentType => SignedDocumentContentType.json,
          _ => SignedDocumentContentType.unknown,
        };
      case CoseStringValue():
      case null:
        return SignedDocumentContentType.unknown;
    }
  }
}

extension _SignedDocumentMetadataExt on SignedDocumentMetadata {
  CoseHeaders get asCoseProtectedHeaders {
    final ref = this.ref;
    final template = this.template;
    final reply = this.reply;

    return CoseHeaders.protected(
      contentType: contentType.asCose,
      contentEncoding: _brotliEncoding,
      type: documentType.uuid.asUuid,
      id: id?.asUuid,
      ver: ver?.asUuid,
      ref: ref == null ? null : [ref].asCose,
      template: template == null ? null : [template].asCose,
      reply: reply == null ? null : [reply].asCose,
      section: section,
      collaborators: collaborators,
      parameters: parameters.asCose,
    );
  }

  CoseHeaders get asCoseUnprotectedHeaders {
    return const CoseHeaders.unprotected();
  }

  static SignedDocumentMetadata fromCose({
    required CoseHeaders protectedHeaders,
    required CoseHeaders unprotectedHeaders,
  }) {
    final type = protectedHeaders.type?.value;
    final ref = protectedHeaders.ref;
    final template = protectedHeaders.template;
    final reply = protectedHeaders.reply;
    final parameters = protectedHeaders.parameters;

    return SignedDocumentMetadata(
      contentType: _SignedDocumentContentTypeExt.fromCose(
        protectedHeaders.contentType,
      ),
      documentType: type == null ? DocumentType.unknown : DocumentType.fromJson(type),
      id: protectedHeaders.id?.value,
      ver: protectedHeaders.ver?.value,
      ref: ref == null ? null : _SignedDocumentMetadataRefsExt.fromCose(ref).firstOrNull,
      template: template == null
          ? null
          : _SignedDocumentMetadataRefsExt.fromCose(template).firstOrNull,
      reply: reply == null ? null : _SignedDocumentMetadataRefsExt.fromCose(reply).firstOrNull,
      section: protectedHeaders.section,
      collaborators: protectedHeaders.collaborators,
      parameters: parameters == null
          ? const []
          : _SignedDocumentMetadataRefsExt.fromCose(parameters),
    );
  }
}

extension _SignedDocumentMetadataRefExt on SignedDocumentMetadataRef {
  CoseDocumentRef get asCose => CoseDocumentRef.backwardCompatible(
    documentId: id.asUuid,
    documentVer: ver.asUuid,
    documentLocator: CoseDocumentLocator.fallback(),
  );

  static SignedDocumentMetadataRef fromCose(CoseDocumentRef cose) {
    return SignedDocumentMetadataRef(
      id: cose.documentId.value,
      ver: cose.documentVer.value,
    );
  }
}

extension _SignedDocumentMetadataRefsExt on List<SignedDocumentMetadataRef> {
  CoseDocumentRefs get asCose => CoseDocumentRefs(map((e) => e.asCose).toList());

  static List<SignedDocumentMetadataRef> fromCose(CoseDocumentRefs cose) {
    return cose.refs.map(_SignedDocumentMetadataRefExt.fromCose).toList();
  }
}

extension _UuidExt on String {
  CoseUuid get asUuid => CoseUuid(this);
}
