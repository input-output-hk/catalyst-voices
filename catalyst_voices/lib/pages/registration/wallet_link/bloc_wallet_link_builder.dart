import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocWalletLinkBuilder<T>
    extends BlocSelector<RegistrationCubit, RegistrationState, T> {
  BlocWalletLinkBuilder({
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
