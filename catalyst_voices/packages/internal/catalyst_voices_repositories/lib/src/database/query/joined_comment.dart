import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:equatable/equatable.dart';

final class JoinedComment extends Equatable {
  final DocumentEntity document;
  final DocumentEntity template;

  const JoinedComment({
    required this.document,
    required this.template,
  });

  @override
  List<Object?> get props => [document, template];
}
