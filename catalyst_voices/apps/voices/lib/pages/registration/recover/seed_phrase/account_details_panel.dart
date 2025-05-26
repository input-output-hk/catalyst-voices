import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/widgets/buttons/clipboard_button.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';

class AccountDetailsPanel extends StatelessWidget {
  const AccountDetailsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colors.textOnPrimaryLevel1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          key: const Key('RecoveryAccountTitle'),
          context.l10n.recoveryAccountTitle,
          style: theme.textTheme.titleMedium?.copyWith(color: textColor),
        ),
        const SizedBox(height: 24),
        const Expanded(
          child: SingleChildScrollView(
            child: _BlocAccountSummery(),
          ),
        ),
        const SizedBox(height: 24),
        const _BlocNavigation(),
      ],
    );
  }
}

class _AccountRoles extends StatelessWidget {
  final Set<AccountRole> roles;

  const _AccountRoles({
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final role in roles)
          VoicesChip.rectangular(
            leading: role.smallIcon.buildIcon(
              size: 18,
              color: Theme.of(context).colors.iconsForeground,
            ),
            content: Text(role.getName(context)),
          ),
      ],
    );
  }
}

class _AccountSummaryDetails extends StatelessWidget {
  final String? username;
  final String? email;
  final Set<AccountRole> roles;

  const _AccountSummaryDetails({
    required this.username,
    required this.email,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.5,
          color: Theme.of(context).colors.outlineBorderVariant,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          _SummaryDetails(
            label: Text(context.l10n.nickname),
            value: UsernameText(username),
          ),
          _SummaryDetails(
            label: Text(context.l10n.email),
            value: Text(
              email?.nullIfEmpty() ?? context.l10n.notAvailableAbbr.toLowerCase(),
            ),
          ),
          _SummaryDetails(
            label: Text(context.l10n.registeredRoles),
            value: _AccountRoles(roles: roles),
          ),
        ],
      ),
    );
  }
}

class _BlocAccountSummery extends StatelessWidget {
  const _BlocAccountSummery();

  @override
  Widget build(BuildContext context) {
    return BlocRecoverSelector<Result<AccountSummaryData, LocalizedException>?>(
      selector: (state) => state.accountDetails,
      builder: (context, state) {
        return switch (state) {
          Success<AccountSummaryData, LocalizedException>(:final value) =>
            _RecoveredAccountSummary(account: value),
          Failure<AccountSummaryData, LocalizedException>(:final value) =>
            _RecoverAccountFailure(exception: value),
          _ => const Center(child: VoicesCircularProgressIndicator()),
        };
      },
    );
  }
}

class _BlocNavigation extends StatelessWidget {
  const _BlocNavigation();

  @override
  Widget build(BuildContext context) {
    return BlocRecoverSelector<bool>(
      selector: (state) => state.isAccountSummaryNextEnabled,
      builder: (context, state) {
        return _Navigation(
          isNextEnabled: state,
        );
      },
    );
  }
}

class _CheckOnCardanoScanButton extends StatelessWidget with LaunchUrlMixin {
  final ShelleyAddress address;

  const _CheckOnCardanoScanButton({required this.address});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: VoicesTextButton(
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
        child: Text(
          context.l10n.checkOnCardanoScan,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
        ),
        onTap: () => _showOnCardanoScan(address),
      ),
    );
  }

  void _showOnCardanoScan(ShelleyAddress address) {
    final uri = VoicesConstants.cardanoScanStakeAddressUrl(address).getUri();
    unawaited(launchUri(uri));
  }
}

class _Navigation extends StatelessWidget {
  final bool isNextEnabled;

  const _Navigation({
    this.isNextEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          label: 'Set unlock password for this device',
          child: VoicesFilledButton(
            key: const Key('SetUnlockPasswordButton'),
            onTap: isNextEnabled ? () => RegistrationCubit.of(context).nextStep() : null,
            child: Text(context.l10n.recoveryAccountDetailsAction),
          ),
        ),
        const SizedBox(height: 10),
        VoicesTextButton(
          key: const Key('RecoverDifferentKeychainButton'),
          onTap: () async {
            final cubit = RegistrationCubit.of(context);
            await cubit.recover.reset();
            cubit.previousStep();
          },
          child: Text(context.l10n.recoverDifferentKeychain),
        ),
      ],
    );
  }
}

class _RecoverAccountFailure extends StatelessWidget {
  final LocalizedException exception;

  const _RecoverAccountFailure({
    required this.exception,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesErrorIndicator(
      key: const Key('RecoveryAccountError'),
      message: exception.message(context),
      onRetry: () async {
        final recover = RegistrationCubit.of(context).recover;
        await recover.recoverAccount();
      },
    );
  }
}

class _RecoveredAccountSummary extends StatelessWidget {
  final AccountSummaryData account;

  const _RecoveredAccountSummary({
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final address = account.formattedAddress;
    final balance = account.balance;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _RecoverStatusText(),
        const SizedBox(height: 24),
        _AccountSummaryDetails(
          username: account.username,
          email: account.email,
          roles: account.roles,
        ),
        if (address != null && balance != null) ...[
          const SizedBox(height: 24),
          _WalletSummaryDetails(
            address: address,
            clipboardAddress: account.clipboardAddress,
            balance: balance,
          ),
        ],
      ],
    );
  }
}

class _RecoverStatusText extends StatelessWidget {
  const _RecoverStatusText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colors.textOnPrimaryLevel1;

    return Text(
      key: const Key('RecoveryAccountSuccessTitle'),
      context.l10n.recoveryAccountSuccessTitle,
      style: theme.textTheme.titleMedium?.copyWith(color: textColor),
    );
  }
}

class _SummaryDetails extends StatelessWidget {
  final Widget label;
  final Widget value;

  const _SummaryDetails({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DefaultTextStyle(
            style: textStyle.copyWith(fontWeight: FontWeight.bold),
            child: label,
          ),
        ),
        Expanded(
          child: DefaultTextStyle(
            style: textStyle,
            child: value,
          ),
        ),
      ],
    );
  }
}

class _WalletSummaryDetails extends StatelessWidget {
  final String address;
  final ShelleyAddress? clipboardAddress;
  final String balance;

  const _WalletSummaryDetails({
    required this.address,
    required this.clipboardAddress,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final clipboardAddress = this.clipboardAddress;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.5,
          color: Theme.of(context).colors.outlineBorderVariant,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _SummaryDetails(
              label: Text(context.l10n.linkedWallet),
              value: Row(
                spacing: 6,
                children: [
                  Text(address),
                  if (clipboardAddress != null)
                    VoicesClipboardIconButton(
                      clipboardData: clipboardAddress.toBech32(),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _SummaryDetails(
              label: Text(context.l10n.balance),
              value: Text(balance),
            ),
          ),
          if (clipboardAddress != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _CheckOnCardanoScanButton(
                address: clipboardAddress,
              ),
            ),
        ],
      ),
    );
  }
}
