import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionAccountPopupCatalystId extends StatelessWidget {
  const SessionAccountPopupCatalystId({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, String>(
      selector: (state) => state.account?.catalystId ?? '',
      builder: (context, state) {
        return CatalystIdText(state, isCompact: true);
      },
    );
  }
}
