import 'package:catalyst_voices/pages/registration/widgets/registration_tile.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class RecoverMethodPanel extends StatelessWidget {
  const RecoverMethodPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorLvl0 = theme.colors.textOnPrimaryLevel0;
    final colorLvl1 = theme.colors.textOnPrimaryLevel1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  key: const Key('RecoverKeychainMethodsTitle'),
                  context.l10n.recoverKeychainMethodsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorLvl1,
                  ),
                ),
                const SizedBox(height: 12),
                _BlocOnDeviceKeychains(onUnlockTap: _unlockKeychain),
                const SizedBox(height: 12),
                Text(
                  key: const Key('RecoverKeychainMethodsSubtitle'),
                  context.l10n.recoverKeychainMethodsSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorLvl1),
                ),
                const SizedBox(height: 32),
                Text(
                  key: const Key('RecoverKeychainMethodsListTitle'),
                  context.l10n.recoverKeychainMethodsListTitle,
                  style: theme.textTheme.titleSmall?.copyWith(color: colorLvl0),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: _RecoverMethodsColumn(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        VoicesBackButton(
          key: const Key('BackButton'),
          onTap: () => RegistrationCubit.of(context).previousStep(),
        ),
      ],
    );
  }

  void _unlockKeychain() {
    //
  }
}

class _BlocOnDeviceKeychains extends StatelessWidget {
  final VoidCallback onUnlockTap;

  const _BlocOnDeviceKeychains({
    required this.onUnlockTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocRecoverSelector<bool>(
      key: const Key('BlocOnDeviceKeychains'),
      selector: (state) => state.foundKeychain,
      builder: (context, state) {
        return _OnDeviceKeychains(
          foundKeychain: state,
          onUnlockTap: onUnlockTap,
        );
      },
    );
  }
}

class _KeychainFoundIndicator extends StatelessWidget {
  final VoidCallback onUnlockTap;

  const _KeychainFoundIndicator({
    required this.onUnlockTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesIndicator(
      type: VoicesIndicatorType.success,
      icon: VoicesAssets.icons.check,
      message: Text(
        context.l10n.recoverKeychainFound,
        style: DefaultTextStyle.of(context).style,
      ),
      action: VoicesTextButton(
        onTap: onUnlockTap,
        leading: VoicesAssets.icons.lockOpen.buildIcon(),
        child: Text(context.l10n.unlock),
      ),
    );
  }
}

class _KeychainNotFoundIndicator extends StatelessWidget {
  const _KeychainNotFoundIndicator();

  @override
  Widget build(BuildContext context) {
    return VoicesIndicator(
      key: const Key('KeychainNotFoundIndicator'),
      type: VoicesIndicatorType.error,
      icon: VoicesAssets.icons.exclamation,
      message: Text(
        key: const Key('KeychainNotFoundMessage'),
        context.l10n.recoverKeychainNonFound,
        style: DefaultTextStyle.of(context).style,
      ),
    );
  }
}

class _OnDeviceKeychains extends StatelessWidget {
  final bool foundKeychain;
  final VoidCallback onUnlockTap;

  const _OnDeviceKeychains({
    this.foundKeychain = false,
    required this.onUnlockTap,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Theme.of(context).colors.textOnPrimaryLevel1),
      child: foundKeychain
          ? _KeychainFoundIndicator(onUnlockTap: onUnlockTap)
          : const _KeychainNotFoundIndicator(),
    );
  }
}

class _RecoverMethodsColumn extends StatelessWidget {
  const _RecoverMethodsColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: RegistrationRecoverMethod.values.map<Widget>(
        (method) {
          return RegistrationTile(
            key: ValueKey(method),
            icon: method._icon,
            title: method._getTitle(context.l10n),
            subtitle: method._getSubtitle(context.l10n),
            onTap: () => _onMethodTap(context, method: method),
          );
        },
      ).toList(),
    );
  }

  void _onMethodTap(
    BuildContext context, {
    required RegistrationRecoverMethod method,
  }) {
    switch (method) {
      case RegistrationRecoverMethod.seedPhrase:
        RegistrationCubit.of(context).recoverWithSeedPhrase();
    }
  }
}

extension _RegistrationRecoverMethodExt on RegistrationRecoverMethod {
  SvgGenImage get _icon => switch (this) {
        RegistrationRecoverMethod.seedPhrase => VoicesAssets.icons.colorSwatch,
      };

  String? _getSubtitle(VoicesLocalizations l10n) => switch (this) {
        RegistrationRecoverMethod.seedPhrase => null,
      };

  String _getTitle(VoicesLocalizations l10n) => switch (this) {
        RegistrationRecoverMethod.seedPhrase => l10n.recoverWithSeedPhrase12Words,
      };
}
