import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/registration/registration_details_panel.dart';
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
      child: const VoicesTwoPaneDialog(
        left: RegistrationInfoPanel(),
        right: RegistrationDetailsPanel(),
      ),
    );
  }
}
