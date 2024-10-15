import 'package:catalyst_voices_models/src/user/user.dart';
import 'package:catalyst_voices_models/src/wallet/wallet_header.dart';
import 'package:equatable/equatable.dart';

/// Defines singular profile used by [User]. One [User] may have multiple
/// [Profile]'s.
final class Profile extends Equatable {
  final WalletHeader walletHeader;

  const Profile({
    required this.walletHeader,
  });

  @override
  List<Object?> get props => [
        walletHeader,
      ];
}
