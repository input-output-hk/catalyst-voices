import 'package:catalyst_voices_shared/src/platform/catalyst_platform.dart';
import 'package:catalyst_voices_shared/src/platform/platform_key.dart';
import 'package:flutter/widgets.dart';

// A [PlatformAwareBuilder] is a StatelessWidget that is aware of the current
// platform.
//
// This is an abstract widget that has a required argument [builder] that can
// consume platform-specific data automatically based on platform that is
// detected.
//
// The platform detection happens in [CatalystPlatform].
//
// The widget accepts an argument for each specific platform defined in
// [PlatformKey]. The platform specific [data] is selected when two conditions
// are verified at the same time:
// - the platform is detected
// - the platform-specific argument is present
// In case those conditions are not verified the [other] argument is used (and
// because of this it is required).
// The type of the platform specific data is generic.
//
// A simple usage is to render a string based on the platform:
//
// ```dart
// PlatformWidgetBuilder<String>(
//   android: 'This is an Android platform.',
//   other: 'This is an other platform.',
//   builder: (context, title) => Text(title!),
// );
// ```
//
// or to have a specific Padding:
//
// ```dart
// PlatformWidgetBuilder<EdgeInsetsGeometry>(
//   android: EdgeInsets.all(10.0),
//   other: EdgeInsets.all(40.0),
//   builder: (context, padding) => Padding(
//     padding: padding,
//     child: Text('This is an example.')
//   ),
// );
// ```

class PlatformAwareBuilder<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T? data) builder;
  final Map<PlatformKey, T?> _platformData;

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
    T? web,
    T? webDesktop,
    T? windows,
    required T other,
  }) : _platformData = {
          PlatformKey.android: android,
          PlatformKey.desktop: desktop,
          PlatformKey.fuchsia: fuchsia,
          PlatformKey.iOS: iOS,
          PlatformKey.linux: linux,
          PlatformKey.macOS: macOS,
          PlatformKey.mobile: mobile,
          PlatformKey.mobileWeb: mobileWeb,
          PlatformKey.web: web,
          PlatformKey.webDesktop: webDesktop,
          PlatformKey.windows: windows,
          PlatformKey.other: other,
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
          orElse: () => const MapEntry(PlatformKey.other, true),
        )
        .key;
    return _platformData[currentPlatformKey]!;
  }
}
