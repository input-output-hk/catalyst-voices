import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/proposal_builder/appbar/proposal_builder_back_action.dart';
import 'package:catalyst_voices/pages/proposal_builder/appbar/proposal_builder_status_action.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_changing.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_responsiveness.dart';
import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_validation_snackbar.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/account_settings_action.dart';
import 'package:catalyst_voices/pages/spaces/drawer/opportunities_drawer.dart';
import 'package:catalyst_voices/pages/workspace/submission_closing_warning_dialog.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices/widgets/modals/comment/submit_comment_error_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/proposal_error_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/proposal_limit_reached_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/publish_proposal_iteration_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/submit_proposal_for_review_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/unlock_edit_proposal.dart';
import 'package:catalyst_voices/widgets/snackbar/common_snackbars.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices/widgets/tiles/specialized/document_builder_section_tile_controller.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalBuilderPage extends StatelessWidget {
  final DocumentRef? proposalId;
  final SignedDocumentRef? categoryId;

  const ProposalBuilderPage({
    super.key,
    this.proposalId,
    this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProposalBuilderBloc>(
      create: (context) => Dependencies.instance.get<ProposalBuilderBloc>(),
      child: _ProposalBuilderBody(
        proposalId: proposalId,
        categoryId: categoryId,
      ),
    );
  }
}

class _ProposalBuilderBody extends StatefulWidget {
  final DocumentRef? proposalId;
  final SignedDocumentRef? categoryId;

  const _ProposalBuilderBody({
    this.proposalId,
    this.categoryId,
  });

  @override
  State<_ProposalBuilderBody> createState() => _ProposalBuilderBodyState();
}

