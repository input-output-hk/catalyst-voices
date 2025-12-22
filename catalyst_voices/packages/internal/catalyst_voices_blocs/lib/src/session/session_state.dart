import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Determines the state of the user session.
final class SessionState extends Equatable {
  final SessionStatus status;

  /// Currently used account by this session. Null when not active.
  final SessionAccount? account;

  /// Whether has unfinished registration.
  final bool isRegistrationInProgress;

  /// Returns a list of all spaces that user can access
  /// corresponding to the current session state.
  final List<Space> spaces;

  /// Returns a list of [spaces] that should be shown in overall spaces menu.
  final List<Space> overallSpaces;

  /// Drawer shortcuts available.
  final Map<Space, ShortcutActivator> spacesShortcuts;

  /// On Web it can mean that user don't have valid extensions installed.
  final bool canCreateAccount;

  /// Hold current session settings.
  final SessionSettings settings;

  /// Whether the user has pending proposal actions (invites or approvals).
  final bool hasProposalsActions;

  const SessionState({
    required this.status,
    this.account,
    this.isRegistrationInProgress = false,
    required this.spaces,
    this.overallSpaces = const [],
    this.spacesShortcuts = const {},
    this.canCreateAccount = false,
    this.settings = const SessionSettings.fallback(),
    this.hasProposalsActions = false,
  });

  const SessionState.guest({
    required bool canCreateAccount,
    SessionSettings settings = const SessionSettings.fallback(),
    bool hasProposalsActions = false,
  }) : this(
         status: SessionStatus.guest,
         canCreateAccount: canCreateAccount,
         spaces: AccessControl.defaultSpacesAccess,
         settings: settings,
         hasProposalsActions: hasProposalsActions,
       );

  const SessionState.initial()
    : this(
        status: SessionStatus.visitor,
        spaces: AccessControl.defaultSpacesAccess,
      );

  const SessionState.visitor({
    required bool canCreateAccount,
    required bool isRegistrationInProgress,
    SessionSettings settings = const SessionSettings.fallback(),
    bool hasProposalActions = false,
  }) : this(
         status: SessionStatus.visitor,
         canCreateAccount: canCreateAccount,
         isRegistrationInProgress: isRegistrationInProgress,
         spaces: AccessControl.defaultSpacesAccess,
         settings: settings,
         hasProposalsActions: hasProposalActions,
       );

  bool get isActive => status == SessionStatus.actor;

  bool get isGuest => status == SessionStatus.guest;

  bool get isProposerUnlock => isActive && (account?.isProposer ?? false);

  bool get isVisitor => status == SessionStatus.visitor;

  @override
  List<Object?> get props => [
    status,
    account,
    isRegistrationInProgress,
    spaces,
    overallSpaces,
    spacesShortcuts,
    canCreateAccount,
    settings,
    hasProposalsActions,
  ];
}
