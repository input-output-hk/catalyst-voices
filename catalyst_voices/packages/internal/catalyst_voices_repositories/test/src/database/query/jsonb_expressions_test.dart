import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/query/jsonb_expressions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(JsonBExpressions, () {
    test('generateSqlForJsonQuery handles simple paths correctly', () {
      const handler = NodeId('user.name');
      final sql = JsonBExpressions.generateSqlForJsonQuery(
        jsonContent: 'content',
        nodeId: handler,
        searchValue: 'John',
      );

      expect(sql, contains(r"json_extract(content, '$.user.name')"));
      expect(sql, contains("LIKE '%John%'"));
    });

    test('generateSqlForJsonQuery handles exact match correctly', () {
      const handler = NodeId('user.id');
      final sql = JsonBExpressions.generateSqlForJsonQuery(
        jsonContent: 'content',
        nodeId: handler,
        searchValue: '123',
        useExactMatch: true,
      );

      expect(sql, contains(r"json_extract(content, '$.user.id') = '123'"));
    });

    test('generateSqlForJsonQuery handles wildcard array correctly', () {
      const handler = NodeId('items.*');
      final sql = JsonBExpressions.generateSqlForJsonQuery(
        jsonContent: 'content',
        nodeId: handler,
        searchValue: 'test',
      );

      expect(sql, contains(r"SELECT 1 FROM json_tree(content, '$.items')"));
      expect(sql, contains("WHERE json_tree.value LIKE '%test%'"));
    });

    test('generateSqlForJsonQuery handles wildcard with field correctly', () {
      const handler = NodeId('items.*.name');
      final sql = JsonBExpressions.generateSqlForJsonQuery(
        jsonContent: 'content',
        nodeId: handler,
        searchValue: 'test',
      );

      expect(sql, contains(r"SELECT 1 FROM json_each(json_extract(content, '$.items'))"));
      expect(sql, contains(r"WHERE json_extract(value, '$.name') LIKE '%test%'"));
    });
  });
}
