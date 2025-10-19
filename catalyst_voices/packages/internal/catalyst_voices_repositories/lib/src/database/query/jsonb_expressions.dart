import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart' show Documents;
import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';

final class ContainsAuthorId extends JsonQuerySearchExpression {
  ContainsAuthorId({
    required CatalystId id,
  }) : super(
         searchValue: id.toSignificant().toUri().toStringWithoutScheme(),
         nodeId: ProposalMetadata.authorsNode,
         jsonContent: 'metadata',
       );
}

final class ContainsContentAuthorName extends JsonQuerySearchExpression {
  ContainsContentAuthorName({
    required String query,
  }) : super(
         searchValue: query,
         nodeId: ProposalDocument.authorNameNodeId,
         jsonContent: 'content',
       );
}

final class ContainsMetadataAuthorName extends JsonQuerySearchExpression {
  ContainsMetadataAuthorName({
    required String query,
  }) : super(
         searchValue: query,
         nodeId: ProposalMetadata.authorsNode,
         jsonContent: 'metadata',
       );
}

final class ContainsParameterId extends JsonQuerySearchExpression {
  ContainsParameterId({
    required String parameterId,
  }) : super(
         searchValue: parameterId,
         nodeId: ProposalMetadata.parametersIdNode,
         jsonContent: 'metadata',
         useExactMatch: true,
       );
}

final class ContainsParameterIdInList extends JsonQuerySearchMultiExpression {
  ContainsParameterIdInList({
    required List<String> ids,
  }) : super(
         searchValues: ids,
         jsonContent: 'metadata',
         nodeId: ProposalMetadata.parametersIdNode,
       );
}

final class ContainsTitle extends JsonQuerySearchExpression {
  ContainsTitle({
    required String query,
  }) : super(
         searchValue: query,
         nodeId: ProposalDocument.titleNodeId,
         jsonContent: 'content',
       );
}

class JsonBExpressions {
  const JsonBExpressions();

  static String generateSqlForJsonMultiQuery({
    required String jsonContent,
    required NodeId nodeId,
    required List<String> searchValues,
  }) {
    final valueComparison = "IN (${searchValues.map((e) => "'$e'").join(',')})";
    final handler = WildcardPathHandler.fromNodeId(nodeId);
    final wildcardPaths = handler.getWildcardPaths;

    if (!handler.hasWildcard || wildcardPaths == null) {
      return _queryJsonExtract(
        jsonContent: jsonContent,
        nodeId: nodeId,
        valueComparison: valueComparison,
      );
    }

    final arrayPath = wildcardPaths.prefix.value.isEmpty ? '' : wildcardPaths.prefix.asPath;
    final fieldName = wildcardPaths.suffix?.asPath;

    if (wildcardPaths.prefix.value.isEmpty) {
      return _queryJsonTreeForKey(
        jsonContent: jsonContent,
        fieldName: fieldName?.substring(2),
        valueComparison: valueComparison,
      );
    }

    if (fieldName != null) {
      return _queryJsonEachForWildcard(
        jsonContent: jsonContent,
        arrayPath: arrayPath,
        fieldName: fieldName,
        valueComparison: valueComparison,
      );
    }

    return _queryJsonTreeForWildcard(
      jsonContent: jsonContent,
      arrayPath: arrayPath,
      valueComparison: valueComparison,
    );
  }

  static String generateSqlForJsonQuery({
    required String jsonContent,
    required NodeId nodeId,
    required String searchValue,
    bool useExactMatch = false,
  }) {
    final valueComparison = useExactMatch ? "= '$searchValue'" : "LIKE '%$searchValue%'";
    final handler = WildcardPathHandler.fromNodeId(nodeId);
    final wildcardPaths = handler.getWildcardPaths;

    if (!handler.hasWildcard || wildcardPaths == null) {
      return _queryJsonExtract(
        jsonContent: jsonContent,
        nodeId: nodeId,
        valueComparison: valueComparison,
      );
    }

    final arrayPath = wildcardPaths.prefix.value.isEmpty ? '' : wildcardPaths.prefix.asPath;
    final fieldName = wildcardPaths.suffix?.asPath;

    if (wildcardPaths.prefix.value.isEmpty) {
      return _queryJsonTreeForKey(
        jsonContent: jsonContent,
        fieldName: fieldName?.substring(2),
        valueComparison: valueComparison,
      );
    }

    if (fieldName != null) {
      return _queryJsonEachForWildcard(
        jsonContent: jsonContent,
        arrayPath: arrayPath,
        fieldName: fieldName,
        valueComparison: valueComparison,
      );
    }

    return _queryJsonTreeForWildcard(
      jsonContent: jsonContent,
      arrayPath: arrayPath,
      valueComparison: valueComparison,
    );
  }

