import 'package:catalyst_voices_models/src/permissions/android_permission_strategy.dart';
import 'package:catalyst_voices_models/src/permissions/default_permission_strategy.dart';
import 'package:catalyst_voices_models/src/permissions/exceptions/permission_need_explanation_exception.dart'
    show PermissionNeedsExplanationException;
import 'package:catalyst_voices_models/src/permissions/exceptions/permission_need_rationale_exception.dart'
    show PermissionNeedsRationaleException;
import 'package:catalyst_voices_models/src/permissions/ios_permission_strategy.dart';
import 'package:catalyst_voices_models/src/permissions/permission_strategy.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

abstract interface class PermissionHandler {
  factory PermissionHandler(
    DeviceInfoPlugin deviceInfo,
  ) = PermissionHandlerImpl;

  /// Does not request permission, just checks its status
  Future<PermissionStatus> permissionStatus(Permission permission);

  /// Throws [PermissionNeedsRationaleException], [PermissionNeedsExplanationException] when needed etc.
  Future<PermissionResult> requestPermission(Permission permission);
}

final class PermissionHandlerImpl implements PermissionHandler {
  final DeviceInfoPlugin _deviceInfo;
  PermissionStrategy? _cachedStrategy;
  final Set<Permission> _deniedPermissions = {};

  PermissionHandlerImpl(this._deviceInfo);

  @override
  Future<PermissionStatus> permissionStatus(Permission permission) async {
    _cachedStrategy ??= await PermissionStrategyFactory.create(_deviceInfo);
    final actualPermission = _cachedStrategy!.getActualPermission(permission);
    return actualPermission.status;
  }

  @override
  Future<PermissionResult> requestPermission(Permission permission) async {
    _cachedStrategy ??= await PermissionStrategyFactory.create(_deviceInfo);
    return _cachedStrategy!.requestPermission(
      permission,
      _deniedPermissions,
    );
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
