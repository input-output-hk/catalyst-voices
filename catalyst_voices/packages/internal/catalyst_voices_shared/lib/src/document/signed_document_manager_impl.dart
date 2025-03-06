part of 'signed_document_manager.dart';

const _brotliEncoding = StringValue(CoseValues.brotliContentEncoding);

final class _Bip32Ed25519XSigner implements CatalystCoseSigner {
  final Uint8List publicKey;
  final Uint8List privateKey;

  const _Bip32Ed25519XSigner(this.publicKey, this.privateKey);

  @override
  StringOrInt? get alg => const IntValue(CoseValues.eddsaAlg);

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
    extends SignedDocument<T> with EquatableMixin {
  final CoseSign _coseSign;

  @override
  final T payload;

  const _CoseSignedDocument(this._coseSign, this.payload);

  @override
  List<Object?> get props => [_coseSign, payload];

  @override
  Uint8List toBytes() {
    final bytes = cbor.encode(_coseSign.toCbor());
    return Uint8List.fromList(bytes);
  }

  @override
  Future<bool> verifySignature(Uint8List publicKey) async {
    return _coseSign.verify(
      verifier: _Bip32Ed25519XVerifier(publicKey),
    );
  }
}

final class _SignedDocumentManagerImpl implements SignedDocumentManager {
  const _SignedDocumentManagerImpl();

  @override
  Future<SignedDocument<T>> parseDocument<T extends SignedDocumentPayload>(
    Uint8List bytes, {
    required SignedDocumentPayloadParser<T> parser,
  }) async {
    final coseSign = CoseSign.fromCbor(cbor.decode(bytes));
    final payload = await _brotliDecompressPayload(coseSign);
    final document = parser(payload);
    return _CoseSignedDocument(coseSign, document);
  }

  @override
  Future<SignedDocument<T>> signDocument<T extends SignedDocumentPayload>(
    T document, {
    required SignedDocumentMetadata metadata,
    required Uint8List publicKey,
    required Uint8List privateKey,
  }) async {
    final compressedPayload = await _brotliCompressPayload(document.toBytes());
    final protectedHeaders = CoseHeaders.protected(
      contentEncoding: _brotliEncoding,
      contentType: metadata.contentType.asCose,
    );

    final coseSign = await CoseSign.sign(
      protectedHeaders: protectedHeaders,
      unprotectedHeaders: const CoseHeaders.unprotected(),
      payload: compressedPayload,
      signers: [_Bip32Ed25519XSigner(publicKey, privateKey)],
    );

    return _CoseSignedDocument(coseSign, document);
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

extension _CoseDocumentContentType on DocumentContentType {
  /// Maps the [DocumentContentType] into COSE representation.
  StringOrInt get asCose {
    switch (this) {
      case DocumentContentType.json:
        return const IntValue(CoseValues.jsonContentType);
    }
  }
}
