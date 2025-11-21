import 'package:equatable/equatable.dart';

final class ActiveCampaignNotFoundException extends Equatable implements Exception {
  const ActiveCampaignNotFoundException();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'ActiveCampaignNotFoundException';
}
