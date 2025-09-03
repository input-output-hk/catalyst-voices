import 'package:catalyst_voices/permissions/permission_strategy.dart';
import 'package:permission_handler/permission_handler.dart';

// Concrete Strategy - Android Legacy (API < 33)
final class AndroidLegacyPermissionStrategy extends BasePermissionStrategy {
  const AndroidLegacyPermissionStrategy();

  @override
  Permission getActualPermission(Permission requestedPermission) {
    switch (requestedPermission) {
      case Permission.photos:
      case Permission.manageExternalStorage:
        return Permission.storage;
      default:
        return requestedPermission;
    }
  }
}

// Concrete Strategy - Android Modern (API 33+)
final class AndroidModernPermissionStrategy extends BasePermissionStrategy {
  @override
  Permission getActualPermission(Permission requestedPermission) {
    switch (requestedPermission) {
      case Permission.storage:
        return Permission.manageExternalStorage; // Modern uses manage external storage
      default:
        return requestedPermission;
    }
  }
}
