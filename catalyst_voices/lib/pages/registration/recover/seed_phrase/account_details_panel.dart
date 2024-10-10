import 'dart:async';

import 'package:catalyst_voices/pages/registration/recover/bloc_recover_builder.dart';
import 'package:catalyst_voices/pages/registration/widgets/wallet_connection_status.dart';
import 'package:catalyst_voices/pages/registration/widgets/wallet_summary.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices/widgets/indicators/voices_error_indicator.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
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
          context.l10n.recoveryAccountTitle,
          style: theme.textTheme.titleMedium?.copyWith(color: textColor),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: _BlocAccountSummery(
              onRetry: () => unawaited(retryAccountRestore(context)),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const _BlocNavigation(),
      ],
    );
  }

  Future<void> retryAccountRestore(BuildContext context) async {
    final recover = RegistrationCubit.of(context).recover;
    await recover.recoverAccount();
  }
}

class _BlocAccountSummery extends StatelessWidget {
  final VoidCallback? onRetry;

  const _BlocAccountSummery({
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return BlocRecoverBuilder<Result<AccountSummaryData, LocalizedException>?>(
      selector: (state) => state.accountDetails,
      builder: (context, state) {
        return switch (state) {
          Success<AccountSummaryData, LocalizedException>(:final value) =>
            _RecoveredAccountSummary(
              walletConnection: value.walletConnection,
              walletSummary: value.walletSummary,
            ),
          Failure<AccountSummaryData, LocalizedException>(:final value) =>
            _RecoverAccountFailure(
              exception: value,
              onRetry: onRetry,
            ),
          _ => const Center(child: VoicesCircularProgressIndicator()),
        };
      },
    );
  }
}

class _RecoveredAccountSummary extends StatelessWidget {
  final WalletConnectionData walletConnection;
  final WalletSummaryData walletSummary;

  const _RecoveredAccountSummary({
    required this.walletConnection,
    required this.walletSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WalletConnectionStatus(
          icon: walletConnection.icon,
          name: walletConnection.name,
          isConnected: walletConnection.isConnected,
        ),
        const SizedBox(height: 8),
        const _RecoverStatusText(),
        const SizedBox(height: 24),
        WalletSummary(
          balance: walletSummary.balance,
          address: walletSummary.address,
          clipboardAddress: walletSummary.clipboardAddress,
        ),
      ],
    );
  }
}

class _RecoverAccountFailure extends StatelessWidget {
  final LocalizedException exception;
  final VoidCallback? onRetry;

  const _RecoverAccountFailure({
    required this.exception,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VoicesErrorIndicator(
          message: exception.message(context),
          onRetry: onRetry,
        ),
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
      context.l10n.recoveryAccountSuccessTitle,
      style: theme.textTheme.titleMedium?.copyWith(color: textColor),
    );
  }
}

class _BlocNavigation extends StatelessWidget {
  const _BlocNavigation();

  @override
  Widget build(BuildContext context) {
    return BlocRecoverBuilder<bool>(
      selector: (state) => state.isAccountSummaryNextEnabled,
      builder: (context, state) {
        return _Navigation(
          isNextEnabled: state,
        );
      },
    );
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
        VoicesFilledButton(
          onTap: isNextEnabled
              ? () => RegistrationCubit.of(context).nextStep()
              : null,
          child: Text(context.l10n.recoveryAccountDetailsAction),
        ),
        const SizedBox(height: 10),
        VoicesTextButton(
          onTap: () => RegistrationCubit.of(context).previousStep(),
          child: Text(context.l10n.back),
        ),
      ],
    );
  }
}