  static String _queryJsonEachForWildcard({
    required String jsonContent,
    required String arrayPath,
    required String fieldName,
    required String valueComparison,
  }) {
    return "EXISTS (SELECT 1 FROM json_each(json_extract($jsonContent, '$arrayPath')) WHERE json_extract(value, '$fieldName') $valueComparison)";
  }

  static String _queryJsonExtract({
    required String jsonContent,
    required NodeId nodeId,
    required String valueComparison,
  }) {
    return "json_extract($jsonContent, '${nodeId.asPath}') $valueComparison";
  }

  static String _queryJsonTreeForKey({
    required String jsonContent,
    required String? fieldName,
    required String valueComparison,
  }) {
    return "EXISTS (SELECT 1 FROM json_tree($jsonContent) WHERE key LIKE '$fieldName' AND json_tree.value $valueComparison)";
  }

  static String _queryJsonTreeForWildcard({
    required String jsonContent,
    required String arrayPath,
    required String valueComparison,
  }) {
    return "EXISTS (SELECT 1 FROM json_tree($jsonContent, '$arrayPath') WHERE json_tree.value $valueComparison)";
  }
}

class JsonQuerySearchExpression extends Expression<bool> {
  final String jsonContent;
  final NodeId nodeId;
  final String searchValue;
  final bool useExactMatch;

  const JsonQuerySearchExpression({
    required this.jsonContent,
    required this.nodeId,
    required this.searchValue,
    this.useExactMatch = false,
  });

  @override
  void writeInto(GenerationContext context) {
    final sql = JsonBExpressions.generateSqlForJsonQuery(
      jsonContent: jsonContent,
      nodeId: nodeId,
      searchValue: searchValue,
    );

    context.buffer.write(sql);
  }
}

class JsonQuerySearchMultiExpression extends Expression<bool> {
  final String jsonContent;
  final NodeId nodeId;
  final List<String> searchValues;

  const JsonQuerySearchMultiExpression({
    required this.jsonContent,
    required this.nodeId,
    required this.searchValues,
  });

  @override
  void writeInto(GenerationContext context) {
    final sql = JsonBExpressions.generateSqlForJsonMultiQuery(
      jsonContent: jsonContent,
      nodeId: nodeId,
      searchValues: searchValues,
    );

    context.buffer.write(sql);
  }
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

/// Extension allowing extraction of commonly used values from [DocumentDataContent] in a type-safe way.
extension ContentColumnExt on GeneratedColumnWithTypeConverter<DocumentDataContent, Uint8List> {
  Expression<int> get requestedFunds => jsonExtract(ProposalDocument.requestedFundsNodeId.asPath);

  Expression<String> get title => jsonExtract(ProposalDocument.titleNodeId.asPath);

  Expression<bool> hasTitle(String query) => ContainsTitle(query: query);
}

/// Extension allowing extraction of commonly used values from [Documents] table in a type-safe way.
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

/// Extension allowing extraction of commonly used values from [DocumentDataMetadata] in a type-safe way.
extension MetadataColumnExt on GeneratedColumnWithTypeConverter<DocumentDataMetadata, Uint8List> {
  List<Expression<bool>> hasAuthorName(String name) {
    return [
      ContainsMetadataAuthorName(query: name),
      ContainsContentAuthorName(query: name),
    ];
  }

  Expression<bool> isAuthor(CatalystId id) => ContainsAuthorId(id: id);

  Expression<bool> isCategory(SignedDocumentRef ref) {
    return Expression.or([
      jsonExtract<String>(ProposalMetadata.categoryIdNode.asPath).equals(ref.id),
      ContainsParameterId(parameterId: ref.id),
    ]);
  }

  Expression<bool> isInCategoryList(List<String> ids) {
    return Expression.or([
      jsonExtract<String>(ProposalMetadata.categoryIdNode.asPath).isIn(ids),
      ContainsParameterIdInList(ids: ids),
    ]);
  }
}
