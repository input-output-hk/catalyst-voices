import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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
    return VoicesOutlinedButton(
      leading: VoicesAssets.icons.documentText.buildIcon(),
      child: Text('Iteration ${versions.length}'),
      onTap: () {},
    );
  }
}
