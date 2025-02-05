import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocSeedPhraseSelector<T>
    extends BlocSelector<RegistrationCubit, RegistrationState, T> {
  BlocSeedPhraseSelector({
    super.key,
    required BlocWidgetSelector<SeedPhraseStateData, T> selector,
    required super.builder,
    super.bloc,
  }) : super(
          selector: (state) {
            return selector(state.keychainStateData.seedPhraseStateData);
          },
        );
}
