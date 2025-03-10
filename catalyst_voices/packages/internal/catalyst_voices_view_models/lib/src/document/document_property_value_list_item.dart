import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentLinkListItem extends DocumentPropertyValueListItem<String> {
  const DocumentLinkListItem({
    required super.id,
    required super.title,
    required super.value,
  });
}

final class DocumentMarkdownListItem
    extends DocumentPropertyValueListItem<MarkdownData> {
  const DocumentMarkdownListItem({
    required super.id,
    required super.title,
    required super.value,
  });
}

sealed class DocumentPropertyValueListItem<T> extends Equatable {
  final NodeId id;
  final String title;
  final T? value;

  const DocumentPropertyValueListItem({
    required this.id,
    required this.title,
    required this.value,
  });

  bool get isEmpty => title.isEmpty && value == null;

  @override
  List<Object?> get props => [id, title, value];
}

final class DocumentTextListItem extends DocumentPropertyValueListItem<String> {
  final bool isMultiline;

  const DocumentTextListItem({
    required super.id,
    required super.title,
    required super.value,
    this.isMultiline = false,
  });

  @override
  List<Object?> get props => super.props + [isMultiline];
}
