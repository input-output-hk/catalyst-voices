import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final email = Email.dirty(event.email);
    final isValid = Formz.validate([email, state.password]);
    emit(
      state.copyWith(
        email: email,
        status: isValid ? FormzSubmissionStatus.success : null,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    final isValid = Formz.validate([password, state.email]);
    emit(
      state.copyWith(
        password: password,
        status: isValid ? FormzSubmissionStatus.success : null,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        if (_validateTempCredentials(
          email: state.email.value,
          password: state.password.value,
        )) {
          await _authenticationRepository.signIn(
            email: state.email.value,
            password: state.password.value,
          );

          emit(state.copyWith(status: FormzSubmissionStatus.success));
        } else {
          emit(state.copyWith(status: FormzSubmissionStatus.failure));
        }
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }

  bool _validateTempCredentials({
    required String email,
    required String password,
  }) {
    return email == _TempConstants.email && password == _TempConstants.password;
  }
}

abstract class _TempConstants {
  static const email = 'mail@example.com';
  static const password = 'MyPass123';
}
