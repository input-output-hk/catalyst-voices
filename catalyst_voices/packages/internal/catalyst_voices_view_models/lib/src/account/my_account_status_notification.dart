import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum MyAccountStatusNotificationType {
  offstage,
  warning,
  error,
  success;

  Color backgroundColor(BuildContext context) {
    return switch (this) {
      MyAccountStatusNotificationType.offstage => Colors.transparent,
      MyAccountStatusNotificationType.warning =>
        Theme.of(context).colors.warningContainer,
      MyAccountStatusNotificationType.error =>
        Theme.of(context).colors.errorContainer,
      MyAccountStatusNotificationType.success =>
        Theme.of(context).colors.successContainer,
    };
  }

  Color foregroundColor(BuildContext context) {
    return switch (this) {
      MyAccountStatusNotificationType.offstage => Colors.transparent,
      MyAccountStatusNotificationType.warning =>
        Theme.of(context).colors.onWarningContainer,
      MyAccountStatusNotificationType.error =>
        Theme.of(context).colors.onErrorContainer,
      MyAccountStatusNotificationType.success =>
        Theme.of(context).colors.onSuccessContainer,
    };
  }
}

sealed class MyAccountStatusNotification extends Equatable {
  final MyAccountStatusNotificationType type;

  const MyAccountStatusNotification({
    required this.type,
  });

  SvgGenImage get icon;

  String title(BuildContext context);

  String titleDesc(BuildContext context);

  String message(BuildContext context);

  @override
  @mustCallSuper
  List<Object?> get props => [type];
}

final class None extends MyAccountStatusNotification {
  const None()
      : super(
          type: MyAccountStatusNotificationType.offstage,
        );

  @override
  SvgGenImage get icon => VoicesAssets.icons.check;

  @override
  String title(BuildContext context) => '';

  @override
  String titleDesc(BuildContext context) => '';

  @override
  String message(BuildContext context) => '';
}

final class AccountFinalized extends MyAccountStatusNotification {
  const AccountFinalized()
      : super(
          type: MyAccountStatusNotificationType.success,
        );

  @override
  SvgGenImage get icon => VoicesAssets.icons.check;

  @override
  String title(BuildContext context) => '';

  @override
  String titleDesc(BuildContext context) => '';

  @override
  String message(BuildContext context) => '';
}
