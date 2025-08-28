import 'package:catalyst_voices_shared/src/platform/form_factor/form_factor.dart';
import 'package:catalyst_voices_shared/src/platform/operating_system/operating_system.dart';
import 'package:flutter/foundation.dart';

/// A set of utils related to host target platform,
/// the ones that don't fit into [CatalystOperatingSystem] or [CatalystFormFactor].
final class CatalystPlatform {
  static bool get isWeb => kIsWeb;
}
