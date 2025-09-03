import 'package:catalyst_voices/permissions/permission_strategy.dart';

// Concrete Strategy - iOS
final class IOSPermissionStrategy extends BasePermissionStrategy {
  const IOSPermissionStrategy();
  // iOS uses permissions as-is, no mapping needed
}
