import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_action.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

final class ViewingOlderVersionSnackBar extends VoicesSnackBar {
  factory ViewingOlderVersionSnackBar(BuildContext context, {String? message}) {
    return ViewingOlderVersionSnackBar._(
      message: message ?? context.l10n.viewingOlderDocumentVersion,
      action: VoicesSnackBarPrimaryAction(
        type: VoicesSnackBarType.warning,
        onPressed: () {
          if (context.mounted) {
            VoicesSnackBar.hideCurrent(context);

            context.read<DocumentViewerCubit>().emitSignal(const ChangeVersionSignal());
          }
        },
        child: Text(context.l10n.viewLatestDocumentVersion),
      ),
      title: context.l10n.headsUpTitle,
    );
  }

  ViewingOlderVersionSnackBar._({
    required super.message,
    super.title,
    required Widget action,
  }) : super(
         type: VoicesSnackBarType.warning,
         icon: VoicesAssets.icons.reply.buildIcon(),
         actions: [action],
         duration: const Duration(seconds: 6),
       );
}
