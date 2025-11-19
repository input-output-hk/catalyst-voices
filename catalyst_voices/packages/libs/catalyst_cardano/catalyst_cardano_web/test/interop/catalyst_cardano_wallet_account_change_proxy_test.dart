import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_web/src/interop/catalyst_cardano_wallet_account_change_proxy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group(CardanoWalletAccountChangeProxy, () {
    test(
      'request to get balance is retried when account change is caught',
      () async {
        // given
        const expectedBalance = Balance.zero();
        final delegate = _CardanoWalletMock();

        final apiWithAccountChange = _CardanoWalletApiMock();
        final apiWithBalance = _CardanoWalletApiMock();

        // when
        when(apiWithAccountChange.getBalance).thenThrow(
          const WalletApiException(
            code: WalletApiErrorCode.accountChange,
            info: 'account change',
          ),
        );

        when(apiWithBalance.getBalance).thenAnswer((_) async => expectedBalance);

        var enableCount = 0;
        when(delegate.enable).thenAnswer((invocation) async {
          enableCount++;
          return enableCount >= 2 ? apiWithBalance : apiWithAccountChange;
        });

        final walletProxy = CardanoWalletAccountChangeProxy(delegate);

        // then
        final actualBalance = await walletProxy.enable().then((e) => e.getBalance());
        expect(actualBalance, equals(expectedBalance));
      },
    );
  });
}

final class _CardanoWalletApiMock extends Mock implements CardanoWalletApi {}

final class _CardanoWalletMock extends Mock implements CardanoWallet {}
