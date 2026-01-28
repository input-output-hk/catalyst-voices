import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer_header.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 22, bottom: 16),
      child: VoicesDrawerHeader(
        title: AffixDecorator(
          prefix: VoicesAssets.icons.userGroup.buildIcon(),
          child: const Text('Representative List'),
        ),
        onCloseTap: () => Navigator.maybePop(context),
      ),
    );
  }
}
