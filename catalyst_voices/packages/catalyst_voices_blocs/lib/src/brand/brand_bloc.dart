import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'brand_event.dart';
part 'brand_state.dart';

/// [BrandBloc] is a Bloc responsible for managing the brand state.
///
/// This Bloc listens for [BrandEvent]s and updates the [BrandState]
/// accordingly.
/// The [BrandState] can be consumed by the [MaterialApp] to build the
/// appropriate [ThemeData] based on the [Brand] stored in the state.
///
/// To build the appropriate [ThemeData] based on the [Brand] is
/// possible to use the [ThemeBuilder] utility form the `catalyst_voices_brands`
/// package.
///
/// The [BrandChangedEvent] accepts a [Brand] a simple enum that
/// contains all possible brands/themes.
///
/// To trigger the theme change is just necessary to dispatch the
/// [BrandChangedEvent] with the appropriate key:
///
/// ```dart
/// context.read<BrandBloc>().add(
///   const BrandChangedEvent(BrandKey.catalyst),
/// );
/// ```
///
/// Usage example:
///
/// ```dart
/// BlocProvider(
///   create: (context) => BrandBloc(),
///   child: BlocBuilder<BrandBloc, BrandState>(
///     builder: (context, state) {
///       return MaterialApp(
///         home: Builder(
///           builder: (context) => Scaffold(
///             body: Row(
///               children: [
///                 MaterialButton(
///                   color: Theme.of(context).primaryColor,
///                   onPressed: () {
///                     context.read<BrandBloc>().add(
///                       const BrandChangedEvent(BrandKey.catalyst),
///                     );
///                   },
///                   child: const Text('Switch to Catalyst Theme'),
///                 ),
///               ],
///             ),
///           ),
///         ),
///         theme: ThemeBuilder.buildTheme(state.brandKey),
///       );
///     },
///   ),
/// );
/// ```
final class BrandBloc extends Bloc<BrandEvent, BrandState> {
  BrandBloc() : super(const BrandState()) {
    on<BrandChangedEvent>(_onBrandChanged);
  }

  void _onBrandChanged(
    BrandChangedEvent event,
    Emitter<BrandState> emit,
  ) {
    emit(BrandState(brand: event.brand));
  }
}
