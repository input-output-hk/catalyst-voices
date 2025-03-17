import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/pages/workspace/header/workspace_header.dart';
import 'package:catalyst_voices/pages/workspace/my_proposals/my_proposals.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            WorkspaceHeader(),
            MyProposals(),
          ],
        ),
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
    // ignore: cascade_invocations
    bloc.add(const WatchUserProposalsEvent());

    _importedProposalSub =
        bloc.stream.map((e) => e.importedProposalRef).listen(_onImportProposal);
  }

  void _onImportProposal(DocumentRef? ref) {
    if (ref != null) {
      unawaited(
        ProposalBuilderRoute(
          proposalId: ref.id,
          version: ref.version,
          isPrivate: DocumentRef is DraftRef,
        ).push(context),
      );
    }
  }
}
