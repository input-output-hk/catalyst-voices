import 'package:catalyst_voices/pages/spaces/drawer/space_header.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class MyPrivateProposals extends StatelessWidget {
  const MyPrivateProposals({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpaceHeader(Space.workspace),
        SectionHeader(
          key: ValueKey('Header.workspace'),
          leading: SizedBox(width: 12),
          title: Text('My private proposals (3/5)'),
        ),
        // TODO(damian-molinski): watch workspace bloc
      ],
    );
  }
}
