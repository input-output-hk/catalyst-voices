import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';

class BaseJsonQueryExpression extends Expression<bool> {
  final String jsonContent;
  final NodeId nodeId;
  final String searchValue;
  final bool useExactMatch;

  const BaseJsonQueryExpression({
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

final class ContainsAuthorId extends BaseJsonQueryExpression {
  ContainsAuthorId({
    required CatalystId id,
  }) : super(
          searchValue: id.toSignificant().toUri().toStringWithoutScheme(),
          nodeId: ProposalMetadata.authorsNode,
          jsonContent: 'metadata',
        );
}

final class ContainsContentAuthorName extends BaseJsonQueryExpression {
  ContainsContentAuthorName({
    required String query,
  }) : super(
          searchValue: query,
          nodeId: ProposalDocument.authorNameNodeId,
          jsonContent: 'content',
        );
}

final class ContainsMetadataAuthorName extends BaseJsonQueryExpression {
  ContainsMetadataAuthorName({
    required String query,
  }) : super(
          searchValue: query,
          nodeId: ProposalMetadata.authorsNode,
          jsonContent: 'metadata',
        );
}

final class ContainsTitle extends BaseJsonQueryExpression {
  ContainsTitle({
    required String query,
  }) : super(
          searchValue: query,
          nodeId: ProposalDocument.titleNodeId,
          jsonContent: 'content',
        );
}

class JsonBExpressions {
  static String generateSqlForJsonQuery({
    required String jsonContent,
    required NodeId nodeId,
    required String searchValue,
    bool useExactMatch = false,
  }) {
    final valueComparison = useExactMatch ? "= '$searchValue'" : "LIKE '%$searchValue%'";

    if (nodeId.hasWildcard) {
      final components = nodeId.wildcardPaths;
      if (components != null) {
        final arrayPath = components.prefix;
        final fieldName = components.suffix;

        if (fieldName != null) {
          // Query for specific field in array elements
          return "EXISTS (SELECT 1 FROM json_each(json_extract($jsonContent, '$arrayPath')) WHERE json_extract(value, '\$.$fieldName') $valueComparison)";
        } else {
          // Just search in the array
          return "EXISTS (SELECT 1 FROM json_tree($jsonContent, '$arrayPath') WHERE json_tree.value $valueComparison)";
        }
      }
    }

    // Standard path without wildcards
    final path = nodeId.asPath;
    if (useExactMatch) {
      return "json_extract($jsonContent, '$path') $valueComparison";
    } else {
      return "json_extract($jsonContent, '$path') $valueComparison";
    }
  }
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
