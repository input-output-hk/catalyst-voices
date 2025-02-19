import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// Enum representing the different types of SnackBars available in the
/// [VoicesSnackBar] widget.
///
/// Each type determines the appearance and behavior of the [VoicesSnackBar].
enum VoicesSnackBarType { info, success, warning, error }

class _SnackBarData {
  final SvgGenImage icon;
  final ColorResolver iconColor;
  final ColorResolver titleColor;
  final ColorResolver messageColor;
  final ColorResolver backgroundColor;
  final L10nResolver title;
  final L10nResolver message;

  const _SnackBarData({
    required this.icon,
    required this.iconColor,
    required this.titleColor,
    required this.messageColor,
    required this.backgroundColor,
    required this.title,
    required this.message,
  });
}

extension VoicesSnackBarTypeExtension on VoicesSnackBarType {
  static final Map<VoicesSnackBarType, _SnackBarData> _data = {
    VoicesSnackBarType.info: _SnackBarData(
      icon: VoicesAssets.icons.informationCircle,
      iconColor: (colors, colorScheme) => colors.iconsPrimary,
      titleColor: (colors, colorScheme) => colors.onPrimaryContainer,
      messageColor: (colors, colorScheme) => colors.onPrimaryContainer,
      backgroundColor: (colors, colorScheme) => colors.primaryContainer,
      title: (l10n) => l10n.snackbarInfoLabelText,
      message: (l10n) => l10n.snackbarInfoMessageText,
    ),
    VoicesSnackBarType.success: _SnackBarData(
      icon: VoicesAssets.icons.checkCircle,
      iconColor: (colors, colorScheme) => colors.iconsSuccess,
      titleColor: (colors, colorScheme) => colors.onSuccessContainer,
      messageColor: (colors, colorScheme) => colors.onSuccessContainer,
      backgroundColor: (colors, colorScheme) => colors.successContainer,
      title: (l10n) => l10n.snackbarSuccessLabelText,
      message: (l10n) => l10n.snackbarSuccessMessageText,
    ),
    VoicesSnackBarType.warning: _SnackBarData(
      icon: VoicesAssets.icons.exclamation,
      iconColor: (colors, colorScheme) => colors.iconsWarning,
      titleColor: (colors, colorScheme) => colors.onWarningContainer,
      messageColor: (colors, colorScheme) => colors.onWarningContainer,
      backgroundColor: (colors, colorScheme) => colors.warningContainer,
      title: (l10n) => l10n.snackbarWarningLabelText,
      message: (l10n) => l10n.snackbarWarningMessageText,
    ),
    VoicesSnackBarType.error: _SnackBarData(
      icon: VoicesAssets.icons.exclamationCircle,
      iconColor: (colors, colorScheme) => colorScheme.onError,
      titleColor: (colors, colorScheme) => colorScheme.onError,
      messageColor: (colors, colorScheme) => colorScheme.onError,
      backgroundColor: (color, colorScheme) => colorScheme.error,
      title: (l10n) => l10n.snackbarErrorLabelText,
      message: (l10n) => l10n.snackbarErrorMessageText,
    ),
  };

  _SnackBarData get _snackBarData => _data[this]!;

  Color? backgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    return _snackBarData.backgroundColor(
      theme.colors,
      theme.colorScheme,
    );
  }

  SvgGenImage icon() => _snackBarData.icon;

  Color? iconColor(BuildContext context) {
    final theme = Theme.of(context);
    return _snackBarData.iconColor(
      theme.colors,
      theme.colorScheme,
    );
  }

  String message(BuildContext context) => _snackBarData.message(context.l10n);

  Color? messageColor(BuildContext context) {
    final theme = Theme.of(context);
    return _snackBarData.titleColor(
      theme.colors,
      theme.colorScheme,
    );
  }

  String title(BuildContext context) => _snackBarData.title(context.l10n);

  Color? titleColor(BuildContext context) {
    final theme = Theme.of(context);
    return _snackBarData.titleColor(
      theme.colors,
      theme.colorScheme,
    );
  }
}
