import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_manager.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_mapper.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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

    final rawPayload = await _decompressPayload(coseSign);

    return _CoseSignedDocument.fromCose(
      coseSign,
      rawPayload: rawPayload,
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
      final compressedPayload = await _compressPayload(payload.toBytes());

      final coseSign = await profiler.timeWithResult(
        'cose_sign_doc',
        () {
          return CoseSign.sign(
            protectedHeaders: SignedDocumentMapper.buildCoseProtectedHeaders(metadata),
            unprotectedHeaders: const CoseHeaders.unprotected(),
            payload: compressedPayload,
            signers: [_CatalystSigner(catalystId, privateKey)],
          );
        },
        debounce: true,
      );

      return _CoseSignedDocument.fromCose(
        coseSign,
        rawPayload: payload.toBytes(),
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
      final coseSign = await profiler.timeWithResult(
        'cose_sign_doc',
        () {
          return CoseSign.sign(
            protectedHeaders: SignedDocumentMapper.buildCoseProtectedHeaders(metadata),
            unprotectedHeaders: const CoseHeaders.unprotected(),
            payload: CosePayload(payload.bytes),
            signers: [_CatalystSigner(catalystId, privateKey)],
          );
        },
        debounce: true,
      );

      final rawPayload = await _decompressPayload(coseSign);

      return _CoseSignedDocument.fromCose(
        coseSign,
        rawPayload: rawPayload,
      );
    } on CoseSignException catch (error) {
      throw DocumentSignException('Failed to create a signed document!\nSource: ${error.source}');
    }
  }

  Future<CosePayload> _compressPayload(SignedDocumentPayloadBytes payload) async {
    final compressed = await profiler.timeWithResult(
      'brotli_compress',
      () => brotli.compress(payload.bytes),
      debounce: true,
    );
    return CosePayload(Uint8List.fromList(compressed));
  }

  Future<SignedDocumentPayloadBytes> _decompressPayload(CoseSign coseSign) async {
    if (coseSign.protectedHeaders.contentEncoding == CoseHttpContentEncoding.brotli) {
      final decompressed = await profiler.timeWithResult(
        'brotli_decompress',
        () => brotli.decompress(coseSign.payload.bytes),
        debounce: true,
      );
      return SignedDocumentPayloadBytes(Uint8List.fromList(decompressed));
    } else {
      return SignedDocumentPayloadBytes(coseSign.payload.bytes);
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

  factory _CoseSignedDocument.fromCose(
    CoseSign coseSign, {
    required SignedDocumentPayloadBytes rawPayload,
  }) {
    final signers = coseSign.signatures
        .map((e) => e.protectedHeaders.kid)
        .nonNulls
        .cast<CatalystIdKid>()
        .toList();

    final metadata = SignedDocumentMapper.buildMetadata(
      protectedHeaders: coseSign.protectedHeaders,
      unprotectedHeaders: coseSign.unprotectedHeaders,
      signers: signers,
    );
    final payload = SignedDocumentPayload.fromBytes(
      rawPayload,
      contentType: metadata.contentType,
    );

    return _CoseSignedDocument(
      coseSign: coseSign,
      payload: payload,
      metadata: metadata,
      signers: metadata.signers ?? [],
    );
  }

  @override
  List<Object?> get props => [_coseSign, payload, metadata, signers];

  @override
  SignedDocumentRawPayload get rawPayload => SignedDocumentRawPayload(_coseSign.payload.bytes);

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
