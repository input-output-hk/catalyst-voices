import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract final class CatalystIdFactory {
  CatalystIdFactory._();

  static CatalystId create({
    String? username,
    CatalystIdHost host = CatalystIdHost.cardanoPreprod,
    int role0KeySeed = 0,
  }) {
    final role0Key = Uint8List.fromList(List.filled(32, role0KeySeed));

    return CatalystId(
      host: host.host,
      role0Key: role0Key,
      username: username,
    );
  }
}
