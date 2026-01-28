import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
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

typedef AccountDetailsSelector =
    BlocWidgetSelector<RegistrationState, Result<AccountSummaryData, LocalizedException>?>;

class WalletAccountDetails extends StatelessWidget {
  final AccountDetailsSelector accountDetailsSelector;
  final BlocWidgetSelector<RegistrationState, bool> isNextButtonEnabledSelector;
  final VoidCallback onNextButtonTap;
  final VoidCallback onBackButtonTap;
  final VoidCallback onRetryButtonTap;
  final String title;
  final String successTitle;
  final String nextButtonTitle;
  final String backButtonTitle;

  const WalletAccountDetails({
    super.key,
    required this.accountDetailsSelector,
    required this.isNextButtonEnabledSelector,
    required this.onNextButtonTap,
    required this.onBackButtonTap,
    required this.onRetryButtonTap,
    required this.title,
    required this.successTitle,
    required this.nextButtonTitle,
    required this.backButtonTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colors.textOnPrimaryLevel1;

    return RegistrationDetailsPanelScaffold(
      title: Text(
        key: const Key('WalletAccountTitle'),
        title,
        style: theme.textTheme.titleMedium?.copyWith(color: textColor),
      ),
      body: SingleChildScrollView(
        child: _BlocWalletAccountSummary(
          accountDetailsSelector: accountDetailsSelector,
          onRetryButtonTap: onRetryButtonTap,
          successTitle: successTitle,
        ),
      ),
      footer: _BlocNavigation(
        isNextButtonEnabledSelector: isNextButtonEnabledSelector,
        onNextButtonTap: onNextButtonTap,
        onBackButtonTap: onBackButtonTap,
        nextButtonTitle: nextButtonTitle,
        backButtonTitle: backButtonTitle,
      ),
    );
  }
}

class _AccountFailure extends StatelessWidget {
  final LocalizedException exception;
  final VoidCallback onRetryButtonTap;

  const _AccountFailure({
    required this.exception,
    required this.onRetryButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesErrorIndicator(
      key: const Key('AccountDetailsError'),
      message: exception.message(context),
      onRetry: onRetryButtonTap,
    );
  }
}

class _AccountRoles extends StatelessWidget {
  final Set<AccountRole> roles;

  const _AccountRoles({required this.roles});

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

class _AccountSummary extends StatelessWidget {
  final AccountSummaryData account;
  final String successTitle;

  const _AccountSummary({
    required this.account,
    required this.successTitle,
  });

  @override
  Widget build(BuildContext context) {
    final address = account.formattedAddress;
    final balance = account.balance;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SuccessTitle(successTitle),
        const SizedBox(height: 24),
        _AccountSummaryDetails(
          key: const Key('AccountSummaryDetails'),
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

class _AccountSummaryDetails extends StatelessWidget {
  final String? username;
  final String? email;
  final Set<AccountRole> roles;

  const _AccountSummaryDetails({
    super.key,
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
        border: Border.all(width: 1.5, color: Theme.of(context).colors.outlineBorderVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(
            context.l10n.summary,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          _SummaryDetails(
            label: Text(context.l10n.nickname),
            value: UsernameText(username),
          ),
          _SummaryDetails(
            label: Text(context.l10n.email),
            value: Text(email?.nullIfEmpty() ?? context.l10n.notAvailableAbbr.toLowerCase()),
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

class _BlocNavigation extends StatelessWidget {
  final BlocWidgetSelector<RegistrationState, bool> isNextButtonEnabledSelector;
  final VoidCallback onNextButtonTap;
  final VoidCallback onBackButtonTap;
  final String nextButtonTitle;
  final String backButtonTitle;

  const _BlocNavigation({
    required this.isNextButtonEnabledSelector,
    required this.onNextButtonTap,
    required this.onBackButtonTap,
    required this.nextButtonTitle,
    required this.backButtonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RegistrationCubit, RegistrationState, bool>(
      selector: isNextButtonEnabledSelector,
      builder: (context, state) {
        return _Navigation(
          isNextEnabled: state,
          onNextButtonTap: onNextButtonTap,
          onBackButtonTap: onBackButtonTap,
          nextButtonTitle: nextButtonTitle,
          backButtonTitle: backButtonTitle,
        );
      },
    );
  }
}

class _BlocWalletAccountSummary extends StatelessWidget {
  final AccountDetailsSelector accountDetailsSelector;
  final VoidCallback onRetryButtonTap;
  final String successTitle;

  const _BlocWalletAccountSummary({
    required this.accountDetailsSelector,
    required this.onRetryButtonTap,
    required this.successTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      RegistrationCubit,
      RegistrationState,
      Result<AccountSummaryData, LocalizedException>?
    >(
      selector: accountDetailsSelector,
      builder: (context, state) {
        return switch (state) {
          Success<AccountSummaryData, LocalizedException>(:final value) => _AccountSummary(
            account: value,
            successTitle: successTitle,
          ),
          Failure<AccountSummaryData, LocalizedException>(:final value) => _AccountFailure(
            exception: value,
            onRetryButtonTap: onRetryButtonTap,
          ),
          _ => const Center(child: VoicesCircularProgressIndicator()),
        };
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
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
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
  final VoidCallback onNextButtonTap;
  final VoidCallback onBackButtonTap;
  final String nextButtonTitle;
  final String backButtonTitle;

  const _Navigation({
    this.isNextEnabled = false,
    required this.onNextButtonTap,
    required this.onBackButtonTap,
    required this.nextButtonTitle,
    required this.backButtonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VoicesFilledButton(
          key: const Key('NextButton'),
          onTap: isNextEnabled ? onNextButtonTap : null,
          child: Text(
            nextButtonTitle,
            semanticsIdentifier: 'accountDetailsNextAction',
          ),
        ),
        const SizedBox(height: 10),
        VoicesTextButton(
          key: const Key('BackButton'),
          onTap: onBackButtonTap,
          child: Text(backButtonTitle),
        ),
      ],
    );
  }
}

class _SuccessTitle extends StatelessWidget {
  final String successTitle;

  const _SuccessTitle(this.successTitle);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final textColor = colors.textOnPrimaryLevel0;
    final iconColor = colors.success;

    return Row(
      spacing: 8,
      children: [
        VoicesAssets.icons.checkCircle.buildIcon(color: iconColor),
        Expanded(
          child: Text(
            key: const Key('SuccessTitle'),
            successTitle,
            style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
          ),
        ),
      ],
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
          child: DefaultTextStyle(style: textStyle, child: value),
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
        border: Border.all(width: 1.5, color: Theme.of(context).colors.outlineBorderVariant),
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
                  Flexible(child: Text(address, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  if (clipboardAddress != null)
                    VoicesClipboardIconButton(clipboardData: clipboardAddress.toBech32()),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _SummaryDetails(label: Text(context.l10n.balance), value: Text(balance)),
          ),
          if (clipboardAddress != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _CheckOnCardanoScanButton(address: clipboardAddress),
            ),
        ],
      ),
    );
  }
}
