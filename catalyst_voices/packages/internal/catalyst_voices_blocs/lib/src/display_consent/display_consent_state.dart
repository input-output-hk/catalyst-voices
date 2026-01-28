import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class DisplayConsentState extends Equatable {
  final List<CollaboratorProposalDisplayConsent> items;

  const DisplayConsentState({
    this.items = const [],
  });

  @override
  List<Object?> get props => [items];

  DisplayConsentState copyWith({
    List<CollaboratorProposalDisplayConsent>? items,
  }) {
    return DisplayConsentState(items: items ?? this.items);
  }
}
