import 'package:equatable/equatable.dart';

class CategoryDescriptionViewModel extends Equatable {
  final String title;
  final String description;

  const CategoryDescriptionViewModel({
    required this.title,
    required this.description,
  });

  factory CategoryDescriptionViewModel.dummy() =>
      const CategoryDescriptionViewModel(
        title: 'Brief',
        description: '''
Use cases deliver adoption and real world utility of Cardano to a global base of users and customers. Use cases can be in the nature of applications, products, and new services that lay the foundations for innovative business ideas to flourish on Cardano.

The Cardano Use Cases: Concept category is aimed towards projects seeking to develop early stage ideas that will deliver proof of concept, design research and basic prototyping for innovative Cardano-based products, services, and business models.

It will help support proposers, especially new Catalyst entrants, get their idea off the ground and gain experience of working with product design processes. Your project must generate and test new ideas that bring utility to Cardano.''',
      );

  @override
  List<Object?> get props => [title, description];
}
