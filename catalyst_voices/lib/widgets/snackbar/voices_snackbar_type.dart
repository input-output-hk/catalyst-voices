import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

enum CatalystSnackBarType {
  info,
  success,
  warning,
  error;

  Color? backgroundColor(BuildContext context) {
    switch (this) {
      case CatalystSnackBarType.info:
        return Theme.of(context).colors.iconsBackground;
      case CatalystSnackBarType.success:
        return Theme.of(context).colors.iconsBackground;
      case CatalystSnackBarType.warning:
        return Theme.of(context).colors.iconsBackground;
      case CatalystSnackBarType.error:
        return Theme.of(context).colors.iconsBackground;
    }
  }

  IconData icon(BuildContext context) {
    switch (this) {
      case CatalystSnackBarType.info:
        return CatalystVoicesIcons.refresh;
      case CatalystSnackBarType.success:
        return CatalystVoicesIcons.refresh;
      case CatalystSnackBarType.warning:
        return CatalystVoicesIcons.refresh;
      case CatalystSnackBarType.error:
        return CatalystVoicesIcons.refresh;
    }
  }

  String message(BuildContext context) {
    switch (this) {
      case CatalystSnackBarType.info:
        return context.l10n.snackbarInfoMessageText;
      case CatalystSnackBarType.success:
        return context.l10n.snackbarSuccessMessageText;
      case CatalystSnackBarType.warning:
        return context.l10n.snackbarWarningMessageText;
      case CatalystSnackBarType.error:
        return context.l10n.snackbarErrorMessageText;
    }
  }

  String title(BuildContext context) {
    switch (this) {
      case CatalystSnackBarType.info:
        return context.l10n.snackbarInfoLabelText;
      case CatalystSnackBarType.success:
        return context.l10n.snackbarSuccessLabelText;
      case CatalystSnackBarType.warning:
        return context.l10n.snackbarWarningLabelText;
      case CatalystSnackBarType.error:
        return context.l10n.snackbarErrorLabelText;
    }
  }
}
