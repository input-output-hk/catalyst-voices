import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

final class LocalizedPermissionNeedRationaleException extends LocalizedException {
  final Permission _permission;

  const LocalizedPermissionNeedRationaleException(this._permission);

  @override
  String message(BuildContext context) => _localizedMessage(context.l10n);

  String _localizedMessage(VoicesLocalizations l10n) {
    return switch (_permission) {
      Permission.storage => l10n.storagePermissionRationale,
      // TODO(LynxLynxx): Add more permissions rationales when needed
      _ => l10n.defaultPermissionRationale,
    };
  }
}
