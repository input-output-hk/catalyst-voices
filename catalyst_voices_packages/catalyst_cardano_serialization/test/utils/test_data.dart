import 'package:catalyst_cardano_serialization/src/address.dart';

/* cSpell:disable */
final mainnetAddr = ShelleyAddress.fromBech32(
  'addr1qx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3n0d3vllmyqws'
  'x5wktcd8cc3sq835lu7drv2xwl2wywfgse35a3x',
);
final testnetAddr = ShelleyAddress.fromBech32(
  'addr_test1vz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzerspjrlsz',
);
final mainnetStakeAddr = ShelleyAddress.fromBech32(
  'stake1uyehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gh6ffgw',
);
final testnetStakeAddr = ShelleyAddress.fromBech32(
  'stake_test1uqehkck0lajq8gr28t9uxnuvgcqrc6070x3k9r8048z8y5gssrtvn',
);
/* cSpell:enable */
