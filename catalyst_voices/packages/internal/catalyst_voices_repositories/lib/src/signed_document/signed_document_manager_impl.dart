import 'dart:convert';

import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_manager.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

const _brotliEncoding = StringValue(CoseValues.brotliContentEncoding);

final class SignedDocumentManagerImpl implements SignedDocumentManager {
  final CatalystCompressor brotli;
  final CatalystCompressor zstd;
  final CatalystProfiler profiler;

  const SignedDocumentManagerImpl({
    required this.brotli,
    required this.zstd,
    this.profiler = const CatalystNoopProfiler(),
  });

  @override
  Future<SignedDocument> parseDocument(DocumentArtifact artifact) async {
    final cborValue = await profiler.timeWithResult(
      'cbor_decode_doc',
      () => cbor.decode(artifact.value),
      debounce: true,
    );
    final coseSign = await profiler.timeWithResult(
      'cose_decode',
      () => CoseSign.fromCbor(cborValue),
      debounce: true,
    );

    final metadata = _SignedDocumentMetadataExt.fromCose(
      protectedHeaders: coseSign.protectedHeaders,
      unprotectedHeaders: coseSign.unprotectedHeaders,
    );

    final payloadBytes = await _brotliDecompressPayload(coseSign);
    final payload = SignedDocumentPayload.fromBytes(
      payloadBytes,
      contentType: metadata.contentType,
    );

    final signers = coseSign.signatures.map((e) => e.decodeCatalystId()).nonNulls.toList();

    return _CoseSignedDocument(
      coseSign: coseSign,
      payload: payload,
      metadata: metadata.toModel(authors: signers),
      signers: signers,
    );
  }

