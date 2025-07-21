import 'package:equatable/equatable.dart';

///
final class CborValueByteRange extends Equatable {
  ///
  final int start;

  ///
  final int end;

  ///
  final int? dataSize;

  ///
  const CborValueByteRange({
    required this.start,
    required this.end,
    this.dataSize,
  });

  ///
  int? get dataStart {
    final dataSize = this.dataSize;
    if (dataSize == null) {
      return null;
    }

    final header = end - start - dataSize;

    return start + header;
  }

  @override
  List<Object?> get props => [start, end, dataSize];

  ///
  CborValueByteRange copyWith({
    int? start,
    int? end,
    int? dataSize,
  }) {
    return CborValueByteRange(
      start: start ?? this.start,
      end: end ?? this.end,
      dataSize: dataSize ?? this.dataSize,
    );
  }
}

///
final class StructuredBytes<T> {
  ///
  final List<int> _bytes;

  ///
  final Map<T, CborValueByteRange> _context;

  ///
  const StructuredBytes(
    List<int> bytes, {
    required Map<T, CborValueByteRange> context,
  })  : _bytes = bytes,
        _context = context;

  ///
  List<int> get bytes => List.unmodifiable(_bytes);

  ///
  Map<T, CborValueByteRange> get context => Map.unmodifiable(_context);

  ///
  void patchData(T key, Iterable<int> data) {
    final range = _context[key];
    if (range == null) {
      throw ArgumentError('$key not found in context', 'key');
    }
    final start = range.dataStart;
    if (start == null) {
      throw ArgumentError('Cannot patch $key because data start is unknown');
    }
    if (range.dataSize! != data.length) {
      throw ArgumentError('Cannot patch $key because data size is different');
    }

    final end = range.end;

    _bytes.setRange(start, end, data);
  }

  ///
  void replaceValue(T key, Iterable<int> value) {
    final range = _context[key];
    if (range == null) {
      throw ArgumentError('$key not found in context', 'key');
    }

    final start = range.start;
    final end = range.end;
    final newEnd = start + value.length;

    _bytes.replaceRange(start, end, value);
    _context[key] = range.copyWith(end: newEnd);
  }
}
