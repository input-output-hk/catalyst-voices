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
  final ColorResolver backgroundColor;
  final L10nResolver message;
  final L10nResolver title;

  const _SnackBarData({
    required this.icon,
    required this.iconColor,
    required this.titleColor,
    required this.backgroundColor,
    required this.message,
    required this.title,
  });
}

extension VoicesSnackBarTypeExtension on VoicesSnackBarType {
  static final Map<VoicesSnackBarType, _SnackBarData> _data = {
    VoicesSnackBarType.info: _SnackBarData(
      icon: VoicesAssets.icons.informationCircle,
      iconColor: (colors) => colors.iconsPrimary,
      titleColor: (colors) => colors.onPrimaryContainer,
      backgroundColor: (colors) => colors.primaryContainer,
      message: (l10n) => l10n.snackbarInfoMessageText,
      title: (l10n) => l10n.snackbarInfoLabelText,
    ),
    VoicesSnackBarType.success: _SnackBarData(
      icon: VoicesAssets.icons.checkCircle,
      iconColor: (colors) => colors.iconsSuccess,
      titleColor: (colors) => colors.onSuccessContainer,
      backgroundColor: (colors) => colors.successContainer,
      message: (l10n) => l10n.snackbarSuccessMessageText,
      title: (l10n) => l10n.snackbarSuccessLabelText,
    ),
    VoicesSnackBarType.warning: _SnackBarData(
      icon: VoicesAssets.icons.exclamation,
      iconColor: (colors) => colors.iconsWarning,
      titleColor: (colors) => colors.onWarningContainer,
      backgroundColor: (colors) => colors.warningContainer,
      message: (l10n) => l10n.snackbarWarningMessageText,
      title: (l10n) => l10n.snackbarWarningLabelText,
    ),
    VoicesSnackBarType.error: _SnackBarData(
      icon: VoicesAssets.icons.exclamationCircle,
      iconColor: (colors) => colors.iconsError,
      titleColor: (colors) => colors.onErrorContainer,
      backgroundColor: (colors) => colors.errorContainer,
      message: (l10n) => l10n.snackbarErrorMessageText,
      title: (l10n) => l10n.snackbarErrorLabelText,
    ),
  };

  _SnackBarData get _snackBarData => _data[this]!;

  Color? backgroundColor(BuildContext context) =>
      _snackBarData.backgroundColor(Theme.of(context).colors);

  SvgGenImage icon() => _snackBarData.icon;

  Color? iconColor(BuildContext context) =>
      _snackBarData.iconColor(Theme.of(context).colors);

  String message(BuildContext context) => _snackBarData.message(context.l10n);

  String title(BuildContext context) => _snackBarData.title(context.l10n);

  Color? titleColor(BuildContext context) =>
      _snackBarData.titleColor(Theme.of(context).colors);
}
