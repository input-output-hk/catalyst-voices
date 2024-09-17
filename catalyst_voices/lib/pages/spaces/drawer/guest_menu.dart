import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class GuestMenu extends StatelessWidget {
  final Space space;

  const GuestMenu({
    super.key,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VoicesNavTile(
          leading: VoicesAssets.icons.home.buildIcon(),
          name: 'Home',
          backgroundColor: space.backgroundColor(context),
        ),
        VoicesNavTile(
          leading: VoicesAssets.icons.calendar.buildIcon(),
          name: 'Discover ideas',
        ),
        VoicesNavTile(
          leading: VoicesAssets.icons.clipboardCheck.buildIcon(),
          name: 'Learn about Keychain',
        ),
        VoicesNavTile(
          leading: VoicesAssets.icons.questionMarkCircle.buildIcon(),
          name: 'FAQ',
        ),
      ],
    );
  }
}
