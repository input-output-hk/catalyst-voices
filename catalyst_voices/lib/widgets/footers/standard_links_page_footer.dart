import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/common/link_text.dart';
import 'package:catalyst_voices/widgets/footers/links_page_footer.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class StandardLinksPageFooter extends StatelessWidget {
  const StandardLinksPageFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(damian-molinski): implement proper routing actions once we have them
    return LinksPageFooter(
      upperChildren: [
        LinkText(
          'About us',
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('About us')));
          },
        ),
        LinkText(
          'Funds',
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Funds')));
          },
        ),
        LinkText(
          'Documentation',
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Documentation')));
          },
        ),
        LinkText(
          'Contact us',
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Contact us')));
          },
        ),
      ],
      lowerChildren: [
        VoicesIconButton(
          child: VoicesAssets.images.facebookMono.buildIcon(),
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Facebook')));
          },
        ),
        VoicesIconButton(
          child: VoicesAssets.images.linkedinMono.buildIcon(),
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('LinkedIn')));
          },
        ),
        VoicesIconButton(
          child: VoicesAssets.images.xMono.buildIcon(),
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('X')));
          },
        ),
      ],
    );
  }
}
