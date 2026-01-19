import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/proposal/snack_bar/viewing_older_version_snack_bar.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_header.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_navigation_panel.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_sidebars.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/account_settings_action.dart';
import 'package:catalyst_voices/pages/spaces/appbar/actions/session_cta_action.dart';
import 'package:catalyst_voices/pages/spaces/drawer/opportunities_drawer.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/pages/document_viewer/document_viewer_content.dart';
import 'package:catalyst_voices/widgets/pages/document_viewer/document_viewer_error.dart';
import 'package:catalyst_voices/widgets/pages/document_viewer/document_viewer_loading.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalViewerView extends StatefulWidget {
  final DocumentRef ref;

  const ProposalViewerView({
    super.key,
    required this.ref,
  });

  @override
  State<ProposalViewerView> createState() => _ProposalViewerViewState();
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => VoicesAppBar.size;

  @override
  Widget build(BuildContext context) {
    final readOnlyMode = context.select<DocumentViewerCubit, bool>(
      (cubit) => cubit.state.readOnlyMode,
    );

    return VoicesAppBar(
      leading: !(readOnlyMode || CatalystFormFactor.current.isMobile)
          ? NavigationBack(
              isCompact: true,
              onCanNotPop: (context, _) => const ProposalsRoute().go(context),
            )
          : null,
      enableBackHome: !(readOnlyMode || CatalystFormFactor.current.isMobile),
      actions: [
        Offstage(
          offstage: readOnlyMode || CatalystFormFactor.current.isMobile,
          child: const SessionCtaAction(),
        ),
        Offstage(
          offstage: readOnlyMode || CatalystFormFactor.current.isMobile,
          child: const AccountSettingsAction(),
        ),
      ],
    );
  }
}

class _ProposalViewerViewState extends State<ProposalViewerView>
    with
        ErrorHandlerStateMixin<ProposalViewerCubit, ProposalViewerView>,
        SignalHandlerStateMixin<ProposalViewerCubit, ProposalSignal, ProposalViewerView> {
  late final SegmentsController _segmentsController;
  late final ItemScrollController _segmentsScrollController;

  StreamSubscription<dynamic>? _segmentsSub;

  @override
  Widget build(BuildContext context) {
    return SegmentsControllerScope(
      controller: _segmentsController,
      child: Stack(
        children: [
          Scaffold(
            appBar: const _AppBar(),
            endDrawer: const OpportunitiesDrawer(),
            floatingActionButton: _ScrollToTopButton(
              segmentsScrollController: _segmentsScrollController,
            ),
            body: Stack(
              children: [
                ProposalHeaderWrapper(
                  child: ProposalSidebars(
                    navPanel: const ProposalNavigationPanel(),
                    body: DocumentViewerContent(
                      scrollController: _segmentsScrollController,
                    ),
                  ),
                ),
                const DocumentViewerLoading(),
              ],
            ),
          ),
          const DocumentViewerError(),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ProposalViewerView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.ref != oldWidget.ref) {
      unawaited(context.read<ProposalViewerCubit>().loadProposal(widget.ref));
    }
  }

  @override
  void dispose() {
    unawaited(_segmentsSub?.cancel());
    _segmentsSub = null;

    _segmentsController.dispose();
    super.dispose();
  }

  @override
  void handleSignal(ProposalSignal signal) {
    switch (signal) {
      case ViewingOlderVersionSignal():
        VoicesSnackBar.hideCurrent(context);
        ViewingOlderVersionSnackBar(context).show(context);
      case ViewingOlderVersionWhileVotingSignal():
        VoicesSnackBar.hideCurrent(context);
        ViewingOlderVersionSnackBar(
          context,
          message: context.l10n.viewingOlderDocumentVersionWhileVoting,
        ).show(context);
      case ChangeVersionSignal():
        _changeVersion(signal.to);
      case UsernameUpdatedSignal():
        // Not needed for basic viewer
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    final bloc = context.read<ProposalViewerCubit>();

    _segmentsController = SegmentsController(scrollAlignment: 0.1);
    _segmentsScrollController = ItemScrollController();

    _segmentsController
      ..addListener(_handleSegmentsControllerChange)
      ..attachItemsScrollController(_segmentsScrollController);

    _segmentsSub = bloc.stream
        .map((event) => event.data.segments)
        .distinct(listEquals)
        .listen(_updateSegments);

    unawaited(bloc.loadProposal(widget.ref));
  }

  void _changeVersion(String? version) {
    Router.neglect(context, () {
      final ref = widget.ref.copyWith(ver: Optional(version));
      ProposalViewerRoute.fromRef(ref: ref).replace(context);
    });
  }

  void _handleSegmentsControllerChange() {}

  void _updateSegments(List<Segment> data) {
    final state = _segmentsController.value;

    final newState = state.segments.isEmpty
        ? SegmentsControllerState.initial(segments: data)
        : state.updateSegments(data);

    _segmentsController.value = newState;
  }
}

class _ScrollToTopButton extends StatefulWidget {
  final ItemScrollController segmentsScrollController;

  const _ScrollToTopButton({
    required this.segmentsScrollController,
  });

  @override
  State<_ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<_ScrollToTopButton> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _showButton = false;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !_showButton,
      child: FloatingActionButton(
        onPressed: _scrollToTop,
        child: VoicesAssets.icons.arrowUp.buildIcon(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = null;
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final element = notification.context as Element?;

      // Only react to content scroll from DocumentViewerContent, not menu
      if (element?.findAncestorWidgetOfExactType<DocumentViewerContent>() != null) {
        final oldShowButton = _showButton;
        final metrics = notification.metrics;

        _showButton = metrics.extentBefore > 50;

        if (_showButton != oldShowButton) {
          setState(() {});
        }
      }
    }
  }

  Future<void> _scrollToTop() async {
    await widget.segmentsScrollController.scrollTo(
      index: 0,
      duration: const Duration(milliseconds: 300),
      alignment: 1.5,
    );
  }
}
