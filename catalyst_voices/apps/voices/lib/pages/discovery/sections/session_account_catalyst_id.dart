import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

typedef _AccountSessionData = ({CatalystId? catalystId, bool isUnlock});

class SessionAccountCatalystId extends StatelessWidget {
  final EdgeInsets padding;

  const SessionAccountCatalystId({
    super.key,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, _AccountSessionData>(
      selector: (state) => (catalystId: state.account?.catalystId, isUnlock: state.isActive),
      builder: (context, data) {
        if (data.catalystId == null) {
          return const SizedBox.shrink();
        }

        return Offstage(
          offstage: !data.isUnlock,
          child: Padding(
            padding: padding,
            child: CatalystIdText(
              data.catalystId!,
              isCompact: true,
              showLabel: true,
              labelGap: 0,
            ),
          ),
        );
      },
    );
  }
}
