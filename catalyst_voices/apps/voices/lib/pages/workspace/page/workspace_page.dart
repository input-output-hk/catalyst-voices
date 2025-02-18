import 'package:catalyst_voices/pages/workspace/header/workspace_header.dart';
import 'package:catalyst_voices/pages/workspace/my_proposals/workspace_my_proposals_selector.dart';
import 'package:catalyst_voices/pages/workspace/page/workspace_empty.dart';
import 'package:catalyst_voices/pages/workspace/page/workspace_error.dart';
import 'package:catalyst_voices/pages/workspace/page/workspace_loading.dart';
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
  void initState() {
    super.initState();
    context.read<WorkspaceBloc>().add(const LoadProposalsEvent());
  }
}
