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
          AccountStatusBanner(),
          Expanded(
            child: ColoredBox(
              color: Colors.green,
              child: ListView(
                padding: EdgeInsets.all(24),
                children: [
                  AccountPageTitle(),
                  Row(
                    children: [
                      Expanded(child: AccountHeaderTile()),
                      Expanded(child: AccountActionTile())
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AccountDisplayNameTile(),
                            AccountEmailTile(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AccountRolesTile(),
                            AccountKeychainTile(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
