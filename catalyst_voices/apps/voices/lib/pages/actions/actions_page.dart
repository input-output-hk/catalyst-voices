import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ActionsPage extends StatelessWidget {
  const ActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const VoicesDrawer(
      width: 500,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            _Header(),
            SizedBox(height: 30),
            _Content(),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          'No actions',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.myActions,
          style: context.textTheme.titleLarge,
        ),
        CloseButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
