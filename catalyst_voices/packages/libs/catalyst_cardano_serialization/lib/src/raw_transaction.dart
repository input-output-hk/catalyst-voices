//ignore_for_file: implementation_imports,invalid_use_of_internal_member

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/raw_transaction_aspect.dart';
import 'package:catalyst_cardano_serialization/src/raw_transaction_tracing_encode_sink.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:cbor/cbor.dart';
import 'package:cbor/src/encoder/sink.dart' as cbor_internal_sink;
import 'package:cbor/src/utils/arg.dart' as cbor_internal_arg;
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:typed_data/typed_buffers.dart';

/// Version of [BaseTransaction] which works on bytes and patching
/// of different parts.
///
/// It enables single encode transaction build.
final class RawTransaction extends BaseTransaction {
  final StructuredBytes<RawTransactionAspect> _structuredBytes;

  /// For testing only. Internal constructor for [RawTransaction].
  @visibleForTesting
  const RawTransaction(this._structuredBytes);

  /// Default factory constructor for [RawTransaction].
  ///
  /// It does custom encoding of each part of transaction and keeping
  /// track of important bytes parts for future patching.
  factory RawTransaction.from({
    required TransactionBody body,
    required TransactionWitnessSet witnessSet,
    required bool isValid,
    required AuxiliaryData auxiliaryData,
  }) {
    final buffer = Uint8Buffer();
    final sink =
        RawTransactionTracingEncodeSink(cbor_internal_sink.EncodeSink.withBuffer(buffer), 0)
          // [body, witnessSet, isValid, auxiliaryData]
          ..addHeaderInfo(CborMajorType.array, const cbor_internal_arg.Arg.int(4));

    // 1. body
    final txBodyMap = body.toCborValuesMap();
    final txBodyKeyAspectMap = {
      TransactionBody.inputsKey: const _TrackingAspect(RawTransactionAspect.inputs),
      TransactionBody.feeKey: const _TrackingAspect(RawTransactionAspect.fee),
      TransactionBody.auxiliaryDataHashKey: const _TrackingAspect(
        RawTransactionAspect.auxiliaryDataHash,
        dataSize: AuxiliaryDataHash.hashLength,
      ),
      TransactionBody.networkIdKey: const _TrackingAspect(RawTransactionAspect.networkId),
    };

    sink.addHeaderInfo(CborMajorType.map, cbor_internal_arg.Arg.int(txBodyMap.length));

    for (final entry in txBodyMap.entries) {
      entry.key.encode(sink);
      final tracking = txBodyKeyAspectMap[entry.key];
      if (tracking != null) {
        sink.beginAspect(tracking.aspect, dataSize: tracking.dataSize);
      }
      entry.value.encode(sink);
      if (tracking != null) {
        sink.endAspect(tracking.aspect);
      }
    }

    // 2. witnessSet
    final witnessSetMap = witnessSet.toCborValuesMap();
    sink
      ..beginAspect(RawTransactionAspect.witnessSet)
      ..addHeaderInfo(CborMajorType.map, cbor_internal_arg.Arg.int(witnessSetMap.length));

    for (final entry in witnessSetMap.entries) {
      entry.key.encode(sink);
      entry.value.encode(sink);
    }
    sink.endAspect(RawTransactionAspect.witnessSet);

    // 3. isValid
    CborBool(isValid).encode(sink);

    // 4. auxiliaryData
    sink.beginAspect(RawTransactionAspect.auxiliaryData);

    final auxiliaryDataMap = auxiliaryData.map;
    sink.addHeaderInfo(CborMajorType.map, cbor_internal_arg.Arg.int(auxiliaryDataMap.length));

    for (final axEntry in auxiliaryDataMap.entries) {
      final axKey = axEntry.key;
      final axValue = axEntry.value;

      axKey.encode(sink);

      // 4.1 envelope
      if (axKey == X509MetadataEnvelope.envelopeKey) {
        final envelope = axValue as CborMap;
        final envelopeAspectMap = {
          X509MetadataEnvelope.txInputsHashKey: const _TrackingAspect(
            RawTransactionAspect.txInputsHash,
            dataSize: TransactionInputsHash.hashLength,
          ),
          X509MetadataEnvelope.validationSignatureKey: const _TrackingAspect(
            RawTransactionAspect.signature,
            dataSize: Bip32Ed25519XSignature.length,
          ),
        };

        sink.addHeaderInfo(CborMajorType.map, cbor_internal_arg.Arg.int(envelope.length));

        for (final envelopeEntry in envelope.entries) {
          final envelopeKey = envelopeEntry.key;
          final envelopeValue = envelopeEntry.value;

          envelopeKey.encode(sink);
          final tracking = envelopeAspectMap[envelopeKey];
          if (tracking != null) {
            sink.beginAspect(tracking.aspect, dataSize: tracking.dataSize);
          }
          envelopeValue.encode(sink);
          if (tracking != null) {
            sink.endAspect(tracking.aspect);
          }
        }
      } else {
        axValue.encode(sink);
      }
    }

    sink.endAspect(RawTransactionAspect.auxiliaryData);

    final structuredBytes = StructuredBytes(buffer, context: sink.context);

    return RawTransaction(structuredBytes);
  }

