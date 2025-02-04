import 'dart:async';

import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionLockButton extends StatelessWidget {
  const SessionLockButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      key: const Key('LockButton'),
      onTap: () => unawaited(context.read<SessionCubit>().lock()),
      leading: VoicesAssets.icons.lockClosed.buildIcon(),
      child: Text(context.l10n.lock),
    );
  }
}
