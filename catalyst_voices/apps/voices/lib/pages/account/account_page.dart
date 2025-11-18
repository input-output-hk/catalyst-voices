import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/account/delete_keychain_dialog.dart';
import 'package:catalyst_voices/pages/account/keychain_deleted_dialog.dart';
import 'package:catalyst_voices/pages/account/pending_email_change_dialog.dart';
import 'package:catalyst_voices/pages/account/verification_email_send_dialog.dart';
import 'package:catalyst_voices/pages/account/widgets/account_email_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_header_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_keychain_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_page_grid.dart';
import 'package:catalyst_voices/pages/account/widgets/account_page_title.dart';
import 'package:catalyst_voices/pages/account/widgets/account_roles_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_username_tile.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/account_settings_action.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/session_cta_action.dart';
import 'package:catalyst_voices/pages/spaces/drawer/opportunities_drawer.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

final class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with
        ErrorHandlerStateMixin<AccountCubit, AccountPage>,
        SignalHandlerStateMixin<AccountCubit, AccountSignal, AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VoicesAppBar(
        automaticallyImplyLeading: false,
        actions: [
          SessionCtaAction(),
          AccountSettingsAction(),
        ],
      ),
      endDrawer: const OpportunitiesDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const AccountPageTitle(key: Key('AccountPageTitle')),
                ResponsiveChild(
                  xs: const SizedBox(height: 18),
                  sm: const SizedBox(height: 42),
                ),
                const AccountPageGrid(
                  key: ValueKey('AccountOverviewGrid'),
                  children: [
                    AccountHeaderTile(),
                    Spacer(),
                  ],
                ),
                ResponsiveChild(
                  xs: const SizedBox(height: 18),
                  sm: const SizedBox(height: 40),
                ),
                AccountPageGrid(
                  key: const ValueKey('AccountDetailsGrid'),
                  children: [
                    const AccountUsernameTile(),
                    const AccountRolesTile(),
                    const AccountEmailTile(),
                    AccountKeychainTile(
                      key: const Key('AccountKeychainTile'),
                      onRemoveTap: _removeActiveKeychain,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void handleSignal(AccountSignal signal) {
    switch (signal) {
      case AccountVerificationEmailSendSignal():
        _showVerificationEmailSendDialog();
      case PendingEmailChangeSignal():
        _showPendingEmailChangeDialog();
    }
  }

  @override
  void initState() {
    super.initState();

    unawaited(context.read<AccountCubit>().updateAccountDetails());
  }

  Future<void> _removeActiveKeychain() async {
    final confirmed = await DeleteKeychainDialog.show(context);
    if (!confirmed) {
      return;
    }

    if (mounted) {
      await context.read<AccountCubit>().deleteActiveKeychain();
    }

    if (mounted) {
      unawaited(KeychainDeletedDialog.show(context));

      // TODO(damian-molinski): refactor it. Should be inside AccountCubit and emit signals to page.
      final phaseType = context.read<CampaignPhaseAwareCubit>().state.activeCampaignPhaseType;

      switch (phaseType) {
        case CampaignPhaseType.communityReview:
        case CampaignPhaseType.communityVoting:
          final isVotingEnabled = context.read<FeatureFlagsCubit>().state.isEnabled(
            Features.voting,
          );
          if (isVotingEnabled) {
            const VotingRoute.keychainDeleted().go(context);
          } else {
            const DiscoveryRoute.keychainDeleted().go(context);
          }
        case null:
        case CampaignPhaseType.proposalSubmission:
        case CampaignPhaseType.votingRegistration:
        case CampaignPhaseType.reviewRegistration:
        case CampaignPhaseType.votingResults:
        case CampaignPhaseType.projectOnboarding:
          const DiscoveryRoute.keychainDeleted().go(context);
      }
    }
  }

  void _showPendingEmailChangeDialog() {
    unawaited(PendingEmailChangeDialog.show(context));
  }

  void _showVerificationEmailSendDialog() {
    unawaited(VerificationEmailSendDialog.show(context));
  }
}
