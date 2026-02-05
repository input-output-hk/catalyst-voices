import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SessionAccountCatalystId extends StatelessWidget {
  final EdgeInsets padding;
  final bool isCompact;
  final bool showLabel;
  final double labelGap;
  final String? labelText;

  const SessionAccountCatalystId({
    super.key,
    this.padding = EdgeInsets.zero,
    this.isCompact = true,
    this.showLabel = true,
    this.labelGap = 0,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, CatalystId?>(
      selector: (state) => state.account?.catalystId,
      builder: (context, catalystId) {
        if (catalystId == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: padding,
          child: CatalystIdText(
            catalystId,
            isCompact: isCompact,
            showLabel: showLabel,
            labelGap: labelGap,
            labelText: labelText,
          ),
        );
      },
    );
  }
}
