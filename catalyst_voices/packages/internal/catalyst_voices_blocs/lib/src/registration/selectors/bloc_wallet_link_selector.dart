import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocWalletLinkSelector<T>
    extends BlocSelector<RegistrationCubit, RegistrationState, T> {
  BlocWalletLinkSelector({
    super.key,
    required BlocWidgetSelector<WalletLinkStateData, T> selector,
    required super.builder,
    super.bloc,
  }) : super(
          selector: (state) {
            return selector(state.walletLinkStateData);
          },
        );
}
