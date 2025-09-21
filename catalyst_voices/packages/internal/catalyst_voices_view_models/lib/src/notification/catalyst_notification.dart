import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid_plus/uuid_plus.dart';

part 'banner_notification.dart';
part 'catalyst_notification_text.dart';
part 'snackbar_notification.dart';

sealed class CatalystNotification extends Equatable implements Comparable<CatalystNotification> {
  final String id;
  final int priority;
  final CatalystNotificationType type;

  const CatalystNotification({
    required this.id,
    this.priority = 0,
    this.type = CatalystNotificationType.info,
  });

  @override
  List<Object?> get props => [id, priority, type];

  @override
  int compareTo(CatalystNotification other) => priority.compareTo(other.priority);
}

enum CatalystNotificationType { warning, error, success, info }
