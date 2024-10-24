import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/registration/registration_details_panel.dart';
import 'package:catalyst_voices/pages/registration/registration_info_panel.dart';
import 'package:catalyst_voices/pages/registration/widgets/exit_confirm_dialog.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationDialog extends StatefulWidget {
  const RegistrationDialog._();

  static Future<void> show(BuildContext context) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(name: '/registration'),
      builder: (context) => const RegistrationDialog._(),
      barrierDismissible: false,
    );
  }

  @override
  State<RegistrationDialog> createState() => _RegistrationDialogState();
}

class _RegistrationDialogState extends State<RegistrationDialog>
    with ErrorHandlerStateMixin<RegistrationCubit, RegistrationDialog> {
  late final RegistrationCubit _cubit = Dependencies.instance.get();

  @override
  void initState() {
    super.initState();
    _cubit.recoverProgress();
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  RegistrationCubit get errorEmitter => _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          unawaited(
            _handlePop(
              context,
              didPop: didPop,
            ),
          );
        },
        child: BlocSelector<RegistrationCubit, RegistrationState, bool>(
          selector: (state) => state.step is! AccountCompletedStep,
          builder: (context, showCloseButton) {
            return VoicesTwoPaneDialog(
              left: const RegistrationInfoPanel(),
              right: const RegistrationDetailsPanel(),
              showCloseButton: showCloseButton,
            );
          },
        ),
      ),
    );
  }

  Future<void> _handlePop(
    BuildContext context, {
    required bool didPop,
  }) async {
    if (didPop) {
      return;
    }

    final state = _cubit.state;
    final hasProgress = (state.progress ?? 0.0) > 0.0;
    if (!hasProgress) {
      Navigator.of(context).pop();
      return;
    }

    final confirmed = await _confirmExit(context, step: state.step);

    if (context.mounted && confirmed) {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _confirmExit(
    BuildContext context, {
    required RegistrationStep step,
  }) {
    if (step.isRegistrationFlow) {
      return VoicesQuestionDialog.show(
        context,
        builder: (_) => const RegistrationExitConfirmDialog(),
      );
    }

    if (step.isRecoverFlow) {
      return VoicesQuestionDialog.show(
        context,
        builder: (_) => const RecoveryExitConfirmDialog(),
      );
    }

    return Future.value(true);
  }
}
