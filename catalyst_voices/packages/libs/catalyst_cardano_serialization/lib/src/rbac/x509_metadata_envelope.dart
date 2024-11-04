import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// Serializes the type [T] into cbor.
///
/// In most cases the [T] type is going to be [RegistrationData].
typedef ChunkedDataSerializer<T> = CborValue Function(T value);

/// Deserializes the type [T] from cbor.
///
/// In most cases the [T] type is going to be [RegistrationData].
typedef ChunkedDataDeserializer<T> = T Function(CborValue value);

/// X509 Certificate metadata and related metadata within
/// a x509 Registration/Update transaction must be protected
/// against replayability.
///
/// X509 certificate registration necessarily references data within the
/// transaction body that it is attached to. Preventing replayability of the
/// verbatim Auxiliary data attached to a transaction prevents the relationships
/// between those references being altered and closes a potential attack vector
/// where an unrelated registration update is attached to a different
/// transaction.
final class X509MetadataEnvelope<T> extends Equatable {
  /// The size of a chunk of data that is used to overcome
  /// the field size limitation.
  static const int metadataChunkSize = 64;

  /// Purpose is defined by the consuming dApp. It allows a dApp to have
  /// their own privately named and managed namespace for certificates.
  /// The X509 specifications presented here do not define how certificates
  /// must be created. Nor the purpose they are used for, that is within control
  /// of each dApp. These specifications define a universal framework
  /// to implement such systems from.
  final UuidV4 purpose;

  /// This is a hash of the transaction inputs field from the transaction this
  /// auxiliary data was originally attached to. This hash anchors the auxiliary
  /// data to a particular transaction, if the auxiliary data is moved to a new
  /// transaction it is impossible for the txn-inputs-hash to remain the same,
  /// as UTXO's can only be spent once.
  ///
  /// This is a key to preventing replayability of the metadata,
  /// but is not enough by itself as it needs to be able to be made immutable,
  /// such that any change to this field can be detected.
  final TransactionInputsHash txInputsHash;

  /// This is a 32 byte hash of the previous transaction in a chain
  /// of registration updates made by the same user. The only registration
  /// which may not have it for a single user is their first. Once their first
  /// registration is made, they may only update it. Any subsequent update for
  /// that user who is not properly chained to the previous transaction will
  /// be ignored as invalid.
  ///
  /// The user is identified by their Role 0 key, which must be defined
  /// in the first registration. The Role 0 key also includes a reference
  /// to an on-chain key, such as a stake key hash. This is important
  /// to establish the veracity of the link between the registrations
  /// and the transaction itself.
  final TransactionHash? previousTransactionId;

  /// Except for the first registration, the chunked data is optional.
  /// For example, if this metadata is simply being used to lock auxiliary
  /// data to a transaction, there does not need to be any actual role
  /// or certificate updates.
  ///
  /// Due to the potential size of X509 certificates, compression is mandatory
  /// where it will reduce the space of the encoded data. Any dApp can, if it
  /// chooses, only support either Brotli or ZSTD and not trial compress the
  /// data. A conformant dApp MUST NOT store Raw data if it can be compressed.
  /// A conformant dApp MUST NOT store data compressed if the compressed size
  /// is larger than the raw size. Compressed Data can be larger than Raw Data
  /// if the data is small and not very compressible. This is an artifact
  /// of overhead in the codec data stream itself.
  ///
  /// These chunks are then encoded in an array of 64 byte long byte strings.
  /// The appropriate key is used to identify the compression used.
  /// 10 = Raw, no compression
  /// 11 = Brotli Compressed
  /// 12 = ZSTD Compressed
  ///
  /// The specification reserves keys 13-17 for future compression schemes.
  /// Even though there are multiple keys defined, ONLY 1 may be used at a time.
  /// There is only a single list of X509 chunks, and the key is used to define
  /// the compression used only.
  final T? chunkedData;

