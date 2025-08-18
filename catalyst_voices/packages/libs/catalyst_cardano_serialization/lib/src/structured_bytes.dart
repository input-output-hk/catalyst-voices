import 'package:equatable/equatable.dart';

/// A helper class for [StructuredBytes] to keep track of important parts of bytes.
final class CborValueByteRange extends Equatable {
  /// Start of section. Inclusive.
  final int start;

  /// End of section, Exclusive.
  final int end;

  /// If given section size is known. Setting this fields enables
  /// operations on data only (without headers).
  ///
  /// Its required for patching.
  final int? dataSize;

  /// A default constructor for [CborValueByteRange].
  const CborValueByteRange({
    required this.start,
    required this.end,
    this.dataSize,
  });

  /// Start of data in this range.
  ///
  /// Returns null if [dataSize] is unknown otherwise calculates header and start of data itself.
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

  /// Makes a copy of [CborValueByteRange].
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

/// A class which helps getting specific parts of [bytes] and provides basic
/// functionality like patching parts of it.
///
/// This class is mutable. It keeps internal list of [_bytes] which is mutable and can
/// be modified via public methods but public [bytes] is not modifiable.
final class StructuredBytes<T> {
  /// Internal mutable list of bytes.
  final List<int> _bytes;

  /// Keeping track of important parts of [_bytes].
  final Map<T, CborValueByteRange> _context;

  /// Default constructor for [StructuredBytes].
  const StructuredBytes(
    List<int> bytes, {
    required Map<T, CborValueByteRange> context,
  }) : _bytes = bytes,
       _context = context;

  /// Returns bytes as unmodifiable list.
  List<int> get bytes => List.unmodifiable(_bytes);

  /// Returns context for [bytes].
  Map<T, CborValueByteRange> get context => Map.unmodifiable(_context);

  /// Returns matching data range (See [CborValueByteRange.dataStart]).
  ///
  /// If no context found for [key] or it does not have [CborValueByteRange.dataStart] returns null.
  List<int>? getDataOf(T key) {
    final range = context[key];
    if (range == null) return null;
    final dataStart = range.dataStart;
    if (dataStart == null) return null;

    return _bytes.sublist(dataStart, range.end);
  }

  /// Returns matching data range (See [CborValueByteRange.dataStart]).
  ///
  /// If no context found for [key]..
  List<int>? getValueOf(T key) {
    final range = context[key];
    if (range == null) return null;

    return _bytes.sublist(range.start, range.end);
  }

  /// Updates internal list of bytes associated with [key] with [data].
  ///
  /// Patching is supported only for [CborValueByteRange] with dataSize.
  ///
  /// It requires [key] to be present in [context] + size of [data] have to match
  /// recorded [CborValueByteRange.dataSize].
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

  /// Similar to [patchData] but allows to change range of bytes for [key] and .dataSize
  /// is not required here.
  void replaceValue(T key, Iterable<int> value) {
    final range = _context[key];
    if (range == null) {
      throw ArgumentError('$key not found in context', 'key');
    }

    final start = range.start;
    final end = range.end;
    final newEnd = start + value.length;

    final lengthDelta = value.length - (end - start);

    _bytes.replaceRange(start, end, value);
    _context[key] = range.copyWith(end: newEnd);

    if (lengthDelta != 0) {
      for (final entry in _context.entries) {
        // Skip the key we just updated
        if (entry.key == key) {
          continue;
        }

        if (entry.value.start >= end) {
          _context[entry.key] = entry.value.copyWith(
            start: entry.value.start + lengthDelta,
            end: entry.value.end + lengthDelta,
          );
        }
      }
    }
  }
}
