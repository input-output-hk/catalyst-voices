import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DocumentVersionSelector extends StatelessWidget {
  final String? current;
  final List<String> versions;

  const DocumentVersionSelector({
    super.key,
    this.current,
    required this.versions,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(damian-molinski): implement version dropdown
    final current = this.current;
    final nr = current != null ? versions.indexOf(current) + 1 : 0;

    return Offstage(
      offstage: nr == 0,
      child: VoicesOutlinedButton(
        leading: VoicesAssets.icons.documentText.buildIcon(),
        child: Text(context.l10n.nrOfIteration(nr)),
        onTap: () {},
      ),
    );
  }
}
