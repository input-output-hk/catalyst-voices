import 'package:catalyst_voices/pages/spaces/drawer/spaces_drawer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpacesShellPage extends StatelessWidget {
  final Space space;
  final Widget child;

  const SpacesShellPage({
    super.key,
    required this.space,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final sessionBloc = context.watch<SessionBloc>();
    final isVisitor = sessionBloc.state is VisitorSessionState;
    final isUnlocked = sessionBloc.state is ActiveUserSessionState;

    return Scaffold(
      appBar: VoicesAppBar(
        leading: isVisitor ? null : const DrawerToggleButton(),
        automaticallyImplyLeading: false,
        actions: const [
          SessionActionHeader(),
          SessionStateHeader(),
        ],
      ),
      drawer: isVisitor
          ? null
          : SpacesDrawer(
              space: space,
              isUnlocked: isUnlocked,
            ),
      body: child,
    );
  }
}
