import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/account/verification_email_send_dialog.dart';
import 'package:catalyst_voices/pages/account/widgets/account_action_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_email_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_header_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_keychain_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_page_title.dart';
import 'package:catalyst_voices/pages/account/widgets/account_roles_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_status_banner.dart';
import 'package:catalyst_voices/pages/account/widgets/account_username_tile.dart';
import 'package:catalyst_voices/pages/spaces/appbar/session_action_header.dart';
import 'package:catalyst_voices/pages/spaces/appbar/session_state_header.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          SessionActionHeader(),
          SessionStateHeader(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AccountStatusBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const AccountPageTitle(
                  key: Key('AccountPageTitle'),
                ),
                const SizedBox(height: 42),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: AccountHeaderTile()),
                    SizedBox(width: 28),
                    Expanded(child: AccountActionTile()),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          AccountUsernameTile(),
                          AccountEmailTile(),
                        ].separatedBy(const SizedBox(height: 20)).toList(),
                      ),
                    ),
                    const SizedBox(width: 28),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          AccountRolesTile(),
                          AccountKeychainTile(
                            key: Key('AccountKeychainTile'),
                          ),
                        ].separatedBy(const SizedBox(height: 20)).toList(),
                      ),
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
    }
  }

  @override
  void initState() {
    super.initState();

    unawaited(context.read<AccountCubit>().updateAccountDetails());
  }

  void _showVerificationEmailSendDialog() {
    unawaited(VerificationEmailSendDialog.show(context));
  }
}