class _ProposalBuilderBodyState extends State<_ProposalBuilderBody>
    with
        ErrorHandlerStateMixin<ProposalBuilderBloc, _ProposalBuilderBody>,
        SignalHandlerStateMixin<ProposalBuilderBloc, ProposalBuilderSignal, _ProposalBuilderBody> {
  late final SegmentsController _segmentsController;
  late final ItemScrollController _segmentsScrollController;
  late final DocumentBuilderSectionTileController _sectionTileController;

  StreamSubscription<DocumentRef?>? _proposalRefSub;
  StreamSubscription<dynamic>? _segmentsSub;

  /// A bool which should be set to true when navigating away from the screen.
  /// If true the page should not attempt to overwrite the url
  /// (i.e. with document ref change) not to prevent the back navigation.
  bool _isAboutToExit = false;

  @override
  Widget build(BuildContext context) {
    return ProposalBuilderChangingOverlay(
      child: ProposalBuilderValidationSnackbarOverlay(
        child: Scaffold(
          appBar: const VoicesAppBar(
            automaticallyImplyLeading: false,
            actions: [
              ProposalBuilderBackAction(),
              ProposalBuilderStatusAction(),
              AccountSettingsAction(),
            ],
          ),
          endDrawer: const OpportunitiesDrawer(),
          body: SegmentsControllerScope(
            controller: _segmentsController,
            child: ProposalBuilderResponsiveness(
              segmentsScrollController: _segmentsScrollController,
              sectionTileController: _sectionTileController,
              onRetryTap: _loadProposal,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(_ProposalBuilderBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.proposalId != oldWidget.proposalId || widget.categoryId != oldWidget.categoryId) {
      _loadProposal();
    }
  }

  @override
  void dispose() {
    _segmentsController.dispose();
    _sectionTileController.dispose();

    unawaited(_proposalRefSub?.cancel());
    _proposalRefSub = null;

    unawaited(_segmentsSub?.cancel());
    _segmentsSub = null;

    super.dispose();
  }

  @override
  void handleError(Object error) {
    switch (error) {
      case ProposalBuilderPublishException():
        unawaited(_showPublishException(error));
      case ProposalBuilderSubmitException():
        unawaited(_showSubmitException(error));
      case ProposalBuilderLimitReachedException():
        unawaited(_showLimitReachedException(error));
      case ProposalBuilderDocumentSignException():
        unawaited(_showDocumentSignException(error));
      case LocalizedUnknownPublishCommentException():
        unawaited(_showCommentException(error));
      case LocalizedException():
        unawaited(_showGenericException(error));
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
        _leavePage();
      case ProposalSubmissionCloseDate():
        unawaited(_showSubmissionClosingWarningDialog(signal.date));
      case EmailNotVerifiedProposalBuilderSignal():
        unawaited(_showEmailNotVerifiedDialog());
      case MaxProposalsLimitReachedSignal():
        unawaited(_showProposalLimitReachedDialog(signal));
      case UnlockProposalSignal():
        unawaited(_showUnlockProposalDialog(signal));
      case ForgotProposalSuccessBuilderSignal():
        _showForgetProposalSuccessDialog();
      case NewProposalAndEmailNotVerifiedSignal():
        _showEmailVerificationNeededSnackbar();
      case ShowPublishConfirmationSignal():
        unawaited(_showPublishConfirmationDialog(signal));
      case ShowSubmitConfirmationSignal():
        unawaited(_showSubmitConfirmationDialog(signal));
    }
  }

  @override
  void initState() {
    super.initState();

    final bloc = context.read<ProposalBuilderBloc>();

    _segmentsController = SegmentsController();
    _segmentsScrollController = ItemScrollController();
    _sectionTileController = DocumentBuilderSectionTileController();

    _segmentsController
      ..addListener(_handleSegmentsControllerChange)
      ..attachItemsScrollController(_segmentsScrollController);

    _listenForProposalRef(bloc);
    _listenForSegments(bloc);
    _loadProposal(bloc: bloc);
    _loadSubmissionCloseDate(bloc: bloc);
  }

  void _dontShowCampaignSubmissionClosingDialog(bool value) {
    context.read<SessionCubit>().updateShowSubmissionClosingWarning(value: !value);
  }

  void _handleSegmentsControllerChange() {
    final activeSectionId = _segmentsController.value.activeSectionId;

    final event = ActiveNodeChangedEvent(activeSectionId);
    context.read<ProposalBuilderBloc>().add(event);
  }

  void _leavePage() {
    _isAboutToExit = true;
    const WorkspaceRoute().go(context);
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

  void _loadProposal({ProposalBuilderBloc? bloc}) {
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
  }

  void _loadSubmissionCloseDate({ProposalBuilderBloc? bloc}) {
    bloc ??= context.read<ProposalBuilderBloc>();
    bloc.add(const ProposalSubmissionCloseDateEvent());
  }

  void _onProposalDeleted() {
    Router.neglect(context, () {
      const WorkspaceRoute().replace(context);
    });
  }

  void _onProposalRefChanged(DocumentRef? ref) {
    if (ref != null && !_isAboutToExit) {
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

  Future<void> _showDocumentSignException(ProposalBuilderDocumentSignException error) {
    return ProposalErrorDialog.show(
      context: context,
      title: error.title(context),
      message: error.message(context),
    );
  }

  Future<void> _showEmailNotVerifiedDialog() async {
    final openAccount = await EmailNotVerifiedDialog.show(context);

    if (openAccount && mounted) {
      Router.neglect(context, () {
        unawaited(const AccountRoute().push(context));
      });
    }
  }

  void _showEmailVerificationNeededSnackbar() {
    VoicesSnackBar(
      type: VoicesSnackBarType.error,
      behavior: SnackBarBehavior.floating,
      title: context.l10n.verifiedEmailNeededToPublishTitle,
      message: context.l10n.verifiedEmailNeededToPublishMessage,
      actions: [
        VoicesTextButton(
          onTap: () => unawaited(const AccountRoute().push(context)),
          child: Text(
            context.l10n.emailNotVerifiedDialogAction,
            style: context.textTheme.labelLarge?.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: context.colors.elevationsOnSurfaceNeutralLv0,
              color: context.colors.elevationsOnSurfaceNeutralLv0,
            ),
          ),
        ),
      ],
    ).show(context);
  }

  void _showForgetProposalSuccessDialog() {
    CommonSnackbars.showForgetProposalSuccessDialog(context);

    Router.neglect(context, () {
      const WorkspaceRoute().replace(context);
    });
  }

  Future<void> _showGenericException(LocalizedException error) {
    return ProposalErrorDialog.show(
      context: context,
      title: context.l10n.somethingWentWrong,
      message: error.message(context),
    );
  }

  Future<void> _showLimitReachedException(ProposalBuilderLimitReachedException error) {
    return ProposalErrorDialog.show(
      context: context,
      title: error.title(context),
      message: error.message(context),
    );
  }

  Future<void> _showProposalLimitReachedDialog(
    MaxProposalsLimitReachedSignal signal,
  ) {
    return ProposalLimitReachedDialog.show(
      context: context,
      currentSubmissions: signal.currentSubmissions,
      maxSubmissions: signal.maxSubmissions,
      submissionCloseAt: signal.proposalSubmissionCloseDate,
    );
  }

  Future<void> _showPublishConfirmationDialog(ShowPublishConfirmationSignal signal) async {
    final shouldPublish =
        await PublishProposalIterationDialog.show(
          context: context,
          proposalTitle: signal.proposalTitle ?? context.l10n.proposalEditorStatusDropdownViewTitle,
          currentIteration: signal.currentIteration,
          nextIteration: signal.nextIteration,
          showCollaboratorsInfo: signal.hasCollaborators,
        ) ??
        false;

    if (shouldPublish && mounted) {
      context.read<ProposalBuilderBloc>().add(const PublishProposalEvent());
    }
  }

  Future<void> _showPublishException(ProposalBuilderPublishException error) {
    return ProposalErrorDialog.show(
      context: context,
      title: error.title(context),
      message: error.message(context),
    );
  }

  Future<void> _showSubmissionClosingWarningDialog(
    DateTime submissionCloseDate,
  ) async {
    final canShow = context.read<SessionCubit>().state.settings.showSubmissionClosingWarning;

    if (canShow) {
      await SubmissionClosingWarningDialog.showNDaysBefore(
        context: context,
        submissionCloseAt: submissionCloseDate,
        dontShowAgain: _dontShowCampaignSubmissionClosingDialog,
      );
    }
  }

  Future<void> _showSubmitConfirmationDialog(ShowSubmitConfirmationSignal signal) async {
    final shouldSubmit =
        await SubmitProposalForReviewDialog.show(
          context: context,
          proposalTitle: signal.proposalTitle ?? context.l10n.proposalEditorStatusDropdownViewTitle,
          currentIteration: signal.currentIteration,
          nextIteration: signal.nextIteration,
          showCollaboratorsInfo: signal.hasCollaborators,
        ) ??
        false;

    if (shouldSubmit && mounted) {
      context.read<ProposalBuilderBloc>().add(const SubmitProposalEvent());
    }
  }

  Future<void> _showSubmitException(ProposalBuilderSubmitException error) {
    return ProposalErrorDialog.show(
      context: context,
      title: error.title(context),
      message: error.message(context),
    );
  }

  Future<void> _showUnlockProposalDialog(UnlockProposalSignal signal) async {
    if (!_isAboutToExit) {
      final bloc = context.read<ProposalBuilderBloc>();
      final unlock =
          await UnlockEditProposalDialog.show(
            context: context,
            title: signal.title,
            version: signal.version,
          ) ??
          false;

      if (!mounted) {
        return;
      } else if (unlock) {
        return bloc.add(const UnlockProposalBuilderEvent());
      } else {
        return Router.neglect(context, () {
          const WorkspaceRoute().replace(context);
        });
      }
    }
  }

  void _updateSegments(List<Segment> data, NodeId? activeSectionId) {
    final state = _segmentsController.value;

    final newState = state.segments.isEmpty
        ? SegmentsControllerState.initial(
            segments: data,
            activeSectionId: activeSectionId,
          )
        : state.updateSegments(data).copyWith(activeSectionId: Optional(activeSectionId));

    _segmentsController.value = newState;
  }
}
