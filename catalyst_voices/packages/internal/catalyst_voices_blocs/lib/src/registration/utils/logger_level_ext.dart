import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

extension LoggerLevelExt on Object {
  Level get level {
    final instance = this;
    if (instance is TxSignException && instance.code == TxSignErrorCode.userDeclined) {
      return Level.INFO;
    }
    if (instance is WalletApiException && instance.code == WalletApiErrorCode.refused) {
      return Level.INFO;
    }
    if (instance is WalletApiException && instance.code == WalletApiErrorCode.accountChange) {
      return Level.INFO;
    }
    if (instance is WalletDataSignException &&
        instance.code == WalletDataSignErrorCode.userDeclined) {
      return Level.INFO;
    }

    return Level.SEVERE;
  }
}
