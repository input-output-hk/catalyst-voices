import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SessionAccountCatalystId extends StatelessWidget {
  const SessionAccountCatalystId({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, CatalystId?>(
      selector: (state) => state.account?.catalystId,
      builder: (context, catalystId) {
        if (catalystId == null) {
          return const SizedBox.shrink();
        }

        return CatalystIdText(
          catalystId,
          isCompact: true,
          showLabel: true,
        );
      },
    );
  }
}
