import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/proposal_submission_phase_aware.dart';
import 'package:catalyst_voices/pages/workspace/page/workspace_error.dart';
import 'package:catalyst_voices/pages/workspace/page/workspace_loading.dart';
import 'package:catalyst_voices/pages/workspace/submission_closing_warning_dialog.dart';
import 'package:catalyst_voices/pages/workspace/widgets/header/workspace_header.dart';
import 'package:catalyst_voices/pages/workspace/widgets/workspace_content.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/snackbar/common_snackbars.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices/widgets/tabbar/voices_tab_controller.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WorkspacePage extends StatefulWidget {
  final WorkspacePageTab? tab;

  const WorkspacePage({super.key, this.tab});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage>
    with
        TickerProviderStateMixin,
        SignalHandlerStateMixin<WorkspaceBloc, WorkspaceSignal, WorkspacePage>,
        ErrorHandlerStateMixin<WorkspaceBloc, WorkspacePage> {
  late VoicesTabController<WorkspacePageTab> _tabController;

  @override
  Widget build(BuildContext context) {
    return ProposalSubmissionPhaseAware(
      activeChild: Scaffold(
        body: WorkspaceLoading(
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),
              const SliverToBoxAdapter(
                child: WorkspaceHeader(),
              ),
              const SliverToBoxAdapter(
                child: WorkspaceError(),
              ),
              WorkspaceContent(tabController: _tabController),
              const SliverToBoxAdapter(
                child: SizedBox(height: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(WorkspacePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final tab = widget.tab ?? WorkspacePageTab.proposals;

    if (widget.tab != oldWidget.tab) {
      _tabController.animateToTab(tab);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      case ChangeTabWorkspaceSignal(:final tab):
        _updateRoute(tab: tab);
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
      case SubmissionCloseDate():
        unawaited(_showSubmissionClosingWarningDialog(signal.date));
      case ForgetProposalSuccessWorkspaceSignal():
        _showForgetSuccessSnackBar();
    }
  }

  @override
  void initState() {
    super.initState();
    final bloc = context.read<WorkspaceBloc>();
    // ignore: cascade_invocations
    bloc
      ..add(const WatchUserCatalystIdEvent())
      ..add(const WatchUserProposalsEvent())
      ..add(const GetTimelineItemsEvent());

    final selectedTab = _determineTab(widget.tab);

    _tabController = VoicesTabController(
      initialTab: selectedTab,
      tabs: WorkspacePageTab.values,
      vsync: this,
    );
  }

  WorkspacePageTab _determineTab(WorkspacePageTab? initialTab) {
    return initialTab ?? widget.tab ?? WorkspacePageTab.proposals;
  }

  void _dontShowCampaignSubmissionClosingDialog(bool value) {
    context.read<SessionCubit>().updateShowSubmissionClosingWarning(value: !value);
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

  void _showForgetSuccessSnackBar() {
    CommonSnackbars.showForgetProposalSuccessDialog(context);
  }

  Future<void> _showSubmissionClosingWarningDialog([
    DateTime? submissionCloseDate,
  ]) async {
    final canShow = context.read<SessionCubit>().state.settings.showSubmissionClosingWarning;

    if (submissionCloseDate == null || !canShow || !mounted) {
      return;
    }
    await SubmissionClosingWarningDialog.showNDaysBefore(
      context: context,
      submissionCloseAt: submissionCloseDate,
      dontShowAgain: _dontShowCampaignSubmissionClosingDialog,
    );
  }

  void _updateRoute({
    WorkspacePageTab? tab,
  }) {
    Router.neglect(context, () {
      final effectiveTab = tab ?? widget.tab;

      WorkspaceRoute(
        tab: effectiveTab?.name,
      ).replace(context);
    });
  }
}
