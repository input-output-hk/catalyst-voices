import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsFiltersCount extends Equatable {
  final Map<ProposalsFilterType, int> data;

  const ProposalsFiltersCount(this.data);

  @override
  List<Object?> get props => [data];

  int countOf({
    required ProposalsFilterType type,
  }) {
    return data[type] ?? 0;
  }
}
