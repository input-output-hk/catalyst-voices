import 'package:catalyst_voices_models/src/user/user.dart';
import 'package:catalyst_voices_models/src/wallet/wallet_info.dart';
import 'package:equatable/equatable.dart';

/// Defines singular profile used by [User]. One [User] may have multiple
/// [Profile]'s.
final class Profile extends Equatable {
  final WalletInfo walletInfo;

  const Profile({
    required this.walletInfo,
  });

  @override
  List<Object?> get props => [
        walletInfo,
      ];
}
