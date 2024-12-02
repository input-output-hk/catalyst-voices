import 'dart:async';
import 'dart:math';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

part 'sign_and_submit_rbac_tx.dart';
part 'sign_and_submit_tx.dart';
part 'sign_data.dart';

/// Run only via `flutter run`:
///
/// ```shell
/// flutter run \
/// --web-header Cross-Origin-Opener-Policy=same-origin \
/// --web-header Cross-Origin-Embedder-Policy=require-corp \
/// --target lib/main.dart \
/// -d chrome
/// ```
///
/// Explanation:
/// - flutter_rust_bridge: https://cjycode.com/flutter_rust_bridge/manual/miscellaneous/web-cross-origin#when-flutter-run
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EquatableConfig.stringify = true;
  await CatalystKeyDerivation.init();
  runApp(const MyApp());
  SemanticsBinding.instance.ensureSemantics();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'catalyst_cardano_example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  Object? _error;
  List<CardanoWallet>? _wallets;
  CardanoWalletApi? _api;

  @override
  void initState() {
    super.initState();

    unawaited(_loadWallets());
  }

  @override
  Widget build(BuildContext context) {
    final Widget child;

    if (_isLoading) {
      child = const _Loader();
    } else if (_error != null) {
      child = _Error(error: _error);
    } else if (_api != null) {
      child = _WalletDetails(api: _api!);
    } else if (_wallets != null) {
      child = _wallets!.isEmpty
          ? const _EmptyWallets()
          : _WalletChooser(
              wallets: _wallets!,
              onEnable: _onEnableWallet,
            );
    } else {
      child = const _Loader();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SelectionArea(
          child: child,
        ),
      ),
    );
  }

  Future<void> _loadWallets() async {
    try {
      setState(() => _isLoading = true);
      final wallets = await CatalystCardano.instance.getWallets();
      setState(() => _wallets = wallets);
    } catch (error) {
      setState(() => _error = error);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onEnableWallet(CardanoWallet wallet) async {
    try {
      setState(() => _isLoading = true);
      final api = await wallet.enable(
        extensions: [
          const CipExtension(cip: 30),
          if (wallet.supportedExtensions.contains(const CipExtension(cip: 95)))
            const CipExtension(cip: 95),
        ],
      );

      setState(() => _api = api);
    } catch (error) {
      setState(() => _error = error);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

class _Error extends StatelessWidget {
  final Object? error;

  const _Error({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error.toString()),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _EmptyWallets extends StatelessWidget {
  const _EmptyWallets();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'There are no active wallet extensions',
      ),
    );
  }
}

class _WalletChooser extends StatelessWidget {
  final List<CardanoWallet> wallets;
  final ValueChanged<CardanoWallet> onEnable;

  const _WalletChooser({
    required this.wallets,
    required this.onEnable,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: wallets.length,
      itemBuilder: (context, index) {
        final wallet = wallets[index];
        return _WalletItem(
          wallet: wallet,
          onEnable: () => onEnable(wallet),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }
}

class _WalletItem extends StatelessWidget {
  final CardanoWallet wallet;
  final VoidCallback onEnable;

  const _WalletItem({
    required this.wallet,
    required this.onEnable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              wallet.icon,
              width: 64,
              height: 64,
            ),
            Text('Name: ${wallet.name}'),
            Text('Api version: ${wallet.apiVersion}'),
            Text(
              'Supported extensions: '
              '${_formatExtensions(wallet.supportedExtensions)}',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: Key('enableWallet-${wallet.name}'),
              onPressed: onEnable,
              child: const Text('Enable wallet'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletDetails extends StatefulWidget {
  final CardanoWalletApi api;

  const _WalletDetails({required this.api});

  @override
  State<_WalletDetails> createState() => _WalletDetailsState();
}

class _WalletDetailsState extends State<_WalletDetails> {
  Balance? _balance;
  List<CipExtension>? _extensions;
  NetworkId? _networkId;
  ShelleyAddress? _changeAddress;
  List<ShelleyAddress>? _rewardAddresses;
  List<ShelleyAddress>? _unusedAddresses;
  List<ShelleyAddress>? _usedAddresses;
  Set<TransactionUnspentOutput>? _utxos;
  PubDRepKey? _pubDRepKey;
  List<PubStakeKey>? _registeredPubStakeKeys;
  List<PubStakeKey>? _unregisteredPubStakeKeys;

  @override
  void initState() {
    super.initState();
    unawaited(_loadData());
  }

  @override
  void didUpdateWidget(_WalletDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.api != widget.api) {
      unawaited(_loadData());
    }
  }

  Future<void> _loadData() async {
    try {
      final balance = await widget.api.getBalance();
      final extensions = await widget.api.getExtensions();
      final networkId = await widget.api.getNetworkId();
      final changeAddress = await widget.api.getChangeAddress();
      final rewardAddresses = await widget.api.getRewardAddresses();
      final unusedAddresses = await widget.api.getUnusedAddresses();
      final usedAddresses = await widget.api.getUsedAddresses();
      final utxos = await widget.api.getUtxos();

      if (mounted) {
        setState(() {
          _balance = balance;
          _extensions = extensions;
          _networkId = networkId;
          _changeAddress = changeAddress;
          _rewardAddresses = rewardAddresses;
          _unusedAddresses = unusedAddresses;
          _usedAddresses = usedAddresses;
          _utxos = utxos;
        });
      }

      if (extensions.contains(const CipExtension(cip: 95))) {
        final pubDRepKey = await widget.api.cip95.getPubDRepKey();
        final registeredPubStakeKeys =
            await widget.api.cip95.getRegisteredPubStakeKeys();
        final unregisteredPubStakeKeys =
            await widget.api.cip95.getUnregisteredPubStakeKeys();

        if (mounted) {
          setState(() {
            _pubDRepKey = pubDRepKey;
            _registeredPubStakeKeys = registeredPubStakeKeys;
            _unregisteredPubStakeKeys = unregisteredPubStakeKeys;
          });
        }
      }
    } catch (error) {
      if (mounted) {
        await _showDialog(
          context: context,
          title: 'Load data',
          message: 'Error: $error',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Semantics(
            explicitChildNodes: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Balance: ${_formatBalance(_balance)}\n'),
                Text('Extensions: ${_formatExtensions(_extensions)}\n'),
                Text('Network ID: $_networkId\n'),
                Text(
                  'Change address:\n${_changeAddress?.toBech32() ?? '---'}\n',
                ),
                Text(
                  'Reward addresses:\n${_formatAddresses(_rewardAddresses)}\n',
                ),
                Text(
                  'Unused addresses:\n${_formatAddresses(_unusedAddresses)}\n',
                ),
                Text('Used addresses:\n${_formatAddresses(_usedAddresses)}\n'),
                Text('UTXOs:\n${_formatUtxos(_utxos)}\n'),
                Text('Public DRep Key: ${_pubDRepKey?.value ?? '---'}\n'),
                Text(
                  'Registered Public Stake Keys: '
                  '${_formatPubStakeKeys(_registeredPubStakeKeys)}\n',
                ),
                Text(
                  'Unregistered Public Stake Keys: '
                  '${_formatPubStakeKeys(_unregisteredPubStakeKeys)}\n',
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => unawaited(
                        _signData(
                          context: context,
                          api: widget.api,
                        ),
                      ),
                      child: const Text('Sign data'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => unawaited(
                        _signAndSubmitTx(
                          context: context,
                          api: widget.api,
                        ),
                      ),
                      child: const Text('Sign & submit tx'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => unawaited(
                        _signAndSubmitRbacTx(
                          context: context,
                          api: widget.api,
                        ),
                      ),
                      child: const Text('Sign & submit RBAC tx'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _showDialog({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) => SelectionArea(
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    ),
  );
}

String _formatExtensions(List<CipExtension>? extensions) {
  if (extensions == null) {
    return '---';
  }

  return extensions.map((e) => 'cip-${e.cip}').join(', ');
}

String _formatAddresses(List<ShelleyAddress>? addresses) {
  if (addresses == null) {
    return '---';
  }

  return addresses.map((e) => e.toBech32()).join('\n');
}

String _formatPubStakeKeys(List<PubStakeKey>? keys) {
  if (keys == null) {
    return '---';
  }

  return keys.map((e) => e.value).join(', ');
}

String _formatBalance(Balance? balance) {
  if (balance == null) {
    return '---';
  }

  final buffer = StringBuffer('Ada (lovelaces): ${balance.coin.value}');

  final multiAsset = balance.multiAsset;
  if (multiAsset != null) {
    for (final policy in multiAsset.bundle.entries) {
      for (final asset in policy.value.entries) {
        buffer.write(', ${asset.key}: ${asset.value}');
      }
    }
  }

  return buffer.toString();
}

String _formatUtxos(Set<TransactionUnspentOutput>? utxos) {
  if (utxos == null) {
    return '---';
  }

  return utxos.map(_formatUtxo).join('\n');
}

String _formatUtxo(TransactionUnspentOutput utxo) {
  return 'Tx: ${utxo.input.transactionId}'
      '\nIndex: ${utxo.input.index}'
      '\nAmount: ${_formatBalance(utxo.output.amount)}\n';
}
