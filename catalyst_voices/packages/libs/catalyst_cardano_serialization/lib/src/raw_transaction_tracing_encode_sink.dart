//ignore_for_file: implementation_imports,invalid_use_of_internal_member

import 'package:catalyst_cardano_serialization/src/raw_transaction.dart';
import 'package:catalyst_cardano_serialization/src/raw_transaction_aspect.dart';
import 'package:catalyst_cardano_serialization/src/structured_bytes.dart';
import 'package:cbor/src/encoder/sink.dart' as cbor_internal_sink;
import 'package:equatable/equatable.dart';

/// Internal class for tracking encoding of [RawTransaction].
class RawTransactionTracingEncodeSink extends cbor_internal_sink.EncodeSink {
  final cbor_internal_sink.EncodeSink _inner;
  final _context = <RawTransactionAspect, CborValueByteRange>{};
  final _recordingAspect = <RawTransactionAspect, _TrackingSinkRecord>{};

  int _cursor;

  /// Default constructor for [RawTransactionTracingEncodeSink].
  RawTransactionTracingEncodeSink(
    this._inner,
    this._cursor,
  );

  /// Returns current context of this sink.
  Map<RawTransactionAspect, CborValueByteRange> get context => Map.of(_context);

  @override
  void add(List<int> data) {
    _inner.add(data);
    _cursor += data.length;
  }

  /// Begins start recording of [aspect]. If [dataSize] is not null it will enable
  /// patching later.
  void beginAspect(RawTransactionAspect aspect, {int? dataSize}) {
    _recordingAspect[aspect] = _TrackingSinkRecord(start: _cursor, dataSize: dataSize);
  }

  @override
  void close() => _inner.close();

  /// Stop recoding [aspect] and stores its range in [context];
  void endAspect(RawTransactionAspect aspect) {
    final record = _recordingAspect.remove(aspect);
    assert(record != null, 'Record not found for $aspect');

    final start = record!.start;
    final end = _cursor;
    final dataSize = record.dataSize;

    _context[aspect] = CborValueByteRange(start: start, end: end, dataSize: dataSize);
  }
}

final class _TrackingSinkRecord extends Equatable {
  final int start;
  final int? dataSize;

  const _TrackingSinkRecord({
    required this.start,
    this.dataSize,
  });

  @override
  List<Object?> get props => [start, dataSize];
}
