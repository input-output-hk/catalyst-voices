import 'package:catalyst_voices/pages/spaces/drawer/opportunities_drawer.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesEndDrawer extends StatelessWidget {
  final Space space;

  const SpacesEndDrawer({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    return switch (space) {
      // TODO(damian-molinski): Call VoteListDrawer when implemented, thank you!
      Space.voting => const SizedBox.shrink(),
      _ => const OpportunitiesDrawer(),
    };
  }
}
