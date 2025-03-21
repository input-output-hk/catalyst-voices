import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_manager.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

const _brotliEncoding = StringValue(CoseValues.brotliContentEncoding);

final class SignedDocumentManagerImpl implements SignedDocumentManager {
  const SignedDocumentManagerImpl();

  @override
  Future<SignedDocument<T>> parseDocument<T extends SignedDocumentPayload>(
    Uint8List bytes, {
    required SignedDocumentPayloadParser<T> parser,
  }) async {
    final coseSign = CoseSign.fromCbor(cbor.decode(bytes));
    final payloadBytes = await _brotliDecompressPayload(coseSign);
    final payload = parser(payloadBytes);

    final metadata = _SignedDocumentMetadataExt.fromCose(
      protectedHeaders: coseSign.protectedHeaders,
      unprotectedHeaders: coseSign.unprotectedHeaders,
    );

    return _CoseSignedDocument(
      coseSign: coseSign,
      payload: payload,
      metadata: metadata,
      signers: coseSign.signatures
          .map((e) => e.decodeCatalystId())
          .nonNulls
          .toList(),
    );
  }

  @override
  Future<SignedDocument<T>> signDocument<T extends SignedDocumentPayload>(
    T document, {
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
    final compressor = CatalystCompression.instance.brotli;
    final compressed = await compressor.compress(payload);
    return Uint8List.fromList(compressed);
  }

  Future<Uint8List> _brotliDecompressPayload(CoseSign coseSign) async {
    if (coseSign.protectedHeaders.contentEncoding == _brotliEncoding) {
      final compressor = CatalystCompression.instance.brotli;
      final decompressed = await compressor.decompress(coseSign.payload);
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
  StringOrInt? get alg => const IntValue(CoseValues.eddsaAlg);

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
    // TODO(dtscalac): obtain the public key corresponding
    // to the private key which generated the signature and use
    // it for verification, most likely the role0Key is not the correct one.
    final catalystSignature = CatalystSignature.factory.create(signature);
    return CatalystPublicKey.factory
        .create(_catalystId.role0Key)
        .verify(data, signature: catalystSignature);
  }
}

final class _CoseSignedDocument<T extends SignedDocumentPayload>
    with EquatableMixin
    implements SignedDocument<T> {
  final CoseSign _coseSign;

  @override
  final T payload;

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
  StringOrInt? get asCose {
    switch (this) {
      case SignedDocumentContentType.json:
        return const IntValue(CoseValues.jsonContentType);
      case SignedDocumentContentType.unknown:
        return null;
    }
  }

  static SignedDocumentContentType fromCose(StringOrInt? contentType) {
    switch (contentType) {
      case IntValue():
        return switch (contentType.value) {
          CoseValues.jsonContentType => SignedDocumentContentType.json,
          _ => SignedDocumentContentType.unknown
        };
      case StringValue():
      case null:
        return SignedDocumentContentType.unknown;
    }
  }
}

extension _SignedDocumentMetadataExt on SignedDocumentMetadata {
  CoseHeaders get asCoseProtectedHeaders {
    return CoseHeaders.protected(
      contentType: contentType.asCose,
      contentEncoding: _brotliEncoding,
      type: documentType.uuid.asUuid,
      id: id?.asUuid,
      ver: ver?.asUuid,
      ref: ref?.asCose,
      refHash: refHash?.asCose,
      template: template?.asCose,
      reply: reply?.asCose,
      section: section,
      collabs: collabs,
      brandId: brandId?.asCose,
      campaignId: campaignId?.asCose,
      electionId: electionId,
      categoryId: categoryId?.asCose,
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
      documentType:
          type == null ? DocumentType.unknown : DocumentType.fromJson(type),
      id: protectedHeaders.id?.value,
      ver: protectedHeaders.ver?.value,
      ref: ref == null ? null : _SignedDocumentMetadataRefExt.fromCose(ref),
      refHash: refHash == null
          ? null
          : _SignedDocumentMetadataRefHashExt.fromCose(refHash),
      template: template == null
          ? null
          : _SignedDocumentMetadataRefExt.fromCose(template),
      reply:
          reply == null ? null : _SignedDocumentMetadataRefExt.fromCose(reply),
      section: protectedHeaders.section,
      collabs: protectedHeaders.collabs,
      brandId: brandId == null
          ? null
          : _SignedDocumentMetadataRefExt.fromCose(brandId),
      campaignId: campaignId == null
          ? null
          : _SignedDocumentMetadataRefExt.fromCose(campaignId),
      electionId: protectedHeaders.electionId,
      categoryId: categoryId == null
          ? null
          : _SignedDocumentMetadataRefExt.fromCose(categoryId),
    );
  }
}

extension _SignedDocumentMetadataRefExt on SignedDocumentMetadataRef {
  ReferenceUuid get asCose => ReferenceUuid(
        id: id.asUuid,
        ver: ver?.asUuid,
      );

  static SignedDocumentMetadataRef fromCose(ReferenceUuid ref) {
    return SignedDocumentMetadataRef(
      id: ref.id.value,
      ver: ref.ver?.value,
    );
  }
}

extension _SignedDocumentMetadataRefHashExt on SignedDocumentMetadataRefHash {
  ReferenceUuidHash get asCose => ReferenceUuidHash(
        ref: ref.asCose,
        hash: hash,
      );

  static SignedDocumentMetadataRefHash fromCose(ReferenceUuidHash ref) {
    return SignedDocumentMetadataRefHash(
      ref: _SignedDocumentMetadataRefExt.fromCose(ref.ref),
      hash: ref.hash,
    );
  }
}

extension _UuidExt on String {
  Uuid get asUuid => Uuid(this);
}
