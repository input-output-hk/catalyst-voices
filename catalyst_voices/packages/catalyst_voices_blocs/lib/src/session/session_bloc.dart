import 'package:catalyst_voices_blocs/src/session/session_event.dart';
import 'package:catalyst_voices_blocs/src/session/session_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the user session.
final class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(const VisitorSessionState()) {
    on<SessionEvent>(_handleSessionEvent);
  }

  void _handleSessionEvent(
    SessionEvent event,
    Emitter<SessionState> emit,
  ) {
    final nextState = switch (event) {
      NextStateSessionEvent() => switch (state) {
          VisitorSessionState() => const GuestSessionState(),
          GuestSessionState() => const ActiveUserSessionState(
              user: User(name: 'Account'),
            ),
          ActiveUserSessionState() => const VisitorSessionState(),
        },
      VisitorSessionEvent() => const VisitorSessionState(),
      GuestSessionEvent() => const GuestSessionState(),
      ActiveUserSessionEvent() => const ActiveUserSessionState(
          user: User(name: 'Account'),
        ),
    };

    emit(nextState);
  }
}
