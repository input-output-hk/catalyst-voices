import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BuildModeText extends StatelessWidget {
  const BuildModeText({super.key});

  @override
  Widget build(BuildContext context) {
    final buffer = StringBuffer();

    final mode = switch (true) {
      _ when kReleaseMode => 'Release',
      _ when kProfileMode => 'Profile',
      _ => 'Debug',
    };

    buffer
      ..write(mode)
      ..write(', Web[$kIsWeb]')
      ..write(', Wasm[$kIsWasm]');

    return Text(buffer.toString());
  }
}