  /// Returns auxiliary data bytes from [bytes].
  List<int> get auxiliaryData {
    final data = _structuredBytes.getValueOf(RawTransactionAspect.auxiliaryData);

    if (data == null) {
      throw StateError('AuxiliaryData not found!');
    }

    return data;
  }

  /// Returns auxiliary data hash bytes from [bytes].
  List<int> get auxiliaryDataHash {
    final data = _structuredBytes.getDataOf(RawTransactionAspect.auxiliaryDataHash);

    if (data == null) {
      throw StateError('AuxiliaryDataHash not found!');
    }

    return data;
  }

  @override
  List<int> get bytes => _structuredBytes.bytes;

  /// See [StructuredBytes].
  @visibleForTesting
  Map<RawTransactionAspect, CborValueByteRange> get context => _structuredBytes.context;

  @override
  Coin get fee {
    final value = _structuredBytes.getValueOf(RawTransactionAspect.fee);

    if (value == null) {
      throw StateError('Fee not found!');
    }

    final cborValue = cbor.decode(value) as CborSmallInt;

    return Coin(cborValue.value);
  }

  /// Returns inputs bytes from [bytes].
  List<int> get inputs {
    final value = _structuredBytes.getValueOf(RawTransactionAspect.inputs);

    if (value == null) {
      throw StateError('Inputs not found!');
    }

    return value;
  }

  @override
  NetworkId? get networkId {
    final value = _structuredBytes.getValueOf(RawTransactionAspect.networkId);
    if (value == null) {
      return null;
    }
    final decoded = cbor.decode(value);
    if (decoded is! CborSmallInt) {
      return null;
    }

    return NetworkId.fromId(decoded.value);
  }

  @override
  List<Object?> get props => [bytes, _structuredBytes.context];

  /// Returns auxiliary data signature bytes from [bytes].
  List<int> get signature {
    final data = _structuredBytes.getDataOf(RawTransactionAspect.signature);

    if (data == null) {
      throw StateError('Signature not found!');
    }

    return data;
  }

  /// Returns [inputs] hash bytes from [bytes].
  List<int> get txInputsHash {
    final data = _structuredBytes.getDataOf(RawTransactionAspect.txInputsHash);

    if (data == null) {
      throw StateError('TxInputsHash not found!');
    }

    return data;
  }

  /// Patching [bytes]'s [auxiliaryDataHash] with given [data].
  void patchAuxiliaryDataHash(List<int> data) {
    _structuredBytes.patchData(RawTransactionAspect.auxiliaryDataHash, data);
  }

  /// Patching [bytes]'s [signature] with given [data].
  void patchSignature(List<int> data) {
    _structuredBytes.patchData(RawTransactionAspect.signature, data);
  }

  /// Patching [bytes]'s [txInputsHash] with given [data].
  void patchTxInputsHash(List<int> data) {
    _structuredBytes.patchData(RawTransactionAspect.txInputsHash, data);
  }