  /// Key 99 contains the signature, which can be verified with the signing key
  /// recorded against role 0.
  ///
  /// It is a signature over the entire auxiliary data that will be attached to
  /// the transaction. This includes not only the transaction's metadata,
  /// but all attached scripts.
  ///
  /// As the auxiliary data key 99 is part of the auxiliary data, we end up
  /// with a catch-22. We can't sign the data because we do not know what data
  /// will be stored in the signature field. To mitigate this problem, the size
  /// of the signature will be known in advanced, based on the signature
  /// algorithm. When the unsigned auxiliary data is prepared, the appropriate
  /// storage for the signature is pre-allocated in the metadata,
  /// and is set to 0x00's.
  ///
  /// The signature is calculated over this unsigned data, and the
  /// pre-allocated signature storage is replaced with the signature itself.
  final Ed25519ExtendedSignature validationSignature;

  /// The default constructor for [X509MetadataEnvelope].
  const X509MetadataEnvelope({
    required this.purpose,
    required this.txInputsHash,
    this.previousTransactionId,
    this.chunkedData,
    required this.validationSignature,
  });

  /// Constructs a [X509MetadataEnvelope] that is not signed yet.
  ///
  /// A [Ed25519ExtendedSignature] can be used to sign
  /// the envelope with [sign] method.
  X509MetadataEnvelope.unsigned({
    required this.purpose,
    required this.txInputsHash,
    this.previousTransactionId,
    this.chunkedData,
  }) : validationSignature = Ed25519ExtendedSignature.seeded(0);

  /// Deserializes the type from cbor.
  ///
  /// The [deserializer] in most cases is going
  /// to be [RegistrationData.fromCbor].
  static Future<X509MetadataEnvelope<T>> fromCbor<T>(
    CborValue value, {
    required ChunkedDataDeserializer<T> deserializer,
  }) async {
    final metadata = value as CborMap;
    final envelope = metadata[const CborSmallInt(509)]! as CborMap;
    final purpose = envelope[const CborSmallInt(0)]! as CborBytes;
    final txInputsHash = envelope[const CborSmallInt(1)]!;
    final previousTransactionId = envelope[const CborSmallInt(2)];
    final chunkedData = await _deserializeChunkedData(envelope);
    final validationSignature = envelope[const CborSmallInt(99)]!;

    return X509MetadataEnvelope(
      purpose: UuidV4.fromCbor(purpose),
      txInputsHash: TransactionInputsHash.fromCbor(txInputsHash),
      previousTransactionId: previousTransactionId != null
          ? TransactionHash.fromCbor(previousTransactionId)
          : null,
      chunkedData: chunkedData != null ? deserializer(chunkedData) : null,
      validationSignature:
          Ed25519ExtendedSignature.fromCbor(validationSignature),
    );
  }

  /// Serializes the type as cbor.
  ///
  /// The [serializer] in most cases is going to be [RegistrationData.toCbor].
  Future<CborValue> toCbor({
    required ChunkedDataSerializer<T> serializer,
  }) async {
    final chunkedData = this.chunkedData;
    final metadata = chunkedData != null
        ? await _serializeChunkedData(serializer(chunkedData))
        : null;

    return CborMap({
      const CborSmallInt(509): CborMap({
        const CborSmallInt(0): purpose.toCbor(),
        const CborSmallInt(1): txInputsHash.toCbor(),
        if (previousTransactionId != null)
          const CborSmallInt(2): previousTransactionId!.toCbor(),
        if (metadata != null) metadata.key: metadata.value,
        const CborSmallInt(99): validationSignature.toCbor(),
      }),
    });
  }

  /// Serializes the envelope into bytes, signs it with the [privateKey]
  /// and returns a copy of the [X509MetadataEnvelope]
  /// with the resulting [validationSignature].
  ///
  /// The [serializer] in most cases is going to be [RegistrationData.toCbor].
  Future<X509MetadataEnvelope<T>> sign({
    required Ed25519ExtendedPrivateKey privateKey,
    required ChunkedDataSerializer<T> serializer,
  }) async {
    final bytes = cbor.encode(await toCbor(serializer: serializer));
    final signature = await privateKey.sign(bytes);
    return withValidationSignature(signature);
  }

