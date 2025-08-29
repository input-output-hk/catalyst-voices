// Concrete Strategy - Desktop/Web (no permissions needed)
import 'package:catalyst_voices_models/src/permissions/permission_handler_factory.dart';
import 'package:catalyst_voices_models/src/permissions/permission_strategy.dart';
import 'package:permission_handler/permission_handler.dart' show Permission;

final class DefaultPermissionStrategy implements PermissionStrategy {
  @override
  Future<PermissionResult> requestPermission(
    Permission permission,
    Set<Permission> deniedPermissions,
  ) async => PermissionResult.granted;
}
