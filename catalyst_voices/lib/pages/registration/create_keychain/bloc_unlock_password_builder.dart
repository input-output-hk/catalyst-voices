import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocUnlockPasswordBuilder<T>
    extends BlocSelector<RegistrationCubit, RegistrationState, T> {
  BlocUnlockPasswordBuilder({
    super.key,
    required BlocWidgetSelector<UnlockPasswordState, T> selector,
    required super.builder,
    super.bloc,
  }) : super(
          selector: (state) {
            return selector(state.keychainStateData.unlockPasswordState);
          },
        );
}
