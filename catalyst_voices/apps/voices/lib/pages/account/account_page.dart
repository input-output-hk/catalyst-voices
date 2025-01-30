import 'dart:async';

import 'package:catalyst_voices/pages/account/delete_keychain_dialog.dart';
import 'package:catalyst_voices/pages/account/keychain_deleted_dialog.dart';
import 'package:catalyst_voices/pages/account/widgets/account_action_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_display_name_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_email_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_header_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_keychain_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_page_title.dart';
import 'package:catalyst_voices/pages/account/widgets/account_roles_tile.dart';
import 'package:catalyst_voices/pages/account/widgets/account_status_banner.dart';
import 'package:catalyst_voices/routes/routes.dart';
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

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoicesAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Offstage(child: AccountStatusBanner()),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                AccountPageTitle(),
                SizedBox(height: 42),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: AccountHeaderTile()),
                    SizedBox(width: 28),
                    Expanded(child: Offstage(child: AccountActionTile()))
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AccountDisplayNameTile(),
                          AccountEmailTile(),
                        ].separatedBy(SizedBox(height: 20)).toList(),
                      ),
                    ),
                    SizedBox(width: 28),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AccountRolesTile(),
                          AccountKeychainTile(),
                        ].separatedBy(SizedBox(height: 20)).toList(),
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

  Future<void> _removeKeychain() async {
    final confirmed = await DeleteKeychainDialog.show(context);
    if (!confirmed) {
      return;
    }

    if (mounted) {
      await context.read<SessionCubit>().removeKeychain();
    }

    if (mounted) {
      await KeychainDeletedDialog.show(context);
    }

    if (mounted) {
      const DiscoveryRoute().go(context);
    }
  }
}
