import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

enum AccountGetStartedType { create, recover }

class AccountGetStartedDialog extends StatelessWidget {
  const AccountGetStartedDialog._();

  static Future<AccountGetStartedType?> show(BuildContext context) {
    return VoicesDialog.show(
      context: context,
      builder: (context) => const AccountGetStartedDialog._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VoicesDesktopPanelsDialog(
      left: Column(
        children: [
          Text(
            'Get started',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colors.textOnPrimaryLevel0,
            ),
          ),
          Placeholder(),
        ],
      ),
      right: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Text(
            'Welcome to Catalyst!',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colors.textOnPrimaryLevel1,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'If you already have a Catalyst keychain you can restore it on this device, or you can create a new Catalyst Keychain.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colors.textOnPrimaryLevel1,
            ),
          ),
          SizedBox(height: 32),
          Text(
            'What do you want to do?',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colors.textOnPrimaryLevel0,
            ),
          ),
          SizedBox(height: 24),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GetStartedTypeTile(
                key: ValueKey(AccountGetStartedType.create),
                type: AccountGetStartedType.create,
              ),
              SizedBox(height: 12),
              _GetStartedTypeTile(
                key: ValueKey(AccountGetStartedType.recover),
                type: AccountGetStartedType.create,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _GetStartedTypeTile extends StatelessWidget {
  final AccountGetStartedType type;

  const _GetStartedTypeTile({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints.tightFor(height: 80),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          VoicesAssets.icons.colorSwatch.buildIcon(
            size: 48,
            color: theme.colors.iconsBackground,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create a new  Catalyst Keychain',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                Text(
                  'On this device',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
