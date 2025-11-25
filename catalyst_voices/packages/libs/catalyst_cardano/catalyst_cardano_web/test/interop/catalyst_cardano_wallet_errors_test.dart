import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';
import 'package:catalyst_cardano_web/src/interop/catalyst_cardano_wallet_errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CardanoWalletErrors', () {
    test('mapApiException', () {
      final err = '{"code": ${WalletApiErrorCode.accountChange.tag}, "info": "error"}';

      expect(
        mapApiException(err),
        equals(
          const WalletApiException(
            code: WalletApiErrorCode.accountChange,
            info: 'error',
          ),
        ),
      );
    });

    test('mapDataSignException', () {
      final err = '{"code": ${WalletDataSignErrorCode.userDeclined.tag}, "info": "error"}';

      expect(
        mapDataSignException(err),
        equals(
          const WalletDataSignException(
            code: WalletDataSignErrorCode.userDeclined,
            info: 'error',
          ),
        ),
      );
    });

    test('mapPaginateException', () {
      const err = '{"maxSize": 50}';

      expect(
        mapPaginateException(err),
        equals(const WalletPaginateException(maxSize: 50)),
      );
    });

    test('mapTxSendException', () {
      final err = '{"code": ${TxSendErrorCode.refused.tag}, "info": "error"}';

      expect(
        mapTxSendException(err),
        equals(
          const TxSendException(
            code: TxSendErrorCode.refused,
            info: 'error',
          ),
        ),
      );
    });

    test('mapTxSignException', () {
      final err = '{"code": ${TxSignErrorCode.userDeclined.tag}, "info": "error"}';

      expect(
        mapTxSignException(err),
        equals(
          const TxSignException(
            code: TxSignErrorCode.userDeclined,
            info: 'error',
          ),
        ),
      );
    });
  });
}
