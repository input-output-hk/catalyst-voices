import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/pages/workspace/header/workspace_header.dart';
import 'package:catalyst_voices/pages/workspace/my_proposals/workspace_my_proposals_selector.dart';
import 'package:catalyst_voices/pages/workspace/page/workspace_empty.dart';
import 'package:catalyst_voices/pages/workspace/page/workspace_error.dart';
import 'package:catalyst_voices/pages/workspace/page/workspace_loading.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage>
    with ErrorHandlerStateMixin<WorkspaceBloc, WorkspacePage> {
  StreamSubscription<dynamic>? _importedProposalSub;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          WorkspaceHeader(),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                WorkspaceMyProposalsSelector(),
                WorkspaceLoadingSelector(),
                WorkspaceEmptyStateSelector(),
                WorkspaceErrorSelector(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_importedProposalSub?.cancel());
    _importedProposalSub = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final bloc = context.read<WorkspaceBloc>();

    // ignore: cascade_invocations
    bloc.add(const LoadProposalsEvent());

    _importedProposalSub =
        bloc.stream.map((e) => e.importedProposalRef).listen(_onImportProposal);
  }

  void _onImportProposal(DocumentRef? ref) {
    if (ref != null) {
      unawaited(ProposalBuilderRoute(proposalId: ref.id).push(context));
    }
  }
}
