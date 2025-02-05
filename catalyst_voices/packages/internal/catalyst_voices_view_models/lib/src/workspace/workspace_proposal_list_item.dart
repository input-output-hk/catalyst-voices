import 'package:equatable/equatable.dart';

final class WorkspaceProposalListItem extends Equatable {
  final String id;
  final String name;

  const WorkspaceProposalListItem({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
