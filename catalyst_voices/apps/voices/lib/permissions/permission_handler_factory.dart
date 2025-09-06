import 'dart:async';
import 'dart:collection';

import 'package:catalyst_voices/permissions/android_permission_strategy.dart';
import 'package:catalyst_voices/permissions/default_permission_strategy.dart';
import 'package:catalyst_voices/permissions/ios_permission_strategy.dart';
import 'package:catalyst_voices/permissions/permission_request.dart';
import 'package:catalyst_voices/permissions/permission_strategy.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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

  final Set<Permission> _deniedPermissions = {};
  final Queue<PermissionRequest> _requestQueue = Queue<PermissionRequest>();
  bool _isProcessingQueue = false;

  PermissionStrategy? _cachedStrategy;

  PermissionHandlerImpl(this._deviceInfo);

  Future<PermissionStrategy> get _strategy async {
    return _cachedStrategy ??= await PermissionStrategyFactory.create(_deviceInfo);
  }

  @override
  Future<PermissionStatus> permissionStatus(Permission permission) async {
    final strategy = await _strategy;
    final actualPermission = strategy.getActualPermission(permission);
    return actualPermission.status;
  }

  @override
  Future<PermissionResult> requestPermission(Permission permission) async {
    final completer = Completer<PermissionResult>();

    _requestQueue.add(PermissionRequest(permission, completer));

    if (!_isProcessingQueue) {
      unawaited(_processQueue());
    }

    return completer.future;
  }

  Future<void> _processQueue() async {
    _isProcessingQueue = true;

    while (_requestQueue.isNotEmpty) {
      final request = _requestQueue.removeFirst();

      try {
        _cachedStrategy ??= await PermissionStrategyFactory.create(_deviceInfo);
        final result = await _cachedStrategy!.requestPermission(
          request.permission,
          _deniedPermissions,
        );
        request.completer.complete(result);
      } catch (error) {
        request.completer.completeError(error);
      }
    }

    _isProcessingQueue = false;
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
          : const AndroidLegacyPermissionStrategy();
    } else if (CatalystOperatingSystem.current.isIOS) {
      return const IOSPermissionStrategy();
    } else {
      return const DefaultPermissionStrategy();
    }
  }
}
