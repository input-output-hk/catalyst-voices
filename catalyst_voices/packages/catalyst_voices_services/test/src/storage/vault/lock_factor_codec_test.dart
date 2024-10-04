import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor_codec.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('encoding and decoding results in same lock factor', () {
    // Given
    const lock = PasswordLockFactor('pass1234');
    const LockFactorCodec codec = DefaultLockFactorCodec();

    // When
    final encoded = codec.encoder.convert(lock);
    final decoded = codec.decoder.convert(encoded);

    // Then
    expect(decoded, isA<PasswordLockFactor>());
    expect(decoded.unlocks(lock), isTrue);
  });
}
