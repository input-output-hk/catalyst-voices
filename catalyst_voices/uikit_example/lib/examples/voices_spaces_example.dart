import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VoicesSpacesExample extends StatelessWidget {
  static const String route = '/spaces-example';

  const VoicesSpacesExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final icons = VoicesAssets.internalResources.icons;

    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          LinksPageFooter(
            upperChildren: [
              LinkText('About us', onTap: () {}),
              LinkText('Funds', onTap: () {}),
              LinkText('Documentation', onTap: () {}),
              LinkText('Contact us', onTap: () {}),
            ],
            lowerChildren: [
              VoicesIconButton(
                child: icons.facebookMono.build(),
                onTap: () {},
              ),
              VoicesIconButton(
                child: icons.linkedinMono.build(),
                onTap: () {},
              ),
              VoicesIconButton(
                child: icons.xMono.build(),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
