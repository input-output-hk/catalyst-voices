import 'package:catalyst_voices_blocs/src/account/account_event.dart';
import 'package:catalyst_voices_blocs/src/account/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(const AccountState());
}
