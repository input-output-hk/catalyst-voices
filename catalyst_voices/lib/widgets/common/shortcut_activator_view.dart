import 'package:catalyst_voices/widgets/buttons/voices_logical_keyboard_key_button.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
