import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

mixin PermissionsMixin<T extends StatefulWidget> on State<T> {
  Future<PermissionResult> getPermission(
    PermissionHandler permissionHandler,
    Permission permission,
  ) async {
    try {
      return await permissionHandler.requestPermission(permission);
    } on PermissionNeedsRationaleException catch (e) {
      final rationale = LocalizedPermissionNeedRationaleException(e.permission);
      _showPermissionRationaleDialog(context, rationale);
      return PermissionResult.denied;
    } on PermissionNeedsExplanationException catch (_) {
      const explanation = LocalizedPermissionNeedExplanationException();
      _showPermissionExplanationDialog(context, explanation);
      return PermissionResult.denied;
    }
  }

  void _showPermissionExplanationDialog(
    BuildContext context,
    LocalizedPermissionNeedExplanationException explanation,
  ) {
    VoicesSnackBar(
      type: VoicesSnackBarType.warning,
      behavior: SnackBarBehavior.floating,
      title: context.l10n.permissionNeededTitle,
      message: explanation.message(context),
      actions: [
        VoicesTextButton(
          onTap: openAppSettings,
          child: Text(
            context.l10n.openAppSettings,
          ),
        ),
      ],
    ).show(context);
  }

  void _showPermissionRationaleDialog(
    BuildContext context,
    LocalizedPermissionNeedRationaleException rationale,
  ) {
    VoicesSnackBar(
      type: VoicesSnackBarType.warning,
      behavior: SnackBarBehavior.floating,
      title: context.l10n.permissionNeededTitle,
      message: rationale.message(context),
    ).show(context);
  }
}

mixin StoragePermissionMixin<T extends StatefulWidget> on PermissionsMixin<T> {
  Future<bool> getStoragePermission(PermissionHandler permissionHandler) async =>
      getPermission(permissionHandler, Permission.storage).then((value) => value.isGranted);
}
