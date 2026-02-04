import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class AddCollaboratorSignal extends Equatable {
  const AddCollaboratorSignal();

  @override
  List<Object?> get props => [];
}

final class ValidCollaboratorIdSignal extends AddCollaboratorSignal {
  final CatalystId catalystId;
  const ValidCollaboratorIdSignal(this.catalystId);

  @override
  List<Object?> get props => [...super.props, catalystId];
}
