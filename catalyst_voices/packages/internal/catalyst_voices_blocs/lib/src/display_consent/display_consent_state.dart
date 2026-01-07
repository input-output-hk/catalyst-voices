import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class DisplayConsentState extends Equatable {
  final ProposalsDisplayConsent consents;

  const DisplayConsentState({
    this.consents = const ProposalsDisplayConsent(),
  });

  @override
  List<Object?> get props => [consents];

  DisplayConsentState copyWith({ProposalsDisplayConsent? consents}) {
    return DisplayConsentState(consents: consents ?? this.consents);
  }
}

final class ProposalsDisplayConsent extends Equatable {
  final List<CollaboratorProposalDisplayConsent> items;

  const ProposalsDisplayConsent({this.items = const []});

  @override
  List<Object?> get props => [items];

  ProposalsDisplayConsent copyWith({
    List<CollaboratorProposalDisplayConsent>? items,
  }) {
    return ProposalsDisplayConsent(
      items: items ?? this.items,
    );
  }
}
