import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/registration/registration_details_panel.dart';
import 'package:catalyst_voices/pages/registration/registration_info_panel.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_confirm_dialog.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationDialog extends StatefulWidget {
  final RegistrationStep? step;

  const RegistrationDialog._({
    required this.step,
  });

  @override
  State<RegistrationDialog> createState() => _RegistrationDialogState();

  static Future<void> show(
    BuildContext context, {
    RegistrationStep? step,
  }) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(name: '/registration'),
      builder: (context) => RegistrationDialog._(step: step),
      barrierDismissible: false,
    );
  }
}

class _RegistrationDialogState extends State<RegistrationDialog>
    with ErrorHandlerStateMixin<RegistrationCubit, RegistrationDialog> {
  late final RegistrationCubit _cubit = Dependencies.instance.get();

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
              key: const Key('RegistrationDialog'),
              left: const RegistrationInfoPanel(),
              right: const RegistrationDetailsPanel(),
              showCloseButton: showCloseButton,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final step = widget.step;
    if (step != null) {
      _cubit.goToStep(step);
    } else if (_cubit.hasProgress) {
      _cubit.recoverProgress();
    }
  }

  Future<bool> _confirmExit(
    BuildContext context, {
    required RegistrationStep step,
    required double progress,
  }) async {
    if (step.isWalletLinkFlow) {
      final stayInTheFlow = await VoicesQuestionDialog.show(
        context,
        routeSettings: const RouteSettings(name: '/registration-confirm-exit'),
        builder: (_) => const WalletLinkExitConfirmDialog(),
        fallback: true,
      );

      return !stayInTheFlow;
    }

    if (step.isRegistrationFlow) {
      final stayInTheFlow = await VoicesQuestionDialog.show(
        context,
        routeSettings: const RouteSettings(name: '/registration-confirm-exit'),
        builder: (_) => const RegistrationExitConfirmDialog(),
        fallback: true,
      );

      return !stayInTheFlow;
    }

    if (step.isRecoverFlow) {
      final stayInTheFlow = await VoicesQuestionDialog.show(
        context,
        routeSettings: const RouteSettings(name: '/recovery-confirm-exit'),
        builder: (_) => const RecoveryExitConfirmDialog(),
        fallback: true,
      );

      return !stayInTheFlow;
    }

    return Future.value(true);
  }

  Future<void> _handlePop(
    BuildContext context, {
    required bool didPop,
  }) async {
    if (didPop) {
      return;
    }

    final state = _cubit.state;
    final confirmed = await _confirmExit(
      context,
      step: state.step,
      progress: state.progress ?? 0.0,
    );

    if (context.mounted && confirmed) {
      Navigator.of(context).pop();
    }
  }
}
