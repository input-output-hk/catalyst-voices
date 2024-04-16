import 'package:bloc/bloc.dart';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'brand_event.dart';
part 'brand_state.dart';

// [BrandBloc] is a Bloc responsible for managing the brand state.
// This Bloc listens for [BrandEvent]s and updates the [BrandState]
// accordingly.
// The [BrandState] can be passed to the [MaterialApp] as a theme
// allowing to change the theme at runtime.
//
// The [BrandChanged] accepts a [BrandKey] and uses that is used for
// the selection of the related [ThemeData] defined in the [brands]
// map.
// To trigger the theme change is just necessary to dispatch the
// [BrandChanged] with the appropriate key:
//
// ```dart
// context.read<BrandBloc>().add(
//   const BrandChanged(BrandKey.catalyst),
// );
// ```
//
// Usage example:
//
// ```dart
// BlocProvider(
//   create: (context) => BrandBloc(),
//   child: BlocBuilder<BrandBloc, BrandState>(
//     builder: (context, state) {
//       return MaterialApp(
//         builder: (context, state) => Scaffold(
//           body: Row(
//             children: [
//               MaterialButton(
//                 color: Theme.of(context).primaryColor,
//                 onPressed: () {
//                   context.read<BrandBloc>().add(
//                     const BrandChanged(BrandKey.catalyst),
//                   );
//                 },
//                 child: const Text('Switch to Catalyst Theme'),
//               ),
//             ],
//           ),
//         ),
//         theme: state.themeData,
//       );
//     },
//   ),
// );
// ```


final class BrandBloc extends Bloc<BrandEvent, BrandState> {
  BrandBloc() : super(BrandState()) {
    on<BrandChanged>(_onBrandChanged);
  }

  void _onBrandChanged(
    BrandChanged event,
    Emitter<BrandState> emit,
  ) {
    emit(BrandState(themeData: brands[event.brand]));
  }

}
