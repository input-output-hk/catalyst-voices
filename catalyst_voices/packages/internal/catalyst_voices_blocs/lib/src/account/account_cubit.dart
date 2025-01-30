import 'dart:async';

import 'package:catalyst_voices_blocs/src/account/account_state.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class AccountCubit extends Cubit<AccountState> {
  StreamSubscription<dynamic>? _sub;
  StreamSubscription<dynamic>? _sub2;

  AccountCubit() : super(const AccountState()) {
    _sub = Stream.periodic(
      const Duration(seconds: 5),
      (computationCount) => computationCount.isEven ? 'Damian' : 'Not Damian',
    ).listen(_t);

    _sub2 = Stream.periodic(
      const Duration(seconds: 5),
      (computationCount) =>
          computationCount.isEven ? 'damian@iohk.com' : 'damian@gmail.com',
    ).listen(_t2);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _sub = null;

    _sub2?.cancel();
    _sub2 = null;

    return super.close();
  }

  Future<void> updateDisplayName(DisplayName value) async {
    //
  }

  Future<void> updateEmail(Email value) async {
    //
  }

  void _t(String value) {
    emit(
      state.copyWith(displayName: DisplayName.dirty(value)),
    );
  }

  void _t2(String value) {
    emit(
      state.copyWith(email: Email.dirty(value)),
    );
  }
}
