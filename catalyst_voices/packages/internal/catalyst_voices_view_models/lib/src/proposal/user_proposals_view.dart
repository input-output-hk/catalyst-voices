import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class UserProposalsView extends Equatable {
  final List<UsersProposalOverview> items;

  const UserProposalsView({
    this.items = const [],
  });

  @override
  List<Object?> get props => [items];
}
