import 'package:catalyst_voices/pages/workspace/workspace_form_section.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WorkspaceBody extends StatelessWidget {
  final List<WorkspaceSection> sections;

  const WorkspaceBody({
    super.key,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 10),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];

        return WorkspaceFormSection(
          key: ValueKey('WorkspaceSection[${section.id}]Key'),
          data: section,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 24),
    );
  }
}
