import 'dart:math';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:convert/convert.dart';

/// A utility class for generating random data and performing selection-related
/// operations for testing purposes.
///
/// This class is used only in testing and resides under the `./test` folder.
sealed class SelectionUtils {
  static final _kRandom = Random();

  static const String _chars = 'abcdefghijklmnopqrstuvwxyz'
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      '0123456789';

  /// The default configuration for transaction building.
  ///
  /// This configuration includes fee algorithm parameters, maximum transaction
  /// size, maximum value size, and coins per UTxO byte.
  static const defaultConfig = TransactionBuilderConfig(
    feeAlgo: TieredFee(
      constant: 155381,
      coefficient: 44,
      refScriptByteCost: 15,
    ),
    maxTxSize: 16384,
    maxValueSize: 5000,
    coinsPerUtxoByte: Coin(4310),
  );

  /// Generates a random ASCII string of the specified length.
  ///
  /// - [length]: The length of the random ASCII string to generate.
  ///
  /// Returns:
  /// - A random ASCII string of the specified length.
  static String randomAscii(int length) =>
      List.generate(length, (index) => _chars[_kRandom.nextInt(_chars.length)])
          .join();

  /// Generates a random Shelley address.
  ///
  /// - [isBase]: If `true`, generates a base address. Otherwise, generates an
  ///   enterprise address.
  /// - [isMainnet]: If `true`, generates a mainnet address. Otherwise,
  ///   generates a testnet address.
  ///
  /// Returns:
  /// - A random [ShelleyAddress].
  static ShelleyAddress randomAddress({
    bool isBase = true,
    bool isMainnet = false,
  }) =>
      ShelleyAddress(
        [
          if (isMainnet) 01 else 00,
          ...randomBytes(isBase ? 56 : 28),
        ],
      );

  /// Generates a list of random Shelley addresses.
  ///
  /// - [count]: The number of addresses to generate.
  /// - [isBase]: If `true`, generates base addresses. Otherwise, generates
  ///   enterprise addresses.
  /// - [isMainnet]: If `true`, generates mainnet addresses. Otherwise,
  ///   generates testnet addresses.
  ///
  /// Returns:
  /// - A list of random [ShelleyAddress] objects.
  static List<ShelleyAddress> randomAddresses({
    required int count,
    bool isBase = true,
    bool isMainnet = false,
  }) =>
      List<ShelleyAddress>.generate(
        count,
        (_) => randomAddress(isBase: isBase, isMainnet: isMainnet),
      );

  /// Generates a random balance.
  ///
  /// - [withTokens]: If `true`, includes random tokens in the balance.
  ///
  /// Returns:
  /// - A random [Balance].
  static Balance randomBalance({bool withTokens = false}) =>
      randomBalances(count: 1, withTokens: withTokens).first;

  /// Generates a list of random balances.
  ///
  /// - [count]: The number of balances to generate.
  /// - [withTokens]: If `true`, includes random tokens in the balances.
  ///
  /// Returns:
  /// - A list of random [Balance] objects.
  static List<Balance> randomBalances({
    required int count,
    Coin minimumCoin = const Coin(0),
    bool withTokens = false,
  }) {
    final pids = List.generate(10, (int index) {
      return PolicyId(randomHexString(28));
    });

    final assetNames = List.generate(10, (int index) {
      final assetNameLength = _kRandom.nextInt(32).clamp(4, 16);
      return AssetName(randomAscii(assetNameLength));
    });

    final balances = <Balance>[];
    final distr = generateWeibullDistribution(count, 1.5, 2);

    for (var i = 0; i < count; i++) {
      final nextInt = _kRandom.nextInt(10);
      final assetNr = _kRandom.nextInt(6) + 1;
      final assetDistr = generateWeibullDistribution(assetNr, 1.5, 2);

      final assets = List<Map<AssetName, Coin>>.generate(assetNr, (int index) {
        return {
          assetNames[nextInt]:
              Coin(assetDistr[_kRandom.nextInt(assetNr)].toInt()),
        };
      });
      final multiAsset = withTokens
          ? MultiAsset(
              bundle: {
                pids[nextInt]: Map<AssetName, Coin>.fromEntries(
                  assets.expand((map) => map.entries),
                ),
              },
            )
          : null;

      final coin = Coin(distr[i].toInt());
      final lovelace = coin < minimumCoin ? minimumCoin + coin : coin;
      final balance = Balance(coin: lovelace, multiAsset: multiAsset);
      balances.add(balance);
    }
    return balances;
  }

