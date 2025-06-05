import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';

final class ContainsAuthorId extends CustomExpression<bool> {
  ContainsAuthorId({
    required CatalystId id,
  }) : super(
          "json_extract(metadata, '${ProposalMetadata.authorsNode.asPath}') "
          "LIKE '%${id.toSignificant().toUri().toStringWithoutScheme()}%'",
        );
}

final class ContainsContentAuthorName extends CustomExpression<bool> {
  ContainsContentAuthorName({
    required String query,
  }) : super(
          "json_extract(content, '${ProposalDocument.authorNameNodeId.asPath}') "
          "LIKE '%$query%'",
        );
}

final class ContainsMetadataAuthorName extends CustomExpression<bool> {
  ContainsMetadataAuthorName({
    required String query,
  }) : super(
          "json_extract(metadata, '${ProposalMetadata.authorsNode.asPath}') "
          "LIKE '%$query%'",
        );
}

final class ContainsTitle extends CustomExpression<bool> {
  ContainsTitle({
    required String query,
  }) : super(
          "json_extract(content, '${ProposalDocument.titleNodeId.asPath}') "
          "LIKE '%$query%'",
        );
}

extension on NodeId {
  /// Converts [NodeId] into jsonb well-formatted path argument.
  ///
  /// This relies on fact that [NodeId] (especially [DocumentNodeId]) is already following
  /// convention of separating paths with '.' (dots).
  ///
  /// Read more: https://sqlite.org/json1.html#path_arguments.
  String get asPath => '\$.$value';
}

extension ContentColumnExt on GeneratedColumnWithTypeConverter<DocumentDataContent, Uint8List> {
  Expression<int> get requestedFunds => jsonExtract(ProposalDocument.requestedFundsNodeId.asPath);

  Expression<String> get title => jsonExtract(ProposalDocument.titleNodeId.asPath);

  Expression<bool> hasTitle(String query) => ContainsTitle(query: query);
}

extension DocumentTableExt on $DocumentsTable {
  Expression<bool> search(String query) {
    return Expression.or(
      [
        ...metadata.hasAuthorName(query),
        content.hasTitle(query),
      ],
    );
  }
}

extension MetadataColumnExt on GeneratedColumnWithTypeConverter<DocumentDataMetadata, Uint8List> {
  List<Expression<bool>> hasAuthorName(String name) {
    return [
      ContainsMetadataAuthorName(query: name),
      ContainsContentAuthorName(query: name),
    ];
  }

  Expression<bool> isAuthor(CatalystId id) => ContainsAuthorId(id: id);

  Expression<bool> isCategory(SignedDocumentRef ref) {
    return jsonExtract<String>(ProposalMetadata.categoryIdNode.asPath).equals(ref.id);
  }
}
