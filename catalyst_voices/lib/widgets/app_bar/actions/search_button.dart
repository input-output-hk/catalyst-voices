import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A [SearchButton] widget that is used to display a call to action to
/// search within the app.
class SearchButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const SearchButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: VoicesAssets.icons.search.buildIcon(size: 18),
      label: Text(context.l10n.searchButtonLabelText),
    );
  }
}
