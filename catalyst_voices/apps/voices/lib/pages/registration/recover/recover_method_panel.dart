import 'package:catalyst_voices/pages/registration/widgets/registration_tile.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
        Text(
          key: const Key('RecoverKeychainMethodsTitle'),
          context.l10n.recoverKeychainMethodsTitle,
          style: theme.textTheme.titleMedium?.copyWith(color: colorLvl1),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: RegistrationRecoverMethod.values
                .map<Widget>(
                  (method) {
                    return RegistrationTile(
                      key: ValueKey(method),
                      icon: method._icon,
                      title: method._getTitle(context.l10n),
                      subtitle: method._getSubtitle(context.l10n),
                      onTap: () {
                        switch (method) {
                          case RegistrationRecoverMethod.seedPhrase:
                            RegistrationCubit.of(context)
                                .recoverWithSeedPhrase();
                        }
                      },
                    );
                  },
                )
                .separatedBy(const SizedBox(height: 12))
                .toList(),
          ),
        ),
        const Spacer(),
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
        context.l10n.recoverKeychainNonFound,
        style: DefaultTextStyle.of(context).style,
      ),
    );
  }
}

extension _RegistrationRecoverMethodExt on RegistrationRecoverMethod {
  SvgGenImage get _icon => switch (this) {
        RegistrationRecoverMethod.seedPhrase => VoicesAssets.icons.colorSwatch,
      };

  String _getTitle(VoicesLocalizations l10n) => switch (this) {
        RegistrationRecoverMethod.seedPhrase => l10n.seedPhrase12Words,
      };

  String? _getSubtitle(VoicesLocalizations l10n) => switch (this) {
        RegistrationRecoverMethod.seedPhrase => null,
      };
}
