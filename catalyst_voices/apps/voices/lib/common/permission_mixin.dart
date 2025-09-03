import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/permissions/permission_handler_factory.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

final _logger = Logger('PermissionMixin');

mixin PermissionsMixin<T extends StatefulWidget> on State<T> {
  Future<PermissionResult> getPermission(
    Permission permission, {
    PermissionHandler? permissionHandler,
  }) async {
    try {
      permissionHandler ??= Dependencies.instance.get<PermissionHandler>();
      return await permissionHandler.requestPermission(permission);
    } on PermissionNeedsRationaleException catch (e) {
      final rationale = LocalizedPermissionNeedRationaleException(e.permission);
      showPermissionRationaleDialog(context, rationale);
      return PermissionResult.denied;
    } on PermissionNeedsExplanationException catch (_) {
      const explanation = LocalizedPermissionNeedExplanationException();
      showPermissionExplanationDialog(context, explanation);
      return PermissionResult.denied;
    } catch (e) {
      _logger.severe('Failed to get permission', e);
      showUnknownExceptionSnackbar(context);
      return PermissionResult.denied;
    }
  }

  @visibleForOverriding
  void showPermissionExplanationDialog(
    BuildContext context,
    LocalizedPermissionNeedExplanationException explanation, {
    VoicesSnackBarType type = VoicesSnackBarType.warning,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    String? title,
    List<Widget>? actions,
  }) {
    VoicesSnackBar(
      type: type,
      behavior: behavior,
      title: title ?? context.l10n.permissionNeededTitle,
      message: explanation.message(context),
      actions:
          actions ??
          [
            VoicesTextButton(
              onTap: openAppSettings,
              child: Text(
                context.l10n.openAppSettings,
              ),
            ),
          ],
    ).show(context);
  }

  @visibleForOverriding
  void showPermissionRationaleDialog(
    BuildContext context,
    LocalizedPermissionNeedRationaleException rationale, {
    VoicesSnackBarType type = VoicesSnackBarType.warning,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    String? title,
    List<Widget> actions = const [],
  }) {
    VoicesSnackBar(
      type: type,
      behavior: behavior,
      title: title ?? context.l10n.permissionNeededTitle,
      message: rationale.message(context),
      actions: actions,
    ).show(context);
  }

  @visibleForOverriding
  void showUnknownExceptionSnackbar(
    BuildContext context, {
    VoicesSnackBarType type = VoicesSnackBarType.warning,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    String? title,
    String? message,
    List<Widget> actions = const [],
  }) {
    VoicesSnackBar(
      type: type,
      behavior: behavior,
      title: title ?? context.l10n.somethingWentWrong,
      message: message ?? context.l10n.errorProposalDeletedDescription,
      actions: actions,
    ).show(context);
  }
}

mixin StoragePermissionMixin<T extends StatefulWidget> on PermissionsMixin<T> {
  Future<bool> getStoragePermission([PermissionHandler? permissionHandler]) async => getPermission(
    Permission.storage,
    permissionHandler: permissionHandler,
  ).then((value) => value.isGranted);
}
