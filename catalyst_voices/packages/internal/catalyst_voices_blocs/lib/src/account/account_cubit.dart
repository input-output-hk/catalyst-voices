import 'dart:async';

import 'package:catalyst_voices_blocs/src/account/account_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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

    Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        final items =
            AccountRole.values.where((role) => !role.isHidden).map((e) {
          return MyAccountRoleItem(
            type: e,
            isSelected: e.isDefault,
          );
        }).toList();
        final roles = AccountRolesState(
          items: items,
          canAddRole: items.any((element) => !element.isSelected),
        );
        emit(state.copyWith(roles: roles));
      },
    );

    emit(
      state.copyWith(
        walletConnected:
            'addr1q9gkq75mt2hykrktnsgt2zxrj5h9jnd6gkwr5s4r8v5x3dzp8n9h9mns5w7zx95jhtwz46yq4nr7y6hhlwtq75jflsqq9dxry2',
      ),
    );
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
