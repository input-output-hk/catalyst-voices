import 'package:catalyst_voices_shared/src/platform/operating_system/operating_system.dart';
import 'package:flutter/material.dart';

/// A builder which allows to build different widgets per [CatalystOperatingSystem.current].
class OperatingSystemBuilder<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T? data) builder;
  final Map<CatalystOperatingSystem, T?> _data;
  final T? fallback;

  OperatingSystemBuilder({
    super.key,
    required this.builder,
    T? android,
    T? fuchsia,
    T? iOS,
    T? linux,
    T? macOS,
    T? windows,
    required this.fallback,
  }) : _data = {
         CatalystOperatingSystem.android: android,
         CatalystOperatingSystem.fuchsia: fuchsia,
         CatalystOperatingSystem.iOS: iOS,
         CatalystOperatingSystem.linux: linux,
         CatalystOperatingSystem.macOS: macOS,
         CatalystOperatingSystem.windows: windows,
       };

  @override
  Widget build(BuildContext context) {
    return builder(context, _getData());
  }

  T? _getData() {
    return _data[CatalystOperatingSystem.current] ?? fallback;
  }
}
