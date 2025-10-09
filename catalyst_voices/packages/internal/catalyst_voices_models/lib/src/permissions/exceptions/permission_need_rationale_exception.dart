import 'package:permission_handler/permission_handler.dart';

class PermissionNeedsRationaleException implements Exception {
  final Permission permission;

  const PermissionNeedsRationaleException(this.permission);

  @override
  String toString() => 'PermissionNeedsRationaleException: $permission';
}
