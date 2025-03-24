import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/workspace/header/workspace_header.dart';
import 'package:catalyst_voices/pages/workspace/page/workspace_error.dart';
import 'package:catalyst_voices/pages/workspace/page/workspace_loading.dart';
import 'package:catalyst_voices/pages/workspace/page/workspace_user_proposals.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage>
    with
        SignalHandlerStateMixin<WorkspaceBloc, WorkspaceSignal, WorkspacePage>,
        ErrorHandlerStateMixin<WorkspaceBloc, WorkspacePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            WorkspaceHeader(),
            Stack(
              children: [
                WorkspaceErrorSelector(),
                WorkspaceLoadingSelector(),
                WorkspaceUserProposalsSelector(),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  @override
  void handleError(Object error) {
    if (error is LocalizedProposalDeletionException) {
      _showDeleteErrorSnackBar();
    } else {
      super.handleError(error);
    }
  }

  @override
  void handleSignal(WorkspaceSignal signal) {
    switch (signal) {
      case ImportedProposalWorkspaceSignal():
        unawaited(
          ProposalBuilderRoute.fromRef(ref: signal.proposalRef).push(context),
        );
      case DeletedDraftWorkspaceSignal():
        _showDeleteSuccessSnackBar();
      case OpenProposalBuilderSignal():
        unawaited(
          ProposalBuilderRoute.fromRef(ref: signal.ref).push(context),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    final bloc = context.read<WorkspaceBloc>();
    // ignore: cascade_invocations
    bloc.add(const WatchUserProposalsEvent());
  }

  void _showDeleteErrorSnackBar() {
    VoicesSnackBar.hideCurrent(context);

    VoicesSnackBar(
      type: VoicesSnackBarType.error,
      behavior: SnackBarBehavior.floating,
      title: context.l10n.errorProposalDeleted,
      message: context.l10n.errorProposalDeletedDescription,
    ).show(context);
  }

  void _showDeleteSuccessSnackBar() {
    VoicesSnackBar.hideCurrent(context);

    VoicesSnackBar(
      type: VoicesSnackBarType.success,
      behavior: SnackBarBehavior.floating,
      title: context.l10n.successProposalDeleted,
      message: context.l10n.successProposalDeletedDescription,
    ).show(context);
  }
}
