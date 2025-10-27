import 'package:json_annotation/json_annotation.dart';

part 'current_page.g.dart';

/// Current Page of data being returned.
@JsonSerializable()
final class CurrentPage {
  /// The page number of the data.
  /// The size of each page, and its offset within the complete data set is determined by the [limit] parameter.
  final int page;

  /// The size [limit] of each [page] of results.
  /// Determines the maximum amount of data that can be returned in a valid response.
  ///
  /// This [limit] of records of data will always be returned unless there is less data to return
  /// than allowed for by the [limit] and [page].
  ///
  /// *Exceeding the [page]/[limit] of all available records will not return `404`, it will return an
  /// empty response.*
  final int limit;

  /// The number of items remaining to be returned after this page.
  /// This is the absolute number of items remaining, and not the number of Pages.
  final int remaining;

  const CurrentPage({
    required this.page,
    required this.limit,
    required this.remaining,
  });

  factory CurrentPage.fromJson(Map<String, dynamic> json) => _$CurrentPageFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentPageToJson(this);
}
