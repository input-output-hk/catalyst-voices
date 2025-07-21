//ignore_for_file: implementation_imports,invalid_use_of_internal_member

import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/raw_transaction_aspect.dart';
import 'package:catalyst_cardano_serialization/src/raw_transaction_tracing_encode_sink.dart';
import 'package:catalyst_cardano_serialization/src/rbac/x509_metadata_envelope.dart';
import 'package:catalyst_cardano_serialization/src/structured_bytes.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/witness.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:cbor/cbor.dart';
import 'package:cbor/src/encoder/sink.dart' as cbor_internal_sink;
import 'package:cbor/src/utils/arg.dart' as cbor_internal_arg;
import 'package:equatable/equatable.dart';
import 'package:typed_data/typed_buffers.dart';

/// Version of [BaseTransaction] which works on bytes and patching
/// of different parts.
///
/// It enables single encode transaction build.
final class RawTransaction extends BaseTransaction {
  final StructuredBytes<RawTransactionAspect> _structuredBytes;

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
          X509MetadataEnvelope.validationSignatureKey: _TrackingAspect(
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

    return RawTransaction._(structuredBytes);
  }

  /// Internal constructor for [RawTransaction].
  const RawTransaction._(this._structuredBytes);

  /// Returns auxiliary data bytes from [bytes].
  List<int> get auxiliaryData {
    final range = _structuredBytes.context[RawTransactionAspect.auxiliaryData]!;

    return _structuredBytes.bytes.sublist(range.start, range.end);
  }

  /// Returns auxiliary data hash bytes from [bytes].
  List<int> get auxiliaryDataHash {
    final range = _structuredBytes.context[RawTransactionAspect.auxiliaryDataHash]!;

    return _structuredBytes.bytes.sublist(range.dataStart!, range.end);
  }

  @override
  List<int> get bytes => _structuredBytes.bytes;

  @override
  Coin get fee {
    final range = _structuredBytes.context[RawTransactionAspect.fee];
    if (range == null) {
      throw StateError('Fee not found!');
    }
    final bytes = _structuredBytes.bytes.sublist(range.start, range.end);
    final value = (cbor.decode(bytes) as CborSmallInt).value;

    return Coin(value);
  }

  /// Returns inputs bytes from [bytes].
  List<int> get inputs {
    final range = _structuredBytes.context[RawTransactionAspect.inputs]!;

    return _structuredBytes.bytes.sublist(range.start, range.end);
  }

  @override
  NetworkId? get networkId {
    final range = _structuredBytes.context[RawTransactionAspect.networkId];
    if (range == null) {
      return null;
    }
    final bytes = _structuredBytes.bytes.sublist(range.start, range.end);
    final decoded = cbor.decode(bytes);
    if (decoded is! CborSmallInt) {
      return null;
    }

    return NetworkId.fromId(decoded.value);
  }

  @override
  List<Object?> get props => [bytes, _structuredBytes.context];

  /// Returns auxiliary data signature bytes from [bytes].
  List<int> get signature {
    final range = _structuredBytes.context[RawTransactionAspect.signature]!;

    return _structuredBytes.bytes.sublist(range.dataStart!, range.end);
  }

  /// Returns [inputs] hash bytes from [bytes].
  List<int> get txInputsHash {
    final range = _structuredBytes.context[RawTransactionAspect.txInputsHash]!;

    return _structuredBytes.bytes.sublist(range.dataStart!, range.end);
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