  /// Generates a list of random bytes.
  ///
  /// - [length]: The length of the byte list to generate.
  ///
  /// Returns:
  /// - A list of random bytes.
  static List<int> randomBytes(int length) =>
      List.generate(length, (_) => _kRandom.nextInt(256));

  /// Generates a random hexadecimal string of the specified length.
  ///
  /// - [length]: The length of the hexadecimal string to generate.
  ///
  /// Returns:
  /// - A random hexadecimal string.
  static String randomHexString(int length) =>
      hex.encoder.convert(randomBytes(length));

  /// Generates a set of random UTxOs (Unspent Transaction Outputs).
  ///
  /// - [count]: The number of UTxOs to generate.
  ///
  /// Returns:
  /// - A set of random [TransactionUnspentOutput] objects.
  static Set<TransactionUnspentOutput> generateUtxos(
    int count, {
    Coin minimumCoin = const Coin(0),
    bool withTokens = true,
  }) {
    final balances = randomBalances(
      count: count,
      minimumCoin: minimumCoin,
      withTokens: withTokens,
    );
    final addressCount = count >= 2 ? (count / 2).floor() : 1;
    final addresses = randomAddresses(count: addressCount);

    return List.generate(
      count,
      (i) => TransactionUnspentOutput(
        input: TransactionInput(
          transactionId: TransactionHash.fromHex(randomHexString(32)),
          index: i,
        ),
        output: TransactionOutput(
          address: addresses[_kRandom.nextInt(addresses.length)],
          amount: balances[i],
        ),
      ),
    ).toSet();
  }

  /// Generates a list of numbers following a Weibull distribution.
  ///
  /// - [size]: The number of values to generate.
  /// - [shape]: The shape parameter of the Weibull distribution.
  /// - [scale]: The scale parameter of the Weibull distribution.
  ///
  /// Returns:
  /// - A list of [BigInt] values following the Weibull distribution.
  static List<BigInt> generateWeibullDistribution(
    int size,
    double shape,
    double scale,
  ) {
    final random = Random();
    final weibullNumbers = <BigInt>[];

    for (var i = 0; i < size; i++) {
      // Uniform random variable between 0 and 1
      final u = random.nextDouble();

      // Weibull distribution formula
      final weibullValue = scale * pow(-log(u), 1 / shape);

      // Scale the value to the range [10^6, 10^15]
      final exponent = weibullValue.clamp(0.0, 8.0).toInt() + 6;

      // Calculate 10^exponent
      final lowerBound = BigInt.from(10).pow(exponent);
      // Calculate 10^(exponent + 1)
      final upperBound = BigInt.from(10).pow(exponent + 1);

      // Generate a random BigInt in the range [lowerBound, upperBound)
      final range = upperBound - lowerBound;
      // Scale by range and convert to BigInt
      final randomOffset = BigInt.from(
        (random.nextDouble() * range.toDouble()).toInt(),
      );
      final value = lowerBound + randomOffset;

      weibullNumbers.add(value);
    }

    return weibullNumbers;
  }

  /// Generates a random amount of a balance between minPercentage and
  /// maxPercentage.
  static Coin calculateRandomAmount(
    Coin balance, {
    int minPercentage = 0,
    int maxPercentage = 80,
  }) {
    final randomPercentage =
        minPercentage + _kRandom.nextDouble() * (maxPercentage - minPercentage);

    final randomAmount = (balance.value * (randomPercentage / 100)).toInt();

    final adjustedAmount = randomAmount == 0 ? 1 : randomAmount;

    return Coin(adjustedAmount);
  }

