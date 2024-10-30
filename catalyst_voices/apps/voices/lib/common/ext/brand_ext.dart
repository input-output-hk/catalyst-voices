import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';

extension BrandExt on Brand {
  String localizedName(VoicesLocalizations localizations) {
    return switch (this) {
      // not localizable
      Brand.catalyst => 'Catalyst',
    };
  }
}
