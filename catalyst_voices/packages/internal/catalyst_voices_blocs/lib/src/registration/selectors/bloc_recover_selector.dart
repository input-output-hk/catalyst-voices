import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocRecoverSelector<T>
    extends BlocSelector<RegistrationCubit, RegistrationState, T> {
  BlocRecoverSelector({
    super.key,
    required BlocWidgetSelector<RecoverStateData, T> selector,
    required super.builder,
    super.bloc,
  }) : super(
          selector: (state) {
            return selector(state.recoverStateData);
          },
        );
}
