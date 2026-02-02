import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_info_dialog.dart';
import 'package:flutter/material.dart';

/// A reusable dialog for display "Learn more" information about the voting role (power).
class AccountVotingRoleLearnMoreDialog extends StatelessWidget {
  final String title;
  final String message;

  const AccountVotingRoleLearnMoreDialog._({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesInfoDialog(
      title: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.left,
          ),
        ),
      ),
      message: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(name: '/voting/voting-role/learn-more'),
      builder: (context) => AccountVotingRoleLearnMoreDialog._(
        title: title,
        message: message,
      ),
    );
  }
}
