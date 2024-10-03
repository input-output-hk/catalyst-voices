import 'package:flutter_bloc/flutter_bloc.dart';

typedef BlocValueSelector<T, S> = T Function(S state);

/// Simple extension on [BlocBuilder] but makes it easy to work with nested
/// objects when you care only about them.
class BlocBuilderSelector<B extends StateStreamable<S>, S, T>
    extends BlocBuilder<B, S> {
  BlocBuilderSelector({
    super.key,
    required BlocValueSelector<T, S> selector,
    required BlocWidgetBuilder<T> builder,
    super.bloc,
    BlocBuilderCondition<T>? buildWhen,
  }) : super(
          builder: (context, state) => builder(context, selector(state)),
          buildWhen: buildWhen != null
              ? (previous, current) {
                  return buildWhen(selector(previous), selector(current));
                }
              : null,
        );
}
