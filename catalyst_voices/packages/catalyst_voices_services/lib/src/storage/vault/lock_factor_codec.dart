import 'dart:convert';

import 'package:catalyst_voices_services/src/storage/vault/lock_factor.dart';

abstract class LockFactorCodec extends Codec<LockFactor, String> {
  const LockFactorCodec();
}

/// Uses [LockFactor.toJson] and [LockFactor.fromJson] to serialize to
/// [String] using [json].
class DefaultLockFactorCodec extends LockFactorCodec {
  const DefaultLockFactorCodec();

  @override
  Converter<String, LockFactor> get decoder => const _LockFactorDecoder();

  @override
  Converter<LockFactor, String> get encoder => const _LockFactorEncoder();
}

class _LockFactorDecoder extends Converter<String, LockFactor> {
  const _LockFactorDecoder();

  @override
  LockFactor convert(String input) {
    final json = jsonDecode(input) as Map<String, dynamic>;

    return LockFactor.fromJson(json);
  }
}

class _LockFactorEncoder extends Converter<LockFactor, String> {
  const _LockFactorEncoder();

  @override
  String convert(LockFactor input) {
    final json = input.toJson();

    return jsonEncode(json);
  }
}
