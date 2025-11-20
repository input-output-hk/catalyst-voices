import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class Collaborators extends Equatable {
  final List<CatalystId> collaborators;

  const Collaborators({this.collaborators = const []});

  @override
  List<Object?> get props => [collaborators];
}
