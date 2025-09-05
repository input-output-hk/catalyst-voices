// ignore: one_member_abstracts
import 'package:catalyst_voices/permissions/permission_handler_factory.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:permission_handler/permission_handler.dart';

abstract base class BasePermissionStrategy implements PermissionStrategy {
  const BasePermissionStrategy();

  @override
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
          throw PermissionNeedsRationaleException(permission);
        }
        throw PermissionNeedsExplanationException(permission);
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        throw PermissionNeedsExplanationException(permission);
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
    return handlePermissionResult(
      status,
      actualPermission,
      deniedPermissions,
    );
  }
}

abstract interface class PermissionStrategy {
  const PermissionStrategy();

  Permission getActualPermission(Permission requestedPermission);

  Future<PermissionResult> requestPermission(
    Permission permission,
    Set<Permission> deniedPermissions,
  );
}
