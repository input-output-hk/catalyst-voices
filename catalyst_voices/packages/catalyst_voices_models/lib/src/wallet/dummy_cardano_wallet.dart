import 'package:catalyst_cardano/catalyst_cardano.dart';

final class DummyCardanoWallet implements CardanoWallet {
  @override
  final String name;
  @override
  final String icon;
  @override
  final String? apiVersion;
  @override
  final List<CipExtension> supportedExtensions;

  DummyCardanoWallet({
    required this.name,
    required this.icon,
    this.apiVersion,
    this.supportedExtensions = const [],
  });

  @override
  Future<bool> isEnabled() => Future(() => true);

  @override
  Future<CardanoWalletApi> enable({List<CipExtension>? extensions}) {
    throw UnimplementedError();
  }
}
