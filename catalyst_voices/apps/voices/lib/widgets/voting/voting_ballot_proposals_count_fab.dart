import 'dart:async';

import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingBallotProposalsCountFab extends StatelessWidget {
  const VotingBallotProposalsCountFab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingBallotBloc, VotingBallotState, VotingBallotBuilderFabViewModel>(
      selector: (state) => state.fab,
      builder: (context, state) => _VotingBallotProposalsCountFab(data: state),
    );
  }
}

class _VotingBallotProposalsCountFab extends StatelessWidget {
  final VotingBallotBuilderFabViewModel data;

  const _VotingBallotProposalsCountFab({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !data.isVisible,
      child: VotesCountFloatingActionButton(
        count: data.count,
        useGradient: data.useGradient,
        onTap: () {
          unawaited(const VotingListRoute().push(context));
        },
      ),
    );
  }
}
