import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
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
import 'package:url_launcher/url_launcher.dart';

class RbacTransactionPanel extends StatefulWidget {
  final bool isDrepLink;

  const RbacTransactionPanel({
    super.key,
    this.isDrepLink = false,
  });

  @override
  State<RbacTransactionPanel> createState() => _RbacTransactionPanelState();
}

class _BlocSubmitTxButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const _BlocSubmitTxButton({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return BlocRegistrationSelector<bool>(
      selector: (state) => state.isSubmittingTx,
      builder: (context, isLoading) {
        return VoicesFilledButton(
          leading: VoicesAssets.icons.wallet.buildIcon(),
          onTap: onSubmit,
          trailing: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: VoicesCircularProgressIndicator(),
                )
              : null,
          child: Text(
            context.l10n.walletLinkTransactionSign,
            semanticsIdentifier: 'SignTransactionButton',
          ),
        );
      },
    );
  }
}

class _BlocSummary extends StatelessWidget {
  final bool isDrepLink;

  const _BlocSummary({required this.isDrepLink});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      RegistrationCubit,
      RegistrationState,
      ({Set<AccountRole> roles, WalletInfo selectedWallet, String transactionFee})?
    >(
      selector: (state) {
        final selectedWallet = state.walletLinkStateData.selectedWallet;
        final transactionFee = state.registrationStateData.transactionFee;
        final selectedRoles = state.walletLinkStateData.selectedRoleTypes;
        if (selectedWallet == null || transactionFee == null) {
          return null;
        }

        return (
          roles: selectedRoles,
          selectedWallet: selectedWallet,
          transactionFee: transactionFee,
        );
      },
      builder: (context, state) {
        if (state == null) {
          return const _SummaryPlaceholder();
        }

        return _Summary(
          roles: state.roles,
          walletInfo: state.selectedWallet,
          transactionFee: state.transactionFee,
          isDrepLink: isDrepLink,
        );
      },
    );
  }
}

class _BlocTransactionDetails extends StatelessWidget {
  final VoidCallback onRefreshTap;
  final bool isDrepLink;

  const _BlocTransactionDetails({
    required this.onRefreshTap,
    required this.isDrepLink,
  });

  @override
  Widget build(BuildContext context) {
    return BlocRegistrationSelector(
      selector: (state) => state.canSubmitTx,
      builder: (context, result) {
        return switch (result) {
          Success() => _TransactionDetails(isDrepLink: isDrepLink),
          Failure(:final value) => _Error(error: value, onRetry: onRefreshTap),
          _ => const Center(child: VoicesCircularProgressIndicator()),
        };
      },
    );
  }
}

class _BlocTxSubmitError extends StatelessWidget {
  const _BlocTxSubmitError();

  @override
  Widget build(BuildContext context) {
    return BlocRegistrationSelector(
      selector: (state) => state.canSubmitTx,
      builder: (context, result) {
        return switch (result) {
          Failure(:final value) => _Error(
            error: value,
            onRetry: () => _onRetry(context),
          ),
          _ => const Offstage(),
        };
      },
    );
  }

  void _onRetry(BuildContext context) {
    unawaited(RegistrationCubit.of(context).finishRegistration());
  }
}

class _Error extends StatelessWidget {
  final LocalizedException error;
  final VoidCallback onRetry;

  const _Error({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        width: double.infinity,
        child: VoicesErrorIndicator(
          message: error.message(context),
          onRetry: onRetry,
        ),
      ),
    );
  }
}

