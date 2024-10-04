import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/registration/registration_details_panel.dart';
import 'package:catalyst_voices/pages/registration/registration_exit_confirm_dialog.dart';
import 'package:catalyst_voices/pages/registration/registration_info_panel.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Dependencies.instance.get<RegistrationCubit>(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          unawaited(_confirmedExit(context, didPop: didPop));
        },
        child: const VoicesTwoPaneDialog(
          left: RegistrationInfoPanel(),
          right: RegistrationDetailsPanel(),
        ),
      ),
    );
  }

  Future<void> _confirmedExit(
    BuildContext context, {
    required bool didPop,
  }) async {
    if (didPop) {
      return;
    }

    final confirmed = await VoicesQuestionDialog.show(
      context,
      builder: (_) => const RegistrationExitConfirmDialog(),
    );

    if (context.mounted && confirmed) {
      Navigator.of(context).pop();
    }
  }
}