  @override
  Future<SignedDocument> signDocument(
    SignedDocumentPayload payload, {
    required DocumentDataMetadata metadata,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    try {
      final compressedPayload = await _brotliCompressPayload(payload.toBytes());

      return _signDocument(
        metadata: metadata,
        protectedHeaders: const CoseHeaders.protected(),
        unprotectedHeaders: const CoseHeaders.unprotected(),
        rawPayload: compressedPayload,
        parsedPayload: payload,
        catalystId: catalystId,
        signers: [_CatalystSigner(catalystId, privateKey)],
      );
    } on CoseSignException catch (error) {
      throw DocumentSignException('Failed to create a signed document!\nSource: ${error.source}');
    }
  }

  @override
  Future<SignedDocument> signRawDocument(
    SignedDocumentRawPayload payload, {
    required DocumentDataMetadata metadata,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    try {
      final parsedPayload = SignedDocumentPayload.fromBytes(
        payload.bytes,
        // TODO(dt-iohk): Convert the content type from model to what's expected here.
        // The `SignedDocumentMapper` which should do that is not on this branch yet.
        contentType: SignedDocumentContentType.json,
      );

      return _signDocument(
        metadata: metadata,
        protectedHeaders: const CoseHeaders.protected(),
        unprotectedHeaders: const CoseHeaders.unprotected(),
        rawPayload: payload,
        parsedPayload: parsedPayload,
        catalystId: catalystId,
        signers: [_CatalystSigner(catalystId, privateKey)],
      );
    } on CoseSignException catch (error) {
      throw DocumentSignException('Failed to create a signed document!\nSource: ${error.source}');
    }
  }

  Future<SignedDocumentRawPayload> _brotliCompressPayload(Uint8List payload) async {
    final compressed = await profiler.timeWithResult(
      'brotli_compress',
      () => brotli.compress(payload),
      debounce: true,
    );
    return SignedDocumentRawPayload(Uint8List.fromList(compressed));
  }

  Future<Uint8List> _brotliDecompressPayload(CoseSign coseSign) async {
    if (coseSign.protectedHeaders.contentEncoding == _brotliEncoding) {
      final decompressed = await profiler.timeWithResult(
        'brotli_decompress',
        () => brotli.decompress(coseSign.payload),
        debounce: true,
      );
      return Uint8List.fromList(decompressed);
    } else {
      return coseSign.payload;
    }
  }

  Future<SignedDocument> _signDocument({
    required DocumentDataMetadata metadata,
    required CoseHeaders protectedHeaders,
    required CoseHeaders unprotectedHeaders,
    required SignedDocumentRawPayload rawPayload,
    required SignedDocumentPayload parsedPayload,
    required CatalystId catalystId,
    required List<CatalystCoseSigner> signers,
  }) async {
    final coseSign = await profiler.timeWithResult(
      'cose_sign_doc',
      () {
        return CoseSign.sign(
          protectedHeaders: const CoseHeaders.protected(),
          unprotectedHeaders: const CoseHeaders.unprotected(),
          payload: rawPayload.bytes,
          signers: signers,
        );
      },
      debounce: true,
    );

    return _CoseSignedDocument(
      coseSign: coseSign,
      payload: payload,
      metadata: metadata,
      signers: [catalystId],
    );
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
  StringOrInt? get alg => null;

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
  SignedDocumentRawPayload get rawPayload => SignedDocumentRawPayload(_coseSign.payload);

  @override
  DocumentArtifact toArtifact() {
    final bytes = cbor.encode(_coseSign.toCbor(tagged: false));
    return DocumentArtifact(Uint8List.fromList(bytes));
  }

  @override
  Future<bool> verifySignature(CatalystId catalystId) async {
    return _coseSign.verify(verifier: _CatalystVerifier(catalystId));
  }
}

extension on SignedDocumentMetadata {
  DocumentDataMetadata toModel({
    List<CatalystId>? authors,
  }) {
    final id = this.id;
    final ver = this.ver;

    if (id == null) {
      throw const FormatException('Signed document id was null');
    }
    if (ver == null) {
      throw const FormatException('Signed document ver was null');
    }

    return DocumentDataMetadata(
      contentType: DocumentContentType.json,
      type: documentType,
      id: SignedDocumentRef(id: id, ver: ver),
      ref: ref?.toModel(),
      template: template?.toModel(),
      reply: reply?.toModel(),
      section: section,
      collaborators: collabs?.map(CatalystId.tryParse).nonNulls.toList(),
      parameters: DocumentParameters({
        ?brandId?.toModel(),
        ?campaignId?.toModel(),
        ?categoryId?.toModel(),
      }),
      authors: authors,
    );
  }
}

extension on SignedDocumentMetadataRef {
  SignedDocumentRef toModel() => SignedDocumentRef(id: id, ver: ver);
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
  static SignedDocumentContentType fromCose(StringOrInt? contentType) {
    switch (contentType) {
      case IntValue():
        return switch (contentType.value) {
          CoseValues.jsonContentType => SignedDocumentContentType.json,
          _ => SignedDocumentContentType.unknown,
        };
      case StringValue():
      case null:
        return SignedDocumentContentType.unknown;
    }
  }
}

extension _SignedDocumentMetadataExt on SignedDocumentMetadata {
  static SignedDocumentMetadata fromCose({
    required CoseHeaders protectedHeaders,
    required CoseHeaders unprotectedHeaders,
  }) {
    final type = protectedHeaders.type?.value;
    final ref = protectedHeaders.ref;
    final refHash = protectedHeaders.refHash;
    final template = protectedHeaders.template;
    final reply = protectedHeaders.reply;
    final brandId = protectedHeaders.brandId;
    final campaignId = protectedHeaders.campaignId;
    final categoryId = protectedHeaders.categoryId;

    return SignedDocumentMetadata(
      contentType: _SignedDocumentContentTypeExt.fromCose(
        protectedHeaders.contentType,
      ),
      documentType: type == null ? DocumentType.unknown : DocumentType.fromJson(type),
      id: protectedHeaders.id?.value,
      ver: protectedHeaders.ver?.value,
      ref: ref == null ? null : _SignedDocumentMetadataRefExt.fromCose(ref),
      refHash: refHash == null ? null : _SignedDocumentMetadataRefHashExt.fromCose(refHash),
      template: template == null ? null : _SignedDocumentMetadataRefExt.fromCose(template),
      reply: reply == null ? null : _SignedDocumentMetadataRefExt.fromCose(reply),
      section: protectedHeaders.section,
      collabs: protectedHeaders.collabs,
      brandId: brandId == null ? null : _SignedDocumentMetadataRefExt.fromCose(brandId),
      campaignId: campaignId == null ? null : _SignedDocumentMetadataRefExt.fromCose(campaignId),
      electionId: protectedHeaders.electionId,
      categoryId: categoryId == null ? null : _SignedDocumentMetadataRefExt.fromCose(categoryId),
    );
  }
}

extension _SignedDocumentMetadataRefExt on SignedDocumentMetadataRef {
  static SignedDocumentMetadataRef fromCose(ReferenceUuid ref) {
    return SignedDocumentMetadataRef(
      id: ref.id.value,
      ver: ref.ver?.value,
    );
  }
}

extension _SignedDocumentMetadataRefHashExt on SignedDocumentMetadataRefHash {
  static SignedDocumentMetadataRefHash fromCose(ReferenceUuidHash ref) {
    return SignedDocumentMetadataRefHash(
      ref: _SignedDocumentMetadataRefExt.fromCose(ref.ref),
      hash: ref.hash,
    );
  }
}
