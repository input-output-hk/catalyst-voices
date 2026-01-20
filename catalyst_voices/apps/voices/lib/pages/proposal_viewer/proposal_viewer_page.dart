import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/proposal_viewer/proposal_viewer_view.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// Page that provides the ProposalViewerCubit and manages its lifecycle.
///
/// This page is responsible for:
/// - Creating the ProposalViewerCubit from dependency injection
/// - Providing it via BlocProvider to descendant widgets
/// - Disposing the cubit when the page is disposed
class ProposalViewerPage extends StatefulWidget {
  final DocumentRef ref;

  const ProposalViewerPage({
    super.key,
    required this.ref,
  });

  @override
  State<ProposalViewerPage> createState() => _ProposalViewerPageState();
}

class _ProposalViewerPageState extends State<ProposalViewerPage> {
  late final ProposalViewerCubit _cubit;

  @override
  Widget build(BuildContext context) {
    // Provide the cubit as both ProposalViewerCubit and DocumentViewerCubit
    // This allows child widgets to access it using either type
    return BlocProvider<ProposalViewerCubit>.value(
      value: _cubit,
      child: BlocProvider<DocumentViewerCubit>.value(
        value: _cubit,
        child: ProposalViewerView(ref: widget.ref),
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _cubit = Dependencies.instance.get<ProposalViewerCubit>();
    _cubit.init();
  }
}
