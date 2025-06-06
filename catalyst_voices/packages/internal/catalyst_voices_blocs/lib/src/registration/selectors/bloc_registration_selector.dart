import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';

class BlocRegistrationSelector<T> extends BlocSelector<RegistrationCubit, RegistrationState, T> {
  BlocRegistrationSelector({
    super.key,
    required BlocWidgetSelector<RegistrationStateData, T> selector,
    required super.builder,
    super.bloc,
  }) : super(
          selector: (state) {
            return selector(state.registrationStateData);
          },
        );
}
