import 'package:catalyst_voices/pages/workspace/workspace_empty_state.dart';
import 'package:catalyst_voices/pages/workspace/workspace_error.dart';
import 'package:catalyst_voices/pages/workspace/workspace_header.dart';
import 'package:catalyst_voices/pages/workspace/workspace_loading.dart';
import 'package:catalyst_voices/pages/workspace/workspace_proposals.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  @override
  void initState() {
    super.initState();

    context.read<WorkspaceBloc>().add(const LoadProposalsEvent());
  }

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
                WorkspaceError(),
                WorkspaceEmptyState(),
                WorkspaceProposals(),
                WorkspaceLoading(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
