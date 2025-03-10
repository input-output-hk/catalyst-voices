import 'dart:typed_data';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class Bip32Ed25519XCatalystSignature extends Equatable
    implements CatalystSignature {
  final Bip32Ed25519XSignature _signature;

  const Bip32Ed25519XCatalystSignature(this._signature);

  @override
  Uint8List get bytes => Uint8List.fromList(_signature.bytes);

  @override
  List<Object?> get props => [_signature];
}
