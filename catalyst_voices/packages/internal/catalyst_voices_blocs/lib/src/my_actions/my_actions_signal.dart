import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// Base class for signals emitted by MyActionsCubit.
sealed class MyActionsSignal extends Equatable {
  const MyActionsSignal();

  @override
  List<Object?> get props => [];
}

/// Signal emitted when the tab changes in the my actions page.
final class ChangeTabMyActionsSignal extends MyActionsSignal {
  final ActionsPageTab tab;

  const ChangeTabMyActionsSignal(this.tab);

  @override
  List<Object?> get props => [tab];
}
