// ignore_for_file: avoid_print

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:convert/convert.dart';

Future<void> main() async {
  final message = hex.decode(
    '6c1382765aec5358f117733d281c1c7bdc39884d04a45a1e6c67c858bc206c19',
  );

  final coseSignature = await CatalystCose.instance.signMessage(message);
  print(coseSignature);
}
