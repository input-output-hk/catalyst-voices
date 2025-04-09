import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/proposal_builder/appbar/proposal_builder_back_action.dart';
import 'package:catalyst_voices/pages/proposal_builder/appbar/proposal_builder_status_action.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_changing.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_error.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_loading.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_navigation_panel.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_segments.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_setup_panel.dart';
import 'package:catalyst_voices/pages/spaces/appbar/session_state_header.dart';
import 'package:catalyst_voices/pages/workspace/submission_closing_warning_dialog.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/modals/comment/submit_comment_error_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/publish_proposal_error_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/submit_proposal_error_dialog.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_action.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalBuilderPage extends StatefulWidget {
  final DocumentRef? proposalId;
  final SignedDocumentRef? categoryId;

  const ProposalBuilderPage({
    super.key,
    this.proposalId,
    this.categoryId,
  });

  @override
  State<ProposalBuilderPage> createState() => _ProposalBuilderPageState();
}

class _ProposalBuilderContent extends StatelessWidget {
  final ItemScrollController controller;
  final VoidCallback onRetryTap;

  const _ProposalBuilderContent({
    required this.controller,
    required this.onRetryTap,
  });

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProposalBuilderErrorSelector(onRetryTap: onRetryTap),
          ProposalBuilderSegmentsSelector(itemScrollController: controller),
          const ProposalBuilderLoadingSelector(),
        ],
      ),
    );
  }
}

