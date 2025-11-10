abstract class Configs {
  static const empty = '{}';

  static const mainnetBlockchainSlotNumber = '''
{
  "version": "0.1.0",
  "createdAt": "2025-04-02T12:59:50.841808Z",
  "blockchain": {
    "networkId": "mainnet",
    "host": "cardano",
    "slotNumberConfig": {
      "systemStartTimestamp":"2020-07-29T21:44:51.000000Z",
      "systemStartSlot":4492800,
      "slotLength":1
    }
  }
}
''';

  static const testnetBlockchainSlotNumber = '''
{
  "version": "0.1.0",
  "createdAt": "2025-04-02T12:59:50.841808Z",
  "blockchain": {
    "networkId": "testnet",
    "host": "cardano",
    "slotNumberConfig": {
      "systemStartTimestamp":"2022-06-21T00:00:00.000000Z",
      "systemStartSlot":86400,
      "slotLength":1
    }
  }
}
''';

  static const invalidSentryDsn = '''
{
  "version": "0.1.0",
  "createdAt": "2025-04-02T12:59:50.841808Z",
  "sentry": {
    "dsn": "https://example.com",
    "environment": "dev",
    "release": "1.0.0"
  }
}
''';
  static const noChain = '''
{
  "version": "0.1.0",
  "createdAt": "2025-04-02T12:59:50.841808Z",
  "cache": {
    "expiryDuration": {
      "keychainUnlock": 3600
    }
  },
  "sentry": {
    "dsn": "https://8e333ddbed1e096c70e4ed006892c355@o622089.ingest.us.sentry.io/4507113601433600",
    "environment": "prod",
    "release": "catalyst-voices@prod",
    "tracesSampleRate": 0.1,
    "profilesSampleRate": 0.1,
    "enableAutoSessionTracking": true,
    "attachScreenshot": false,
    "attachViewHierarchy": false,
    "debug": false,
    "diagnosticLevel": "error"
  }
}
''';

  static const full = '''
{
  "version": "0.1.0",
  "createdAt": "2025-04-02T12:59:50.841808Z",
  "cache": {
    "expiryDuration": {
      "keychainUnlock": 3600
    }
  },
  "sentry": {
    "dsn": "https://8e333ddbed1e096c70e4ed006892c355@o622089.ingest.us.sentry.io/4507113601433600",
    "environment": "prod",
    "release": "catalyst-voices@prod",
    "tracesSampleRate": 0.1,
    "profilesSampleRate": 0.1,
    "enableAutoSessionTracking": true,
    "attachScreenshot": false,
    "attachViewHierarchy": false,
    "debug": false,
    "diagnosticLevel": "error"
  },
  "blockchain": {
    "networkId": "mainnet",
    "host": "cardano",
    "transactionBuilderConfig": {
      "feeAlgo": {
        "constant": 155381,
        "coefficient": 44,
        "multiplier": 1.2,
        "sizeIncrement": 25600,
        "refScriptByteCost": 15,
        "maxRefScriptSize": 204800
      },
      "maxTxSize": 16384,
      "maxValueSize": 5000,
      "coinsPerUtxoByte": 4310,
      "selectionStrategy": "greedy"
    }
  }
}
''';

  const Configs._();
}
