import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_assets/generated/colors.gen.dart';

import 'package:flutter/material.dart';

// [brands] is a Map that stores the ThemeData for all the
// available brands in the Catalyst Voices app.
// This map is used by the [BrandBloc] to properly
// switch the active theme based on the BlocState.

final Map<BrandKey, ThemeData> brands = {
  BrandKey.catalyst: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: VoicesColors.blue,
      primary: VoicesColors.blue,
    ),
  ),
  BrandKey.dummy: ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF5722),
      primary: const Color(0xFFFF5722),
    ),
  ),
};

enum BrandKey {
  catalyst,
  dummy,
}
