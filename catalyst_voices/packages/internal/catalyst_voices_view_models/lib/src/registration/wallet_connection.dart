import 'package:equatable/equatable.dart';

/// Data class representing a wallet connection.
///
/// This class is used to store information about a wallet connection,
/// including the name, icon, and connection status.
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