  /// Returns true if given [signature] belongs to a given [publicKey]
  /// for this [X509MetadataEnvelope], false otherwise.
  ///
  /// The [serializer] in most cases is going to be [RegistrationData.toCbor].
  Future<bool> verifySignature({
    required Ed25519ExtendedSignature signature,
    required Ed25519ExtendedPublicKey publicKey,
    required ChunkedDataSerializer<T> serializer,
  }) async {
    final envelope =
        withValidationSignature(Ed25519ExtendedSignature.seeded(0));
    final bytes = cbor.encode(await envelope.toCbor(serializer: serializer));
    return publicKey.verify(bytes, signature: signature);
  }

  /// Returns a copy of this [X509MetadataEnvelope]
  /// with given [validationSignature].
  X509MetadataEnvelope<T> withValidationSignature(
    Ed25519ExtendedSignature validationSignature,
  ) {
    return X509MetadataEnvelope(
      purpose: purpose,
      txInputsHash: txInputsHash,
      previousTransactionId: previousTransactionId,
      chunkedData: chunkedData,
      validationSignature: validationSignature,
    );
  }

  static Future<CborValue?> _deserializeChunkedData(CborMap map) async {
    final rawCbor = map[const CborSmallInt(10)] as CborList?;
    if (rawCbor != null) {
      final bytes = _unchunkCborBytes(rawCbor);
      return cbor.decode(bytes);
    }

    final brotliCbor = map[const CborSmallInt(11)] as CborList?;
    if (brotliCbor != null) {
      final bytes = _unchunkCborBytes(brotliCbor);
      final uncompressedBytes =
          await CatalystCompression.instance.brotli.decompress(bytes);
      return cbor.decode(uncompressedBytes);
    }

    final zstdCbor = map[const CborSmallInt(12)] as CborList?;
    if (zstdCbor != null) {
      final bytes = _unchunkCborBytes(zstdCbor);
      final uncompressedBytes =
          await CatalystCompression.instance.zstd.decompress(bytes);
      return cbor.decode(uncompressedBytes);
    }

    return null;
  }

  static Future<MapEntry<CborSmallInt, CborList>> _serializeChunkedData(
    CborValue value,
  ) async {
    final rawBytes = cbor.encode(value);
    final brotliBytes = await _compressBrotli(rawBytes);
    final zstdBytes = await _compressZstd(rawBytes);

    final bytesByKey = {
      10: rawBytes,
      if (brotliBytes != null) 11: brotliBytes,
      if (zstdBytes != null) 12: zstdBytes,
    }.entries.toList()
      ..sort((a, b) => a.value.length - b.value.length);

    final smallestBytes = bytesByKey.first;
    final chunkedBytes = _chunkCborBytes(smallestBytes.value);

    return MapEntry(
      CborSmallInt(smallestBytes.key),
      CborList([
        for (final chunk in chunkedBytes) CborBytes(chunk),
      ]),
    );
  }

  static Future<List<int>?> _compressBrotli(List<int> bytes) async {
    try {
      return await CatalystCompression.instance.brotli.compress(bytes);
    } on CompressionNotSupportedException {
      return null;
    }
  }

  static Future<List<int>?> _compressZstd(List<int> bytes) async {
    try {
      return await CatalystCompression.instance.zstd.compress(bytes);
    } on CompressionNotSupportedException {
      return null;
    }
  }

  static List<List<int>> _chunkCborBytes(List<int> bytes) {
    final chunks = <List<int>>[];
    for (var i = 0; i < bytes.length; i += metadataChunkSize) {
      chunks.add(
        bytes.sublist(
          i,
          i + metadataChunkSize > bytes.length
              ? bytes.length
              : i + metadataChunkSize,
        ),
      );
    }
    return chunks;
  }

  static List<int> _unchunkCborBytes(CborList chunkedBytes) {
    final result = <int>[];
    for (final chunk in chunkedBytes) {
      result.addAll((chunk as CborBytes).bytes);
    }
    return result;
  }

  @override
  List<Object?> get props => [
        purpose,
        txInputsHash,
        previousTransactionId,
        chunkedData,
        validationSignature,
      ];
}
