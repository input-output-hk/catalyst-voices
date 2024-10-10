import 'package:catalyst_cardano/catalyst_cardano.dart';

final class DummyCardanoWallet implements CardanoWallet {
  DummyCardanoWallet({
    required this.name,
    required this.icon,
    this.apiVersion,
    this.supportedExtensions = const [],
  });

  @override
  final String name;
  @override
  final String icon;
  @override
  final String? apiVersion;
  @override
  final List<CipExtension> supportedExtensions;

  @override
  Future<bool> isEnabled() => Future(() => true);

  @override
  Future<CardanoWalletApi> enable({List<CipExtension>? extensions}) {
    throw UnimplementedError();
  }
}
