//ignore_for_file: one_member_abstracts

import 'dart:async';

import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// An interface of an abstract error handler.
abstract interface class ErrorHandler {
  void handleError(Object error);
}

/// A convenient mixin that subscribes to the [ErrorEmitter]
/// obtained from the [errorEmitter] and calls the [handleError].
///
/// After the widget is disposed the error stream is disposed too.
mixin ErrorHandlerStateMixin<E extends ErrorEmitter, T extends StatefulWidget>
    on State<T> implements ErrorHandler {
  StreamSubscription<Object>? _errorSub;

  @override
  void initState() {
    super.initState();
    _errorSub = errorEmitter.errorStream.listen(handleError);
  }

  @override
  void dispose() {
    unawaited(_errorSub?.cancel());
    _errorSub = null;
    super.dispose();
  }

  /// A method that can be overridden to provide a custom error emitter.
  /// 
  /// If this method is not overriden then the emitter of type [E]
  /// must be provided in a widget tree so that context.read can find it.
  E get errorEmitter => context.read<E>();

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
