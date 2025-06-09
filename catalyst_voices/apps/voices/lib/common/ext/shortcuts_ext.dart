import 'package:flutter/foundation.dart';
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
    return switch (defaultTargetPlatform) {
      TargetPlatform.macOS => _macOsKeysMapping[this] ?? keyLabel,
      TargetPlatform.windows => _windowsKeysMapping[this] ?? keyLabel,
      _ => keyLabel,
    };
  }
}

extension LogicalKeySetExt on LogicalKeySet {
  String get asString => keys.map((e) => e.platformKeyLabel).join('+');
}
