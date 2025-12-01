import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class CollaboratorsIds extends Equatable {
  final List<CatalystId> collaborators;

  const CollaboratorsIds({this.collaborators = const []});

  @override
  List<Object?> get props => [collaborators];
}
