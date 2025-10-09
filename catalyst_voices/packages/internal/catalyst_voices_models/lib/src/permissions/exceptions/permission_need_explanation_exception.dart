import 'package:permission_handler/permission_handler.dart';

class PermissionNeedsExplanationException implements Exception {
  final Permission permission;

  const PermissionNeedsExplanationException(this.permission);

  @override
  String toString() => 'PermissionNeedsExplanationException: $permission';
}