  /// Generates a list of transaction outputs from a set of UTxOs.
  ///
  /// - [inputs]: The set of [TransactionUnspentOutput] objects to use as
  ///   inputs.
  /// - [maxOutputs]: The number of outputs to generate.
  /// - [maxTokens]: The maximum number of tokens to include in each output.
  ///
  /// Returns:
  /// - A list of [TransactionOutput] objects.
  static List<TransactionOutput> outputsFromUTxos({
    required Set<TransactionUnspentOutput> inputs,
    int maxOutputs = 1,
    int maxTokens = 3,
    int minCoinPct = 20,
    int maxCoinPct = 40,
    int maxTokenPct = 80,
  }) {
    final iLen = inputs.length;
    final maxUtxos = iLen > 10 ? (iLen * 0.1).floor() : 1;

    // A set to track unique indices
    final usedIndices = <int>{};

    return List<TransactionOutput>.generate(_kRandom.nextInt(maxOutputs) + 1,
        (int index) {
      final nrUtxos = _kRandom.nextInt(maxUtxos) + 1;
      final nrTokens = _kRandom.nextInt(maxTokens) + 1;
      var balance = const Balance.zero();

      for (var i = 0; i < nrUtxos; i++) {
        // Find a unique index
        int utxoIndex;
        do {
          utxoIndex = _kRandom.nextInt(iLen);
        } while (usedIndices.contains(utxoIndex));

        usedIndices.add(utxoIndex); // Mark the index as used

        final quantity = inputs.toList()[utxoIndex].output.amount;

        final newBalance = selectTokens(
          balance: quantity,
          outputsCount: maxOutputs,
          maxTokens: nrTokens,
          maxTokenPct: maxTokenPct,
        );

        balance += newBalance;
      }

      final coin = calculateRandomAmount(
        balance.coin,
        minPercentage: minCoinPct,
        maxPercentage: maxCoinPct,
      );
      return TransactionOutput(
        address: randomAddress(),
        amount: Balance(coin: coin, multiAsset: balance.multiAsset),
      );
    });
  }

  /// Selects a specified number of tokens from a balance.
  ///
  /// - [balance]: The [Balance] from which to select tokens.
  /// - [maxTokens]: The number of tokens to select.
  ///
  /// Returns:
  /// - A new [Balance] containing the selected tokens.
  static Balance selectTokens({
    required Balance balance,
    required int outputsCount,
    int maxTokens = 5,
    int maxTokenPct = 80,
  }) {
    final bundle = balance.multiAsset?.bundle ?? {};

    final tokens = <(PolicyId, AssetName, Coin)>[];

    for (final entry in bundle.entries) {
      final policyId = entry.key;
      final assets = entry.value.entries;
      for (final asset in assets) {
        final assetName = asset.key;
        final quantity =
            calculateRandomAmount(asset.value, maxPercentage: maxTokenPct);
        Coin(
          (((asset.value.value / outputsCount) * maxTokenPct) / 100).floor(),
        );
        if (quantity > const Coin(0)) {
          tokens.add((policyId, assetName, quantity));
        }
      }
    }

    tokens.shuffle(_kRandom);
    final result =
        tokens.take(maxTokens).fold(const Balance.zero(), (prev, token) {
      final (policyId, tokenName, quantity) = token;
      return prev +
          Balance(
            coin: balance.coin,
            multiAsset: MultiAsset(
              bundle: {
                policyId: {tokenName: quantity},
              },
            ),
          );
    });
    return result;
  }

  /// Normalizes a transaction input to meet the minimum ADA requirement.
  ///
  /// - [input]: The [TransactionUnspentOutput] to normalize.
  /// - [config]: The [TransactionBuilderConfig] to use for the normalization.
  ///
  /// Returns:
  /// - A normalized [TransactionOutput].
  static TransactionOutput normaliseInputForMinAda({
    required TransactionUnspentOutput input,
    required TransactionBuilderConfig config,
  }) {
    final output = input.output;

    final coin = output.amount.coin;

    final minAda = TransactionOutputBuilder.minimumAdaForOutput(
      output,
      config.coinsPerUtxoByte,
    );

    final outputFee =
        TransactionOutputBuilder.feeForOutput(config, output, numOutputs: 1);
    final totalFee = minAda + outputFee;

    return coin < totalFee
        ? TransactionOutput(
            address: output.address,
            amount: Balance(coin: totalFee),
          )
        : TransactionOutput(
            address: output.address,
            amount: output.amount,
          );
  }
}
