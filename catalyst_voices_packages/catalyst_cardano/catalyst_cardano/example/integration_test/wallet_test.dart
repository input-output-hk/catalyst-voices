import 'dart:convert';
import 'dart:io';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_example/main.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webdriver/async_io.dart';

void main() {
  group('Connect wallet', () {
    // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Enable wallet', (tester) async {
      final wallets = await CatalystCardanoPlatform.instance.getWallets();
      print('wallets are');
      print(wallets);
      final api = await wallets.first.enable();
      final balance = await api.getBalance();

      expect(balance, 0);
    });
  });
}
