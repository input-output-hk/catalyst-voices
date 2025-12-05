import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class MostRecentOffstage extends StatelessWidget {
  final Widget child;

  const MostRecentOffstage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, bool>(
      selector: (state) => !state.proposals.showSection,
      builder: (context, state) => Offstage(offstage: state, child: child),
    );
  }
}
