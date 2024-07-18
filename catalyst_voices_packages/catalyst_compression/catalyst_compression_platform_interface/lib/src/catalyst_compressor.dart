/// The interface of a compression algorithm that allows to compress/decompress bytes.
abstract class CatalystCompressor {
  /// Returns the list of compressed [bytes].
  ///
  /// In some conditions the resulting bytes might be bigger
  /// than original bytes depending on the used algorithm.
  ///
  /// Compressing and then decompressing the [bytes]
  /// should yield the original [bytes].
  List<int> compress(List<int> bytes);

  /// Returns the list of decompressed [bytes].
  ///
  /// Compressing and then decompressing the [bytes]
  /// should yield the original [bytes].
  List<int> decompress(List<int> bytes);
}
