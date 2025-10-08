import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final _macOsKeysMapping = {
  LogicalKeyboardKey.control: '⌘',
  LogicalKeyboardKey.alt: '⌥',
  LogicalKeyboardKey.meta: '⌘',
};

final _windowsKeysMapping = {
  LogicalKeyboardKey.control: 'Ctrl',
  LogicalKeyboardKey.meta: 'Win',
};

extension LogicalKeyboardKeyExt on LogicalKeyboardKey {
  String get platformKeyLabel {
    return switch (CatalystOperatingSystem.current) {
      CatalystOperatingSystem.macOS => _macOsKeysMapping[this] ?? keyLabel,
      CatalystOperatingSystem.windows => _windowsKeysMapping[this] ?? keyLabel,
      _ => keyLabel,
    };
  }
}

extension LogicalKeySetExt on LogicalKeySet {
  String get asString => keys.map((e) => e.platformKeyLabel).join('+');
}
