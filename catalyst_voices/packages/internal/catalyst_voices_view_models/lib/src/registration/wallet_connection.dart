import 'package:equatable/equatable.dart';

final class WalletConnectionData extends Equatable {
  final String name;
  final String? icon;
  final bool isConnected;

  const WalletConnectionData({
    required this.name,
    this.icon,
    this.isConnected = true,
  });

  @override
  List<Object?> get props => [
        name,
        icon,
        isConnected,
      ];
}
