import 'dart:typed_data';

import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
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
    );
  }

  @override
  Future<SignedDocument<T>> signDocument<T extends SignedDocumentPayload>(
    T document, {
    required SignedDocumentMetadata metadata,
    required Uint8List publicKey,
    required Uint8List privateKey,
  }) async {
    final compressedPayload = await _brotliCompressPayload(document.toBytes());

    final coseSign = await CoseSign.sign(
      protectedHeaders: metadata.asCoseProtectedHeaders,
      unprotectedHeaders: metadata.asCoseUnprotectedHeaders,
      payload: compressedPayload,
      signers: [_Bip32Ed25519XSigner(publicKey, privateKey)],
    );

    return _CoseSignedDocument(
      coseSign: coseSign,
      payload: document,
      metadata: metadata,
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

final class _Bip32Ed25519XSigner implements CatalystCoseSigner {
  final Uint8List publicKey;
  final Uint8List privateKey;

  const _Bip32Ed25519XSigner(this.publicKey, this.privateKey);

  @override
  StringOrInt? get alg => const IntValue(CoseValues.eddsaAlg);

  // TODO(dtscalac): provide the kid in catalyst ID format,
  // not just public key bytes
  @override
  Future<Uint8List?> get kid async => publicKey;

  @override
  Future<Uint8List> sign(Uint8List data) async {
    final pk = Bip32Ed25519XPrivateKeyFactory.instance.fromBytes(privateKey);
    final signature = await pk.sign(data);
    return Uint8List.fromList(signature.bytes);
  }
}

final class _Bip32Ed25519XVerifier implements CatalystCoseVerifier {
  final Uint8List publicKey;

  const _Bip32Ed25519XVerifier(this.publicKey);

  // TODO(dtscalac): provide the kid in catalyst ID format,
  // not just public key bytes
  @override
  Future<Uint8List?> get kid async => publicKey;

  @override
  Future<bool> verify(Uint8List data, Uint8List signature) async {
    final pk = Bip32Ed25519XPublicKeyFactory.instance.fromBytes(publicKey);
    return pk.verify(
      data,
      signature: Bip32Ed25519XSignatureFactory.instance.fromBytes(signature),
    );
  }
}

final class _CoseSignedDocument<T extends SignedDocumentPayload>
    with EquatableMixin
    implements SignedDocument<T> {
  final CoseSign coseSign;

  @override
  final T payload;

  @override
  final SignedDocumentMetadata metadata;

  const _CoseSignedDocument({
    required this.coseSign,
    required this.payload,
    required this.metadata,
  });

  @override
  List<Object?> get props => [coseSign, payload, metadata];

  @override
  Uint8List toBytes() {
    final bytes = cbor.encode(coseSign.toCbor());
    return Uint8List.fromList(bytes);
  }

  @override
  Future<bool> verifySignature(Uint8List publicKey) async {
    return coseSign.verify(
      verifier: _Bip32Ed25519XVerifier(publicKey),
    );
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
