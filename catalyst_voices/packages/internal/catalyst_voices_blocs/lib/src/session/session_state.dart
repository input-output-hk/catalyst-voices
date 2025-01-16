import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Determines the state of the user session.
sealed class SessionState extends Equatable {
  const SessionState();

  /// Currently used account by this session. Null when not active.
  SessionAccount? get account => null;

  /// Returns a list of all available spaces
  /// corresponding to the current session state.
  List<Space> get spaces => const [];

  /// Returns a list of [spaces] that should be shown in overall spaces menu.
  List<Space> get overallSpaces => const [];
}

/// The user hasn't registered yet nor setup the keychain.
final class VisitorSessionState extends SessionState {
  final bool isRegistrationInProgress;

  const VisitorSessionState({
    required this.isRegistrationInProgress,
  });

  @override
  List<Space> get spaces => const [Space.discovery];

  @override
  List<Object?> get props => [
        isRegistrationInProgress,
      ];
}

/// The user has registered the keychain but it's locked.
final class GuestSessionState extends SessionState {
  const GuestSessionState();

  @override
  List<Space> get spaces => const [Space.discovery];

  @override
  List<Object?> get props => [];
}

/// The user has registered and unlocked the keychain.
final class ActiveAccountSessionState extends SessionState {
  @override
  final SessionAccount account;
  @override
  final List<Space> spaces;
  @override
  final List<Space> overallSpaces;
  final Map<Space, ShortcutActivator> spacesShortcuts;

  const ActiveAccountSessionState({
    required this.account,
    required this.spaces,
    required this.overallSpaces,
    required this.spacesShortcuts,
  });

  @override
  List<Object?> get props => [
        account,
        spaces,
        overallSpaces,
        spacesShortcuts,
      ];
}
