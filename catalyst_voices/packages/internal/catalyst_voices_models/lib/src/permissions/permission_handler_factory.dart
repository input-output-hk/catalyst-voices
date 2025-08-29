import 'package:catalyst_voices_models/src/permissions/android_permission_strategy.dart';
import 'package:catalyst_voices_models/src/permissions/default_permission_strategy.dart';
import 'package:catalyst_voices_models/src/permissions/ios_permission_strategy.dart';
import 'package:catalyst_voices_models/src/permissions/permission_strategy.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

abstract interface class PermissionHandler {
  factory PermissionHandler(
    DeviceInfoPlugin deviceInfo,
  ) = PermissionHandlerImpl;

  // Note. For notification return type should be [PermissionResult]
  Future<bool> get waitForStoragePermission async =>
      (await requestPermission(Permission.storage)).isGranted;

  Future<PermissionResult> requestPermission(Permission permission);
}

final class PermissionHandlerImpl implements PermissionHandler {
  final DeviceInfoPlugin _deviceInfo;
  PermissionStrategy? _cachedStrategy;
  final Set<Permission> _deniedPermissions = {};

  PermissionHandlerImpl(this._deviceInfo);

  @override
  Future<bool> get waitForStoragePermission async =>
      (await requestPermission(Permission.storage)).isGranted;

  @override
  Future<PermissionResult> requestPermission(Permission permission) async {
    _cachedStrategy ??= await PermissionStrategyFactory.create(_deviceInfo);
    return _cachedStrategy!.requestPermission(permission, _deniedPermissions);
  }
}

enum PermissionResult {
  granted,
  denied,
  provisional;

  // For permissions where provisional is acceptable (like notifications)
  bool get isAccepted => isGranted || isProvisional;
  bool get isDenied => this == PermissionResult.denied;
  bool get isGranted => this == PermissionResult.granted;
  bool get isProvisional => this == PermissionResult.provisional;
}

final class PermissionStrategyFactory {
  static const int _safPermissionSDK = 33;

  static Future<PermissionStrategy> create(DeviceInfoPlugin deviceInfo) async {
    // TODO(LynxLynxx): change to CatalystPlatform

    if (CatalystOperatingSystem.current.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= _safPermissionSDK
          ? AndroidModernPermissionStrategy()
          : AndroidLegacyPermissionStrategy();
    } else if (CatalystOperatingSystem.current.isIOS) {
      return IOSPermissionStrategy();
    } else {
      return DefaultPermissionStrategy();
    }
  }
}
