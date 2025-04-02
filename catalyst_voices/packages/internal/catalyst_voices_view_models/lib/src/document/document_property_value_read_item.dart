import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentLinkReadItem extends DocumentPropertyValueListItem<String> {
  const DocumentLinkReadItem({
    required super.id,
    required super.title,
    required super.isRequired,
    required super.value,
  });
}

final class DocumentMarkdownListItem
    extends DocumentPropertyValueListItem<MarkdownData> {
  const DocumentMarkdownListItem({
    required super.id,
    required super.title,
    required super.isRequired,
    required super.value,
  });
}

sealed class DocumentPropertyValueListItem<T> extends Equatable {
  final DocumentNodeId id;
  final String title;
  final bool isRequired;
  final T? value;

  const DocumentPropertyValueListItem({
    required this.id,
    required this.title,
    required this.isRequired,
    required this.value,
  });

  bool get isEmpty => title.isEmpty && value == null;

  @override
  List<Object?> get props => [id, title, isRequired, value];
}

final class DocumentTextListItem extends DocumentPropertyValueListItem<String> {
  final bool isMultiline;

  const DocumentTextListItem({
    required super.id,
    required super.title,
    required super.isRequired,
    required super.value,
    this.isMultiline = false,
  });

  @override
  List<Object?> get props => super.props + [isMultiline];
}
