import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalTemplateMoneyFormats extends Equatable {
  final DocumentRef ref;
  final Map<NodeId, MoneyFormat> formats;

  const ProposalTemplateMoneyFormats({
    required this.ref,
    required this.formats,
  });

  @override
  List<Object?> get props => [
    ref,
    formats,
  ];
}
