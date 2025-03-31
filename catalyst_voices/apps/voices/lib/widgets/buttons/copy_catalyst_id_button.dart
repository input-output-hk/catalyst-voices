import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/widgets.dart';

class CopyCatalystIdButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CopyCatalystIdButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      onTap: onTap,
      leading: VoicesAssets.icons.duplicate.buildIcon(),
      child: Text(context.l10n.copyMyCatalystId),
    );
  }
}
