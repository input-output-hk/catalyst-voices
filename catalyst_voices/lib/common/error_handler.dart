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
      handleLocalizedException(error);
    }
  }

  void handleLocalizedException(LocalizedException exception) {
    // TODO(damian-molinski): VoicesSnackBar does not support custom text yet.
    const VoicesSnackBar(type: VoicesSnackBarType.error).show(context);
  }
}
