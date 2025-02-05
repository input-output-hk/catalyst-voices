import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocUnlockPasswordSelector<T>
    extends BlocSelector<RegistrationCubit, RegistrationState, T> {
  BlocUnlockPasswordSelector({
    super.key,
    required BlocWidgetSelector<RegistrationState, UnlockPasswordState>
        stateSelector,
    required BlocWidgetSelector<UnlockPasswordState, T> selector,
    required super.builder,
    super.bloc,
  }) : super(
          selector: (state) {
            return selector(stateSelector(state));
          },
        );
}
