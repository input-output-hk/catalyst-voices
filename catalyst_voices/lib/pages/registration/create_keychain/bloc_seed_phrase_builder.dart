import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';

class BlocSeedPhraseBuilder<T>
    extends BlocBuilderSelector<RegistrationCubit, RegistrationState, T> {
  BlocSeedPhraseBuilder({
    super.key,
    required BlocValueSelector<T, SeedPhraseStateData> selector,
    required super.builder,
    super.bloc,
    super.buildWhen,
  }) : super(
          selector: (state) {
            return selector(state.keychainStateData.seedPhraseStateData);
          },
        );
}
