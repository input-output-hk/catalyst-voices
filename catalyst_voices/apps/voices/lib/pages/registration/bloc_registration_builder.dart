import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocRegistrationBuilder<T>
    extends BlocSelector<RegistrationCubit, RegistrationState, T> {
  BlocRegistrationBuilder({
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
