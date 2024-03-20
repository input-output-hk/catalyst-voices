import 'dart:developer';
import 'dart:io';

import 'package:catalyst_voices_shared/src/platform/catalyst_platform.dart';
import 'package:flutter/widgets.dart';

class PlatformAwareBuilder<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T? data) builder;
  final Map<String, T?> _platformData;

  PlatformAwareBuilder({
    super.key,
    required this.builder,
    T? android,
    T? desktop,
    T? fuchsia,
    T? iOS,
    T? linux,
    T? macOS,
    T? mobile,
    T? mobileWeb,
    T? isWeb,
    T? webDesktop,
    T? windows,
    required T other,
  }) : _platformData = {
    'android': android,
    'desktop': desktop,
    'fuchsia': fuchsia,
    'iOS': iOS,
    'linux': linux,
    'macOS': macOS,
    'mobile': mobile,
    'mobileWeb': mobileWeb,
    'web': isWeb,
    'webDesktop': webDesktop,
    'windows': windows,
    'other': other,
  };

  @override
  Widget build(BuildContext context) {
    return builder(context, _getPlatformData());
  }

  T _getPlatformData() {
    final currentPlatformKey = CatalystPlatform.identifiers.entries
      .firstWhere(
        // We select the platform only if the platform-specific data
        // is also present.
        (entry) => entry.value && (_platformData[entry.key] != null),
        orElse: () => const MapEntry('other', true),
      )
      .key;
    return _platformData[currentPlatformKey]!;
  }
}
