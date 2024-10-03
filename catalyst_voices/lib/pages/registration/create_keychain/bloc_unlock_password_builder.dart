import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';

class BlocUnlockPasswordBuilder<T>
    extends BlocBuilderSelector<RegistrationCubit, RegistrationState, T> {
  BlocUnlockPasswordBuilder({
    super.key,
    required BlocValueSelector<T, UnlockPasswordState> selector,
    required super.builder,
    super.bloc,
    super.buildWhen,
  }) : super(
          selector: (state) {
            return selector(state.keychainStateData.unlockPasswordState);
          },
        );
}
