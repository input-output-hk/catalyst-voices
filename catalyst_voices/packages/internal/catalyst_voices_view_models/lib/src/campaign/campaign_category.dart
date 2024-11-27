import 'package:equatable/equatable.dart';

final class CampaignCategory extends Equatable {
  final String id;
  final String name;

  const CampaignCategory({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
