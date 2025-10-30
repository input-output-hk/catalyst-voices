import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'banner_notification.dart';
part 'catalyst_notification_text.dart';
part 'dialog_notification.dart';

bool _alwaysAllowRouterPredicate(GoRouterState state) => true;

typedef CatalystNotificationRouterPredicate = bool Function(GoRouterState state);

sealed class CatalystNotification extends Equatable implements Comparable<CatalystNotification> {
  final String id;
  final int priority;
  final CatalystNotificationType type;
  final CatalystNotificationRouterPredicate routerPredicate;

  const CatalystNotification({
    required this.id,
    this.priority = 0,
    this.type = CatalystNotificationType.info,
    this.routerPredicate = _alwaysAllowRouterPredicate,
  });

  @override
  List<Object> get props => [id, priority, type];

  @override
  int compareTo(CatalystNotification other) => priority.compareTo(other.priority);

  @override
  String toString() {
    return 'CatalystNotification(id[$id], priority[$priority], type[$type])';
  }
}

enum CatalystNotificationType {
  warning,
  error,
  success,
  info;

  SvgGenImage get icon {
    return switch (this) {
      CatalystNotificationType.warning => VoicesAssets.icons.exclamation,
      CatalystNotificationType.error => VoicesAssets.icons.exclamationCircle,
      CatalystNotificationType.success => VoicesAssets.icons.checkCircle,
      CatalystNotificationType.info => VoicesAssets.icons.informationCircle,
    };
  }

  Color backgroundColor(BuildContext context) {
    return switch (this) {
      CatalystNotificationType.warning => Theme.of(context).colors.warningContainer,
      CatalystNotificationType.error => Theme.of(context).colors.errorContainer,
      CatalystNotificationType.success => Theme.of(context).colors.successContainer,
      CatalystNotificationType.info => Theme.of(context).colors.primaryContainer,
    };
  }

  Color foregroundColor(BuildContext context) {
    return switch (this) {
      CatalystNotificationType.warning => Theme.of(context).colors.onWarningContainer,
      CatalystNotificationType.error => Theme.of(context).colors.onErrorContainer,
      CatalystNotificationType.success => Theme.of(context).colors.onSuccessContainer,
      CatalystNotificationType.info => Theme.of(context).colors.textOnPrimaryLevel0,
    };
  }
}
