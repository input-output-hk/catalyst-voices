import 'package:catalyst_voices/common/utils/access_control_util.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/discovery_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/funded_projects_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/treasury_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/voting_overview.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/workspace_overview.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpacesListView extends StatefulWidget {
  const SpacesListView({
    super.key,
  });

  @override
  State<SpacesListView> createState() => _SpacesListViewState();
}

class _SpacesListViewState extends State<SpacesListView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VoicesScrollbar(
      controller: _scrollController,
      alwaysVisible: true,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: BlocSelector<SessionCubit, SessionState, Account?>(
        selector: (state) {
          if (state is ActiveAccountSessionState) {
            return state.account;
          }
          return null;
        },
        builder: (context, state) {
          final spaces = AccessControlUtil.overallSpaces(state);
          return ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16, bottom: 24),
            itemBuilder: (context, index) {
              final space = spaces[index];
              return switch (space) {
                Space.discovery => DiscoveryOverview(key: ObjectKey(space)),
                Space.workspace => WorkspaceOverview(key: ObjectKey(space)),
                Space.voting =>
                  GreyOut(child: VotingOverview(key: ObjectKey(space))),
                Space.fundedProjects =>
                  GreyOut(child: FundedProjectsOverview(key: ObjectKey(space))),
                Space.treasury => Offstage(
                    offstage: false,
                    child: TreasuryOverview(
                      key: ObjectKey(space),
                    ),
                  ),
              };
            },
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemCount: spaces.length,
          );
        },
      ),
    );
  }
}

class GreyOut extends StatelessWidget {
  final Widget child;
  final bool greyOut;

  const GreyOut({
    super.key,
    required this.child,
    this.greyOut = true,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: greyOut,
      child: Opacity(
        opacity: greyOut ? 0.5 : 1,
        child: child,
      ),
    );
  }
}
