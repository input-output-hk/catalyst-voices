import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';

class CatalystRuntimeProfiler extends CatalystBaseProfiler {
  CatalystRuntimeProfiler(super.delegate);

  Future<T> brotliCompress<T>({
    String? name,
    required AsyncValueGetter<T> body,
  }) async {
    assert(ongoing, 'Runtime profiler already finished');

    final taskName = name != null ? 'brotli_compress_$name' : 'brotli_compress';
    return timeline!.timeWithResult(taskName, body);
  }

  Future<T> brotliDecompress<T>({
    String? name,
    required AsyncValueGetter<T> body,
  }) async {
    assert(ongoing, 'Runtime profiler already finished');

    final taskName = name != null ? 'brotli_decompress_$name' : 'brotli_decompress';
    return timeline!.timeWithResult(taskName, body);
  }

  Future<T> cborDecode<T>({
    String? name,
    required AsyncValueGetter<T> body,
  }) async {
    assert(ongoing, 'Runtime profiler already finished');

    final taskName = name != null ? 'cbor_decode_$name' : 'cbor_decode';
    return timeline!.timeWithResult(taskName, body);
  }

  Future<T> coseParse<T>({
    String? name,
    required AsyncValueGetter<T> body,
  }) async {
    assert(ongoing, 'Runtime profiler already finished');

    final taskName = name != null ? 'cose_parse_$name' : 'cose_parse';
    return timeline!.timeWithResult(taskName, body);
  }

  Future<T> coseSign<T>({
    String? name,
    required AsyncValueGetter<T> body,
  }) async {
    assert(ongoing, 'Runtime profiler already finished');

    final taskName = name != null ? 'cose_sign_$name' : 'cose_sign';
    return timeline!.timeWithResult(taskName, body);
  }

  @override
  void start({
    required DateTime at,
  }) {
    assert(!ongoing, 'Runtime profiler already initialized');

    timeline = delegate.startTransaction(
      'Runtime',
      arguments: CatalystProfilerTimelineArguments(
        operation: 'runtime_operations',
        description: 'Measuring performance of runtime operations throughout app lifecycle',
        startTimestamp: at,
      ),
    );
  }
}
