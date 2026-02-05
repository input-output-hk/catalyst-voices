import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/registration/registration_type.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_confirm_dialog.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_dialog_scaffold.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_panels_dialog.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

// TODO(damian-molinski): refactor it to AccountSetupDialog.
class RegistrationDialog extends StatefulWidget {
  final RegistrationType type;

  const RegistrationDialog._({
    required this.type,
  });

  @override
  State<RegistrationDialog> createState() => _RegistrationDialogState();

  static Future<void> show(
    BuildContext context, {
    required RegistrationType type,
  }) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(name: '/registration'),
      builder: (context) => RegistrationDialog._(type: type),
      barrierDismissible: false,
    );
  }
}

class _RegistrationDialogState extends State<RegistrationDialog> {
  late final RegistrationCubit _cubit = Dependencies.instance.get();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => _handlePop(context, didPop: didPop),
        child: const RegistrationDialogScaffold(child: RegistrationPanelsDialog()),
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

    switch (widget.type) {
      case FreshRegistration():
        break;
      case UpdateAccount(:final id):
        unawaited(_cubit.startAccountUpdate(id: id));
      case RecoverRegistration():
        _cubit.goToStep(const RecoverWithSeedPhraseStep());
      case ContinueRegistration():
        unawaited(_cubit.recoverProgress());
      case LinkDrepKey(:final id):
        unawaited(_cubit.startLinkDrepKey(id: id));
    }
  }

  Future<bool> _confirmExit(
    BuildContext context, {
    required RegistrationStep step,
    required double progress,
  }) async {
    if (widget.type is UpdateAccount || step.isWalletDrepLinkFlow) {
      final stayInTheFlow = await VoicesQuestionDialog.show(
        context,
        routeSettings: const RouteSettings(name: '/registration-confirm-exit'),
        builder: (_) => const AccountUpdateExitConfirmDialog(),
        fallback: true,
      );

      return !stayInTheFlow;
    }

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
