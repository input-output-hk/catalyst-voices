import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

final class UsernameUpdatedSnackBar extends VoicesSnackBar {
  factory UsernameUpdatedSnackBar(BuildContext context) {
    return UsernameUpdatedSnackBar._(
      title: context.l10n.usernameSavedTitle,
      message: context.l10n.usernameSavedMessage,
    );
  }

  UsernameUpdatedSnackBar._({
    required super.title,
    required super.message,
  }) : super(
         type: VoicesSnackBarType.success,
         icon: VoicesAssets.icons.check.buildIcon(),
       );
}
