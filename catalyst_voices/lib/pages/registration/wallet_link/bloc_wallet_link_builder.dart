import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';

class BlocWalletLinkBuilder<T>
    extends BlocBuilderSelector<RegistrationCubit, RegistrationState, T> {
  BlocWalletLinkBuilder({
    super.key,
    required super.builder,
    required BlocValueSelector<T, WalletLinkStateData> selector,
    super.bloc,
    super.buildWhen,
  }) : super(
          selector: (state) {
            return selector(state.walletLinkStateData);
          },
        );
}
