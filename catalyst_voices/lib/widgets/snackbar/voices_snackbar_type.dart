import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

enum VoicesSnackBarType {
  info,
  success,
  warning,
  error;

  Color? backgroundColor(BuildContext context) {
    final colors = Theme.of(context).colors;

    switch (this) {
      case VoicesSnackBarType.info:
        return colors.primaryContainer;
      case VoicesSnackBarType.success:
        return colors.successContainer;
      case VoicesSnackBarType.warning:
        return colors.warningContainer;
      case VoicesSnackBarType.error:
        return colors.errorContainer;
    }
  }

  IconData icon(BuildContext context) {
    switch (this) {
      case VoicesSnackBarType.info:
        return CatalystVoicesIcons.information_circle;
      case VoicesSnackBarType.success:
        return CatalystVoicesIcons.check_circle;
      case VoicesSnackBarType.warning:
        return CatalystVoicesIcons.exclamation;
      case VoicesSnackBarType.error:
        return CatalystVoicesIcons.exclamation_circle;
    }
  }

  Color? iconColor(BuildContext context) {
    final colors = Theme.of(context).colors;

    switch (this) {
      case VoicesSnackBarType.info:
        return colors.iconsPrimary;
      case VoicesSnackBarType.success:
        return colors.iconsSuccess;
      case VoicesSnackBarType.warning:
        return colors.iconsWarning;
      case VoicesSnackBarType.error:
        return colors.iconsError;
    }
  }

  String message(BuildContext context) {
    final l10n = context.l10n;

    switch (this) {
      case VoicesSnackBarType.info:
        return l10n.snackbarInfoMessageText;
      case VoicesSnackBarType.success:
        return l10n.snackbarSuccessMessageText;
      case VoicesSnackBarType.warning:
        return l10n.snackbarWarningMessageText;
      case VoicesSnackBarType.error:
        return l10n.snackbarErrorMessageText;
    }
  }

  String title(BuildContext context) {
    final l10n = context.l10n;

    switch (this) {
      case VoicesSnackBarType.info:
        return l10n.snackbarInfoLabelText;
      case VoicesSnackBarType.success:
        return l10n.snackbarSuccessLabelText;
      case VoicesSnackBarType.warning:
        return l10n.snackbarWarningLabelText;
      case VoicesSnackBarType.error:
        return l10n.snackbarErrorLabelText;
    }
  }

  Color? titleColor(BuildContext context) {
    final colors = Theme.of(context).colors;

    switch (this) {
      case VoicesSnackBarType.info:
        return colors.onPrimaryContainer;
      case VoicesSnackBarType.success:
        return colors.onSuccessContainer;
      case VoicesSnackBarType.warning:
        return colors.onWarningContainer;
      case VoicesSnackBarType.error:
        return colors.onErrorContainer;
    }
  }
}
