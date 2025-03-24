import 'dart:async';

import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/proposal/proposal_content.dart';
import 'package:catalyst_voices/pages/proposal/proposal_error.dart';
import 'package:catalyst_voices/pages/proposal/proposal_loading.dart';
import 'package:catalyst_voices/pages/proposal/snack_bar/viewing_older_version_snack_bar.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_header.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_navigation_panel.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_sidebars.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProposalPage extends StatefulWidget {
  final DocumentRef ref;

  const ProposalPage({
    super.key,
    required this.ref,
  });

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage>
    with SignalHandlerStateMixin<ProposalCubit, ProposalSignal, ProposalPage> {
  late final SegmentsController _segmentsController;
  late final ItemScrollController _segmentsScrollController;

  StreamSubscription<dynamic>? _segmentsSub;

  @override
  Widget build(BuildContext context) {
    return SegmentsControllerScope(
      controller: _segmentsController,
      child: Scaffold(
        appBar: const VoicesAppBar(automaticallyImplyLeading: false),
        body: ProposalHeaderWrapper(
          child: ProposalSidebars(
            navPanel: const ProposalNavigationPanel(),
            body: Stack(
              children: [
                ProposalContent(
                  scrollController: _segmentsScrollController,
                ),
                const ProposalLoading(),
                const ProposalError(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ProposalPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.ref != oldWidget.ref) {
      unawaited(context.read<ProposalCubit>().load(ref: widget.ref));
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
      case ChangeVersionSignal():
        _changeVersion(signal.to);
    }
  }

  @override
  void initState() {
    super.initState();

    final bloc = context.read<ProposalCubit>();

    _segmentsController = SegmentsController();
    _segmentsScrollController = ItemScrollController();

    _segmentsController
      ..addListener(_handleSegmentsControllerChange)
      ..attachItemsScrollController(_segmentsScrollController);

    _segmentsSub = bloc.stream
        .map((event) => event.data.segments)
        .distinct(listEquals)
        .listen(_updateSegments);

    unawaited(bloc.load(ref: widget.ref));
  }

  void _changeVersion(String? version) {
    Router.neglect(context, () {
      final ref = widget.ref.copyWith(version: Optional(version));
      ProposalRoute.fromRef(ref: ref).replace(context);
    });
  }

  void _handleSegmentsControllerChange() {}

  void _updateSegments(List<Segment> data) {
    final state = _segmentsController.value;

    final newState = state.segments.isEmpty
        ? SegmentsControllerState.initial(segments: data)
        : state.copyWith(segments: data);

    _segmentsController.value = newState;
  }
}
