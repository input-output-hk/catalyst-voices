import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocBaseProfileBuilder<T>
    extends BlocSelector<RegistrationCubit, RegistrationState, T> {
  BlocBaseProfileBuilder({
    super.key,
    required BlocWidgetSelector<BaseProfileStateData, T> selector,
    required super.builder,
    super.bloc,
  }) : super(
          selector: (state) {
            return selector(state.baseProfileStateData);
          },
        );
}
