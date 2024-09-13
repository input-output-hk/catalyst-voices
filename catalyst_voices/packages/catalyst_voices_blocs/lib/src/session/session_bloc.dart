import 'package:catalyst_voices_blocs/src/session/session_event.dart';
import 'package:catalyst_voices_blocs/src/session/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the user session.
final class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(const VisitorSessionState()) {
    on<NextStateSessionEvent>(_handleNextState);
  }

  void _handleNextState(
    NextStateSessionEvent event,
    Emitter<SessionState> emit,
  ) {
    final nextState = switch (state) {
      VisitorSessionState() => const GuestSessionState(),
      GuestSessionState() => const ActiveUserSessionState(),
      ActiveUserSessionState() => const VisitorSessionState(),
    };

    emit(nextState);
  }
}
