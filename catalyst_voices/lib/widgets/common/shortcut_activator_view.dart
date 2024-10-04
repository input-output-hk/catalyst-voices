import 'package:catalyst_voices/widgets/buttons/voices_logical_keyboard_key_button.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Grouping all [LogicalKeyboardKey] that correspond with given [activator]
/// and shows them in a [Row] as [VoicesLogicalKeyboardKeyButton].
///
/// This widget also uses [LogicalKeyboardKey.collapseSynonyms] to remove
/// any synonyms key activator such as left Control and right Control.
class ShortcutActivatorView extends StatelessWidget {
  final ShortcutActivator activator;

  const ShortcutActivatorView({
    super.key,
    required this.activator,
  });

  @override
  Widget build(BuildContext context) {
    final triggers = {...?activator.triggers};

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: LogicalKeyboardKey.collapseSynonyms(triggers)
          .map<Widget>(VoicesLogicalKeyboardKeyButton.new)
          .separatedBy(const SizedBox(width: 4))
          .toList(),
    );
  }
}