  /// Validates internal bytes against expected cbor format.
  ///
  /// Throw [RawTransactionMalformed] if invalid.
  void validate({bool allowPaddings = false}) {
    final invalidationReasons = <String>[];

    try {
      final asCbor = cbor.decode(bytes);
      if (asCbor is! CborList) {
        invalidationReasons.add('Top level object is not a list');
      }
      asCbor as CborList;

      if (asCbor.length != 4) {
        invalidationReasons.add('Top level list length is not 4');
      }

      final txBody = asCbor[0];
      if (txBody is! CborMap) {
        invalidationReasons.add('txBody is not a map');
      }
      if (txBody is CborMap) {
        final missingTxBodyKeys = [
          TransactionBody.inputsKey,
          TransactionBody.feeKey,
          TransactionBody.auxiliaryDataHashKey,
          TransactionBody.ttlKey,
          TransactionBody.networkIdKey,
        ].where((key) => !txBody.keys.contains(key));
        if (missingTxBodyKeys.isNotEmpty) {
          invalidationReasons.add('txBody is missing ${missingTxBodyKeys.join(',')}');
        }

        final fee = txBody[TransactionBody.feeKey];
        if (fee is! CborInt || fee.toInt() < 0) {
          invalidationReasons.add('fee is not CborInt or negative');
        }

        final ttl = txBody[TransactionBody.ttlKey];
        if (ttl is! CborInt || ttl.toInt() < 0) {
          invalidationReasons.add('ttl is not CborInt or negative');
        }

        final auxDataHash = txBody[TransactionBody.auxiliaryDataHashKey];
        if (auxDataHash is! CborBytes) {
          invalidationReasons.add('auxiliaryDataHash is not CborBytes');
        }
        if (auxDataHash is CborBytes && auxDataHash.bytes.length != AuxiliaryDataHash.hashLength) {
          invalidationReasons.add('auxiliaryDataHash invalid length(${auxDataHash.bytes.length})');
        }
        if (!allowPaddings &&
            auxDataHash is CborBytes &&
            auxDataHash.bytes.isNotEmpty &&
            auxDataHash.bytes.every((element) => element == 0)) {
          invalidationReasons.add('auxiliaryDataHash is zeroed');
        }
      }

      final auxiliaryData = asCbor[3];
      if (auxiliaryData is! CborMap) {
        invalidationReasons.add('auxiliaryData is not CborMap');
      }

      if (auxiliaryData is CborMap) {
        if (!auxiliaryData.keys.contains(X509MetadataEnvelope.envelopeKey)) {
          invalidationReasons.add('auxiliaryData is does not contain envelope key');
        }

        final envelope = auxiliaryData[X509MetadataEnvelope.envelopeKey];
        if (envelope is! CborMap) {
          invalidationReasons.add('envelope is not CborMap');
        }

        if (envelope is CborMap) {
          final missingEnvelopeKeys = [
            X509MetadataEnvelope.purposeKey,
            X509MetadataEnvelope.txInputsHashKey,
            X509MetadataEnvelope.validationSignatureKey,
          ].where((key) => !envelope.keys.contains(key));
          if (missingEnvelopeKeys.isNotEmpty) {
            invalidationReasons.add('envelope is missing ${missingEnvelopeKeys.join(',')}');
          }

          final keys = List.of(envelope.keys);
          final uniqueKeys = keys.toSet();
          if (keys.length != uniqueKeys.length) {
            final duplicatedKeys = List.of(keys)..removeWhere(uniqueKeys.contains);
            invalidationReasons.add('envelope has duplicated keys - ${duplicatedKeys.join(',')}');
          }

          final purpose = envelope[X509MetadataEnvelope.purposeKey];
          if (purpose is! CborBytes || purpose.bytes.length != 16) {
            invalidationReasons.add('purpose is not a CborBytes');
          }
          if (purpose is CborBytes && purpose.bytes.length != 16) {
            invalidationReasons.add('purpose invalid length');
          }

          final txInputsHash = envelope[X509MetadataEnvelope.txInputsHashKey];
          if (txInputsHash is! CborBytes) {
            invalidationReasons.add('txInputsHash is not a CborBytes');
          }
          if (txInputsHash is CborBytes &&
              txInputsHash.bytes.length != TransactionInputsHash.hashLength) {
            invalidationReasons.add('txInputsHash invalid length');
          }
          if (!allowPaddings &&
              txInputsHash is CborBytes &&
              txInputsHash.bytes.isNotEmpty &&
              txInputsHash.bytes.every((element) => element == 0)) {
            invalidationReasons.add('auxiliaryDataHash is zeroed');
          }

          final signature = envelope[X509MetadataEnvelope.validationSignatureKey];
          if (signature is! CborBytes) {
            invalidationReasons.add('signature is not a CborBytes');
          }
          if (signature is CborBytes && signature.bytes.length != Bip32Ed25519XSignature.length) {
            invalidationReasons.add('signature length is invalid');
          }
          if (!allowPaddings &&
              signature is CborBytes &&
              signature.bytes.isNotEmpty &&
              signature.bytes.every((element) => element == 0)) {
            invalidationReasons.add('signature is zeroed');
          }
        }
      }

      if (invalidationReasons.isNotEmpty) {
        throw RawTransactionMalformed(reasons: invalidationReasons);
      }
    } catch (e) {
      invalidationReasons.add(e.toString());

      throw RawTransactionMalformed(reasons: invalidationReasons);
    }
  }

  @override
  RawTransaction withWitnessSet(TransactionWitnessSet witnessSet) {
    final encoded = cbor.encode(witnessSet.toCbor());
    _structuredBytes.replaceValue(
      RawTransactionAspect.witnessSet,
      encoded,
    );
    return this;
  }
}

final class _TrackingAspect extends Equatable {
  final RawTransactionAspect aspect;
  final int? dataSize;

  const _TrackingAspect(this.aspect, {this.dataSize});

  @override
  List<Object?> get props => [aspect, dataSize];
}
