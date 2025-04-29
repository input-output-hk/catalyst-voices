import 'dart:async';

import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/widgets.dart';

class AccountReSendVerificationButton extends StatelessWidget {
  const AccountReSendVerificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () => unawaited(context.read<AccountCubit>().resendVerification()),
      child: Text(context.l10n.reSend),
    );
  }
}
