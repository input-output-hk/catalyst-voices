import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountKeychainTile extends StatefulWidget {
  const AccountKeychainTile({super.key});

  @override
  State<AccountKeychainTile> createState() => _AccountKeychainTileState();
}

class _AccountKeychainTileState extends State<AccountKeychainTile> {
  late final TextEditingController _controller;

  StreamSubscription<String>? _sub;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<AccountCubit>();
    final text = bloc.state.walletConnected;

    _controller = TextEditingController(text: text);

    _sub = bloc.stream
        .map((event) => event.walletConnected)
        .distinct()
        .listen((event) => _controller.text = event);
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    _sub = null;

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PropertyTile(
      title: context.l10n.catalystKeychain,
      action: VoicesTextButton.danger(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(context.textTheme.labelSmall),
        ),
        onTap: () {},
        child: Text(context.l10n.removeKeychain),
      ),
      child: VoicesTextField(
        controller: _controller,
        onFieldSubmitted: null,
        readOnly: true,
        minLines: 1,
        maxLines: 3,
      ),
    );
  }
}
