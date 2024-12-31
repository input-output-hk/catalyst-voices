import 'package:catalyst_voices/pages/workspace/workspace_header.dart';
import 'package:catalyst_voices/widgets/document_builder/document_token_value_widget.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
    return Scaffold(
      body: Column(
        children: [
          const WorkspaceHeader(),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // WorkspaceErrorSelector(),
                // WorkspaceEmptyStateSelector(),
                // WorkspaceProposalsSelector(),
                // WorkspaceLoadingSelector(),
                Center(
                  child: SizedBox(
                    width: 700,
                    child: DocumentTokenValueWidget(
                      key: const ValueKey('q'),
                      title: 'Requested funds in ADA',
                      description:
                          'The amount of funding requested for your proposal',
                      currency: const Currency.ada(),
                      range: const Range(min: 15000, max: 2000000),
                      onChanged: (value) {
                        print('Value changed to $value');
                        //
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