class _ProposalBuilderPageState extends State<ProposalBuilderPage>
    with
        ErrorHandlerStateMixin<ProposalBuilderBloc, ProposalBuilderPage>,
        SignalHandlerStateMixin<ProposalBuilderBloc, ProposalBuilderSignal,
            ProposalBuilderPage> {
  late final SegmentsController _segmentsController;
  late final ItemScrollController _segmentsScrollController;

  StreamSubscription<DocumentRef?>? _proposalRefSub;
  StreamSubscription<dynamic>? _segmentsSub;

  @override
  Widget build(BuildContext context) {
    return ProposalBuilderChangingOverlay(
      child: Scaffold(
        appBar: const VoicesAppBar(
          automaticallyImplyLeading: false,
          actions: [
            ProposalBuilderBackAction(),
            ProposalBuilderStatusAction(),
            SessionStateHeader(),
          ],
        ),
        body: SegmentsControllerScope(
          controller: _segmentsController,
          child: SidebarScaffold(
            leftRail: const ProposalBuilderNavigationPanel(),
            rightRail: const ProposalBuilderSetupPanel(),
            body: _ProposalBuilderContent(
              controller: _segmentsScrollController,
              onRetryTap: _loadData,
            ),
            bodyConstraints: const BoxConstraints.expand(),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(ProposalBuilderPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.proposalId != oldWidget.proposalId ||
        widget.categoryId != oldWidget.categoryId) {
      _loadData();
    }
  }

  @override
  void dispose() {
    _segmentsController.dispose();

    unawaited(_proposalRefSub?.cancel());
    _proposalRefSub = null;

    unawaited(_segmentsSub?.cancel());
    _segmentsSub = null;

    super.dispose();
  }

  @override
  void handleError(Object error) {
    switch (error) {
      case ProposalBuilderValidationException():
        _showValidationErrorSnackbar(error);
      case ProposalBuilderPublishException():
        unawaited(_showPublishException(error));
      case ProposalBuilderSubmitException():
        unawaited(_showSubmitException(error));
      case LocalizedUnknownPublishCommentException():
        unawaited(_showCommentException(error));
      default:
        super.handleError(error);
    }
  }

  @override
  void handleSignal(ProposalBuilderSignal signal) {
    switch (signal) {
      case DeletedProposalBuilderSignal():
        _onProposalDeleted();
      case PublishedProposalBuilderSignal():
      case SubmittedProposalBuilderSignal():
        const WorkspaceRoute().go(context);
      case ProposalSubmissionCloseDate():
        unawaited(_showSubmissionClosingWarningDialog(signal.date));
    }
  }

  @override
  void initState() {
    super.initState();

    final bloc = context.read<ProposalBuilderBloc>();

    _segmentsController = SegmentsController();
    _segmentsScrollController = ItemScrollController();

    _segmentsController
      ..addListener(_handleSegmentsControllerChange)
      ..attachItemsScrollController(_segmentsScrollController);

    _listenForProposalRef(bloc);
    _listenForSegments(bloc);
    _loadData(bloc: bloc);
  }

  void _dontShowCampaignSubmissionClosingDialog(bool value) {
    context
        .read<SessionCubit>()
        .updateShowSubmissionClosingWarning(value: value);
  }

  void _handleSegmentsControllerChange() {
    final activeSectionId = _segmentsController.value.activeSectionId;

    final event = ActiveNodeChangedEvent(activeSectionId);
    context.read<ProposalBuilderBloc>().add(event);
  }

  void _listenForProposalRef(ProposalBuilderBloc bloc) {
    // listen for updates
    _proposalRefSub = bloc.stream
        .map((event) => event.metadata.documentRef)
        .distinct()
        .listen(_onProposalRefChanged);
  }

  void _listenForSegments(ProposalBuilderBloc bloc) {
    // listen for updates
    _segmentsSub = bloc.stream
        .map(
          (event) => (segments: event.allSegments, nodeId: event.activeNodeId),
        )
        .distinct(
          (a, b) => listEquals(a.segments, b.segments) && a.nodeId == b.nodeId,
        )
        .listen((record) => _updateSegments(record.segments, record.nodeId));

    // update with current state
    _updateSegments(bloc.state.allSegments, bloc.state.activeNodeId);
  }

  void _loadData({ProposalBuilderBloc? bloc}) {
    bloc ??= context.read<ProposalBuilderBloc>();

    final proposalId = widget.proposalId;
    final categoryId = widget.categoryId;

    if (proposalId != null) {
      bloc.add(LoadProposalEvent(proposalId: proposalId));
    } else if (categoryId != null) {
      bloc.add(LoadProposalCategoryEvent(categoryId: categoryId));
    } else {
      bloc.add(const LoadDefaultProposalCategoryEvent());
    }
    bloc.add(const ProposalSubmissionCloseDateEvent());
  }

  void _onProposalDeleted() {
    Router.neglect(context, () {
      const WorkspaceRoute().replace(context);
    });
  }

  void _onProposalRefChanged(DocumentRef? ref) {
    if (ref != null) {
      Router.neglect(context, () {
        ProposalBuilderRoute.fromRef(ref: ref).replace(context);
      });
    }
  }

  Future<void> _showCommentException(
    LocalizedUnknownPublishCommentException error,
  ) {
    return SubmitCommentErrorDialog.show(
      context: context,
      exception: error,
    );
  }

  Future<void> _showPublishException(ProposalBuilderPublishException error) {
    return PublishProposalErrorDialog.show(
      context: context,
      exception: error,
    );
  }

  Future<void> _showSubmissionClosingWarningDialog([
    DateTime? submissionCloseDate,
  ]) async {
    final canShow = context
        .read<SessionCubit>()
        .state
        .settings
        .showSubmissionClosingWarning;

    if (submissionCloseDate == null || !canShow || !mounted) {
      return;
    }
    await SubmissionClosingWarningDialog.showNDaysBefore(
      context: context,
      submissionCloseAt: submissionCloseDate,
      dontShowAgain: _dontShowCampaignSubmissionClosingDialog,
    );
  }

  Future<void> _showSubmitException(ProposalBuilderSubmitException error) {
    return SubmitProposalErrorDialog.show(
      context: context,
      exception: error,
    );
  }

  void _showValidationErrorSnackbar(ProposalBuilderValidationException error) {
    VoicesSnackBar.hideCurrent(context);

    final formattedFields =
        error.fields.whereNot((e) => e.isEmpty).map((e) => '• $e').join('\n');

    VoicesSnackBar(
      behavior: SnackBarBehavior.floating,
      type: VoicesSnackBarType.error,
      duration: const Duration(seconds: 15),
      title: error.message(context),
      message: formattedFields,
      actions: [
        VoicesSnackBarPrimaryAction(
          type: VoicesSnackBarType.error,
          onPressed: () => VoicesSnackBar.hideCurrent(context),
          child: Text(context.l10n.cancelButtonText),
        ),
      ],
    ).show(context);
  }

  void _updateSegments(List<Segment> data, NodeId? activeSectionId) {
    final state = _segmentsController.value;

    final newState = state.segments.isEmpty
        ? SegmentsControllerState.initial(
            segments: data,
            activeSectionId: activeSectionId,
          )
        : state.copyWith(
            segments: data,
            activeSectionId: Optional(activeSectionId),
          );

    _segmentsController.value = newState;
  }
}
