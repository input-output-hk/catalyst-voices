import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class CampaignDetailsState extends Equatable {
  final String? title;
  final List<CampaignListItem> listItems;

  const CampaignDetailsState({
    this.title,
    this.listItems = const [],
  });

  CampaignDetailsState copyWith({
    Optional<String>? title,
    List<CampaignListItem>? listItems,
  }) {
    return CampaignDetailsState(
      title: title.dataOr(this.title),
      listItems: listItems ?? this.listItems,
    );
  }

  @override
  List<Object?> get props => [
        title,
        listItems,
      ];
}
