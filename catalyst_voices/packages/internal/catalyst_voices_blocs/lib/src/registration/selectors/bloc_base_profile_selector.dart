import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';

class BlocBaseProfileSelector<T> extends BlocSelector<RegistrationCubit, RegistrationState, T> {
  BlocBaseProfileSelector({
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
