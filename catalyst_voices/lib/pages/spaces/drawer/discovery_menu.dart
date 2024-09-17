import 'package:catalyst_voices/pages/spaces/drawer/space_header.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DiscoveryDrawerMenu extends StatelessWidget {
  const DiscoveryDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpaceHeader(Space.discovery),
      ],
    );
  }
}
