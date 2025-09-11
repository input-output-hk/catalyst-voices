import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/account/pending_email_change_dialog.dart';
import 'package:catalyst_voices/pages/account/verification_email_send_dialog.dart';
import 'package:catalyst_voices/pages/account/widgets/account_action_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_email_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_header_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_keychain_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_page_grid.dart';
import 'package:catalyst_voices/pages/account/widgets/account_page_title.dart';
import 'package:catalyst_voices/pages/account/widgets/account_roles_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_status_banner.dart';
import 'package:catalyst_voices/pages/account/widgets/account_username_tile.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/account_settings_action.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/session_cta_action.dart';
import 'package:catalyst_voices/pages/spaces/drawer/opportunities_drawer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
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
          const AccountStatusBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: const [
                AccountPageTitle(key: Key('AccountPageTitle')),
                SizedBox(height: 42),
                AccountPageGrid(
                  key: ValueKey('AccountOverviewGrid'),
                  children: [
                    AccountHeaderTile(),
                    AccountActionTile(),
                  ],
                ),
                SizedBox(height: 40),
                AccountPageGrid(
                  key: ValueKey('AccountDetailsGrid'),
                  children: [
                    AccountUsernameTile(),
                    AccountRolesTile(),
                    AccountEmailTile(),
                    AccountKeychainTile(key: Key('AccountKeychainTile')),
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

  void _showPendingEmailChangeDialog() {
    unawaited(PendingEmailChangeDialog.show(context));
  }

  void _showVerificationEmailSendDialog() {
    unawaited(VerificationEmailSendDialog.show(context));
  }
}
