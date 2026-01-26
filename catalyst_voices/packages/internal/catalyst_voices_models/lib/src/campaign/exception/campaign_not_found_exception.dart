import 'package:equatable/equatable.dart';

final class CampaignNotFoundException extends Equatable implements Exception {
  final String id;

  const CampaignNotFoundException({required this.id});

  @override
  List<Object?> get props => [id];

  @override
  String toString() => 'CampaignNotFoundException($id)';
}
