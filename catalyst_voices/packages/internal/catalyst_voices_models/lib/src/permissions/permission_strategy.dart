// ignore: one_member_abstracts
import 'package:catalyst_voices_models/src/permissions/permission_handler_factory.dart';
import 'package:permission_handler/permission_handler.dart';

abstract base class BasePermissionStrategy implements PermissionStrategy {
  Permission getActualPermission(Permission requestedPermission) => requestedPermission;

  // Common permission handling logic
  Future<PermissionResult> handlePermissionResult(
    PermissionStatus status,
    Permission permission,
    Set<Permission> deniedPermissions,
  ) async {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        deniedPermissions.remove(permission);
        return PermissionResult.granted;
      case PermissionStatus.denied:
        if (!deniedPermissions.contains(permission)) {
          deniedPermissions.add(permission);
          return PermissionResult.denied;
        }
        // Second+ denial - redirect to settings
        await openAppSettings();
        final newStatus = await permission.status;
        if (newStatus.isGranted || newStatus == PermissionStatus.limited) {
          deniedPermissions.remove(permission);
          return PermissionResult.granted;
        }
        return PermissionResult.denied;
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        await openAppSettings();
        final newStatus = await permission.status;
        if (newStatus.isGranted || newStatus == PermissionStatus.limited) {
          deniedPermissions.remove(permission);
          return PermissionResult.granted;
        }
        return PermissionResult.denied;
      case PermissionStatus.provisional:
        deniedPermissions.remove(permission);
        return PermissionResult.provisional;
    }
  }

  @override
  Future<PermissionResult> requestPermission(
    Permission permission,
    Set<Permission> deniedPermissions,
  ) async {
    final actualPermission = getActualPermission(permission);
    final status = await actualPermission.request();
    return handlePermissionResult(status, actualPermission, deniedPermissions);
  }
}

// ignore: one_member_abstracts
abstract interface class PermissionStrategy {
  Future<PermissionResult> requestPermission(
    Permission permission,
    Set<Permission> deniedPermissions,
  );
}
