//ignore_for_file: one_member_abstracts

import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

abstract interface class ErrorHandler {
  void handleError(Object error);
}

mixin ErrorHandlerStateMixin<T extends StatefulWidget> on State<T>
    implements ErrorHandler {
  @override
  void handleError(Object error) {
    if (error is LocalizedException) {
      _handleLocalizedException(error);
    }
  }

  void _handleLocalizedException(LocalizedException exception) {
    VoicesSnackBar(
      type: VoicesSnackBarType.error,
      message: exception.message(context),
    ).show(context);
  }
}
