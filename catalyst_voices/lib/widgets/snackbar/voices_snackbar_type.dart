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
    switch (this) {
      case VoicesSnackBarType.info:
        return Theme.of(context).colors.iconsBackground;
      case VoicesSnackBarType.success:
        return Theme.of(context).colors.iconsBackground;
      case VoicesSnackBarType.warning:
        return Theme.of(context).colors.iconsBackground;
      case VoicesSnackBarType.error:
        return Theme.of(context).colors.iconsBackground;
    }
  }

  IconData icon(BuildContext context) {
    switch (this) {
      case VoicesSnackBarType.info:
        return CatalystVoicesIcons.refresh;
      case VoicesSnackBarType.success:
        return CatalystVoicesIcons.refresh;
      case VoicesSnackBarType.warning:
        return CatalystVoicesIcons.refresh;
      case VoicesSnackBarType.error:
        return CatalystVoicesIcons.refresh;
    }
  }

  String message(BuildContext context) {
    switch (this) {
      case VoicesSnackBarType.info:
        return context.l10n.snackbarInfoMessageText;
      case VoicesSnackBarType.success:
        return context.l10n.snackbarSuccessMessageText;
      case VoicesSnackBarType.warning:
        return context.l10n.snackbarWarningMessageText;
      case VoicesSnackBarType.error:
        return context.l10n.snackbarErrorMessageText;
    }
  }

  String title(BuildContext context) {
    switch (this) {
      case VoicesSnackBarType.info:
        return context.l10n.snackbarInfoLabelText;
      case VoicesSnackBarType.success:
        return context.l10n.snackbarSuccessLabelText;
      case VoicesSnackBarType.warning:
        return context.l10n.snackbarWarningLabelText;
      case VoicesSnackBarType.error:
        return context.l10n.snackbarErrorLabelText;
    }
  }
}
