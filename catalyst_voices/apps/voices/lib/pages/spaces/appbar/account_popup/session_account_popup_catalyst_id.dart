import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SessionAccountPopupCatalystId extends StatelessWidget {
  const SessionAccountPopupCatalystId({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, CatalystId?>(
      selector: (state) => state.account?.catalystId,
      builder: (context, state) {
        if (state == null) {
          return const Offstage();
        }
        return CatalystIdText(state, isCompact: true);
      },
    );
  }
}
