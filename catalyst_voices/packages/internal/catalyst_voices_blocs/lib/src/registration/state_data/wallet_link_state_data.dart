import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:result_type/result_type.dart';

final class WalletLinkStateData extends Equatable {
  final Result<List<WalletMetadata>, Exception>? wallets;
  final WalletInfo? selectedWallet;
  final bool hasEnoughBalance;
  final bool isNetworkIdMatching;
  final WalletConnectionData? walletConnection;
  final WalletSummaryData? walletSummary;
  final List<RegistrationRole> roles;
  final Set<AccountRole> accountRoles;

  const WalletLinkStateData({
    this.wallets,
    this.selectedWallet,
    this.hasEnoughBalance = false,
    this.isNetworkIdMatching = false,
    this.walletConnection,
    this.walletSummary,
    this.roles = const [],
    this.accountRoles = const {},
  });

  factory WalletLinkStateData.initial() {
    final roles = AccountRole.values
        .where((element) => !element.isHidden)
        .map(
          (e) => RegistrationRole(
            type: e,
            isSelected: e.isDefault,
            isLocked: e.isDefault,
          ),
        )
        .toList();

    return WalletLinkStateData(roles: roles);
  }

  bool get areRolesValid {
    final selectedRoleTypes = this.selectedRoleTypes;
    if (selectedRoleTypes.length != accountRoles.length) {
      return true;
    }

    return !selectedRoleTypes.containsAll(accountRoles);
  }

  /// Returns the roles that are newly being added (selected but not yet owned).
  List<RegistrationRole> get newlyAddedRoles {
    return roles.where((role) => role.isSelected && !accountRoles.contains(role.type)).toList();
  }

  @override
  List<Object?> get props => [
    wallets,
    selectedWallet,
    hasEnoughBalance,
    isNetworkIdMatching,
    walletConnection,
    walletSummary,
    roles,
    accountRoles,
  ];

  Set<AccountRole> get selectedRoleTypes {
    return roles.where((role) => role.isSelected).map((e) => e.type).toSet();
  }

  WalletLinkStateData copyWith({
    Optional<Result<List<WalletMetadata>, Exception>>? wallets,
    Optional<WalletInfo>? selectedWallet,
    bool? hasEnoughBalance,
    bool? isNetworkIdMatching,
    Optional<WalletConnectionData>? walletConnection,
    Optional<WalletSummaryData>? walletSummary,
    List<RegistrationRole>? roles,
    Set<AccountRole>? accountRoles,
  }) {
    return WalletLinkStateData(
      wallets: wallets.dataOr(this.wallets),
      selectedWallet: selectedWallet.dataOr(this.selectedWallet),
      hasEnoughBalance: hasEnoughBalance ?? this.hasEnoughBalance,
      isNetworkIdMatching: isNetworkIdMatching ?? this.isNetworkIdMatching,
      walletConnection: walletConnection.dataOr(this.walletConnection),
      walletSummary: walletSummary.dataOr(this.walletSummary),
      roles: roles ?? this.roles,
      accountRoles: accountRoles ?? this.accountRoles,
    );
  }
}
