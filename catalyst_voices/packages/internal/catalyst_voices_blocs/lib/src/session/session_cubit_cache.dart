import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class SessionCubitCache extends Equatable {
  final UserSettings? userSettings;
  final Account? account;
  final AdminToolsState? adminToolsState;
  final bool hasWallets;
  final bool isVotingFeatureFlagEnabled;
  final bool hasProposalsActions;

  const SessionCubitCache({
    this.userSettings,
    this.account,
    this.adminToolsState,
    this.hasWallets = false,
    this.isVotingFeatureFlagEnabled = false,
    this.hasProposalsActions = false,
  });

  @override
  List<Object?> get props => [];

  SessionCubitCache copyWith({
    Optional<UserSettings>? userSettings,
    Optional<Account>? account,
    AdminToolsState? adminToolsState,
    bool? hasWallets,
    bool? isVotingFeatureFlagEnabled,
    bool? hasProposalsActions,
  }) {
    return SessionCubitCache(
      userSettings: userSettings.dataOr(this.userSettings),
      account: account.dataOr(this.account),
      adminToolsState: adminToolsState ?? this.adminToolsState,
      hasWallets: hasWallets ?? this.hasWallets,
      isVotingFeatureFlagEnabled: isVotingFeatureFlagEnabled ?? this.isVotingFeatureFlagEnabled,
      hasProposalsActions: hasProposalsActions ?? this.hasProposalsActions,
    );
  }
}