class _ErrorNavigation extends StatelessWidget {
  const _ErrorNavigation();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VoicesOutlinedButton(
          key: const Key('BackToWalletSelectionButton'),
          onTap: () => RegistrationCubit.of(context).chooseOtherWallet(),
          child: Text(context.l10n.walletLinkTransactionBackToWalletSelection),
        ),
        const SizedBox(height: 10),
        VoicesTextButton(
          key: const Key('SeeAllSupportedWalletsButton'),
          trailing: VoicesAssets.icons.externalLink.buildIcon(),
          onTap: () async => _launchSupportedWalletsLink(),
          child: Text(context.l10n.seeAllSupportedWallets),
        ),
      ],
    );
  }

  Future<void> _launchSupportedWalletsLink() async {
    final url = VoicesConstants.officiallySupportedWalletsUrl.getUri();
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

class _Navigation extends StatelessWidget {
  final bool showChangeRolesButton;

  const _Navigation({required this.showChangeRolesButton});

  @override
  Widget build(BuildContext context) {
    return BlocRegistrationSelector<bool>(
      selector: (state) => state.canSubmitTx?.isFailure ?? true,
      builder: (context, isFailure) {
        if (isFailure) {
          return const _ErrorNavigation();
        } else {
          return _SuccessNavigation(showChangeRolesButton: showChangeRolesButton);
        }
      },
    );
  }
}

class _RbacTransactionPanelState extends State<RbacTransactionPanel> {
  @override
  Widget build(BuildContext context) {
    return RegistrationDetailsPanelScaffold(
      title: const _Title(),
      body: _BlocTransactionDetails(
        onRefreshTap: _onRefresh,
        isDrepLink: widget.isDrepLink,
      ),
      footer: _Navigation(showChangeRolesButton: !widget.isDrepLink),
    );
  }

  @override
  void initState() {
    super.initState();
    unawaited(RegistrationCubit.of(context).prepareRegistration());
  }

  void _onRefresh() {
    unawaited(RegistrationCubit.of(context).prepareRegistration());
  }
}

class _SuccessNavigation extends StatelessWidget {
  final bool showChangeRolesButton;

  const _SuccessNavigation({required this.showChangeRolesButton});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BlocSubmitTxButton(
          onSubmit: () => _submitRegistration(context),
        ),
        if (showChangeRolesButton) ...[
          const SizedBox(height: 10),
          VoicesTextButton(
            leading: VoicesAssets.icons.wallet.buildIcon(),
            onTap: () {
              RegistrationCubit.of(context).changeRoleSetup();
            },
            child: Text(
              context.l10n.walletLinkTransactionChangeRoles,
              semanticsIdentifier: 'TransactionReviewChangeRolesButton',
            ),
          ),
        ],
      ],
    );
  }

  void _submitRegistration(BuildContext context) {
    unawaited(RegistrationCubit.of(context).finishRegistration());
  }
}

class _Summary extends StatelessWidget {
  final Set<AccountRole> roles;
  final WalletInfo walletInfo;
  final String transactionFee;
  final bool isDrepLink;

  const _Summary({
    required this.roles,
    required this.walletInfo,
    required this.transactionFee,
    required this.isDrepLink,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isDrepLink
                ? context.l10n.walletLinkTransactionToKeychain
                : context.l10n.walletLinkTransactionAccountCompletion,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (isDrepLink) ...[
            const SizedBox(height: 12),
            Text(
              context.l10n.walletLinkTransactionDrepRole,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ] else ...[
            const SizedBox(height: 12),
            Text(
              context.l10n.walletLinkTransactionLinkItem(walletInfo.metadata.name.capitalize()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            for (final role in roles) ...[
              const SizedBox(height: 12),
              Text(
                context.l10n.walletLinkTransactionRoleItem(
                  role.getName(context).toLowerCase(),
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.total,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                transactionFee,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryPlaceholder extends StatelessWidget {
  const _SummaryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          context.l10n.walletLinkTransactionTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          context.l10n.walletLinkTransactionSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _TransactionDetails extends StatelessWidget {
  final bool isDrepLink;

  const _TransactionDetails({required this.isDrepLink});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BlocSummary(isDrepLink: isDrepLink),
        const _BlocTxSubmitError(),
      ],
    );
  }
}
