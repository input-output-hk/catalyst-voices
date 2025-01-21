import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Determines the state of the user session.
sealed class SessionState extends Equatable {
  /// Currently used account by this session. Null when not active.
  final SessionAccount? account;

  /// Returns a list of all available spaces
  /// corresponding to the current session state.
  final List<Space> spaces;

  /// Returns a list of [spaces] that should be shown in overall spaces menu.
  final List<Space> overallSpaces;

  /// On Web it can mean that user don't have valid extensions installed.
  final bool canCreateAccount;

  const SessionState({
    this.account,
    required this.spaces,
    this.overallSpaces = const [],
    this.canCreateAccount = false,
  });

  @override
  @mustCallSuper
  List<Object?> get props => [
        account,
        spaces,
        overallSpaces,
        canCreateAccount,
      ];
}

/// The user hasn't registered yet nor setup the keychain.
final class VisitorSessionState extends SessionState {
  final bool isRegistrationInProgress;

  const VisitorSessionState({
    required this.isRegistrationInProgress,
    super.canCreateAccount,
  }) : super(
          spaces: const [Space.discovery],
        );

  @override
  List<Object?> get props => [
        ...super.props,
        isRegistrationInProgress,
      ];
}

/// The user has registered the keychain but it's locked.
final class GuestSessionState extends SessionState {
  const GuestSessionState({
    super.canCreateAccount,
  }) : super(
          spaces: const [Space.discovery],
        );
}

/// The user has registered and unlocked the keychain.
final class ActiveAccountSessionState extends SessionState {
  final Map<Space, ShortcutActivator> spacesShortcuts;

  const ActiveAccountSessionState({
    required SessionAccount super.account,
    required super.spaces,
    required super.overallSpaces,
    super.canCreateAccount,
    required this.spacesShortcuts,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        spacesShortcuts,
      ];
}
