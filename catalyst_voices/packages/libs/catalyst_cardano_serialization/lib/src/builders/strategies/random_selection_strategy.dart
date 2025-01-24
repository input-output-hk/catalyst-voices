import 'dart:math';

import 'package:catalyst_cardano_serialization/src/builders/types.dart';

/// A random coin selection strategy that selects UTxOs randomly.
class RandomSelectionStrategy implements CoinSelectionStrategy {
  final Random _random = Random();

  @override
  @override
  void apply(AssetsGroup assetsGroup) {
    for (final asset in assetsGroup) {
      asset.value.shuffle(_random);
    }
  }
}
