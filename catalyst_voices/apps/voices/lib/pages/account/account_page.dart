import 'dart:async';

import 'package:catalyst_voices/pages/account/delete_keychain_dialog.dart';
import 'package:catalyst_voices/pages/account/keychain_deleted_dialog.dart';
import 'package:catalyst_voices/routes/routes.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [],
        ),
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
