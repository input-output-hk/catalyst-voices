import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AccountSetupDialog extends StatelessWidget {
  const AccountSetupDialog._();

  static Future<void> show(BuildContext context) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(name: '/account-setup'),
      builder: (context) => const AccountSetupDialog._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopPanelsDialog(
      left: Column(),
      right: Column(),
    );
  }
}
