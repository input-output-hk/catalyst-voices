import 'package:catalyst_voices/permissions/permission_handler_factory.dart';
import 'package:catalyst_voices/permissions/permission_strategy.dart';
import 'package:permission_handler/permission_handler.dart';

// Concrete Strategy - Desktop/Web (no permissions needed)
final class DefaultPermissionStrategy implements PermissionStrategy {
  const DefaultPermissionStrategy();

  @override
  Permission getActualPermission(Permission requestedPermission) => requestedPermission;

  @override
  Future<PermissionResult> requestPermission(
    Permission permission,
    Set<Permission> deniedPermissions,
  ) async => PermissionResult.granted;
}
