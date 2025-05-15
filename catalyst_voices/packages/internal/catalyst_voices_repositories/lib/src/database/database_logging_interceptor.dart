import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

const _cancellationMessage = 'Operation was cancelled';
const _clauseKeywords = [
  'SELECT',
  'FROM',
  'INNER JOIN',
  'LEFT JOIN',
  'RIGHT JOIN',
  'JOIN',
  'ON',
  'WHERE',
  'GROUP BY',
  'ORDER BY',
  'HAVING',
  'LIMIT',
  'OFFSET',
];
const _indent = '  ';

final class DatabaseLoggingInterceptor extends QueryInterceptor {
  final bool isEnabled;
  final bool onlyErrors;
  final Logger logger;

  var _operationNr = 0;

  DatabaseLoggingInterceptor({
    this.isEnabled = true,
    this.onlyErrors = true,
    required String dbName,
  }) : logger = Logger(dbName);

  @override
  Future<void> commitTransaction(TransactionExecutor inner) {
    return _run(
      () => 'commit',
      () => super.commitTransaction(inner),
    );
  }

  @override
  Future<void> rollbackTransaction(TransactionExecutor inner) {
    return _run(
      () => 'rollback',
      () => super.rollbackTransaction(inner),
    );
  }

  @override
  Future<void> runBatched(
    QueryExecutor executor,
    BatchedStatements statements,
  ) {
    return _run(
      () => 'batch with ${_prettyBatch(statements)}',
      () => super.runBatched(executor, statements),
    );
  }

  @override
  Future<void> runCustom(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    return _run(
      () => _prettyFormat(statement, args),
      () => super.runCustom(executor, statement, args),
    );
  }

  @override
  Future<int> runDelete(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    return _run(
      () => _prettyFormat(statement, args),
      () => super.runDelete(executor, statement, args),
    );
  }

  @override
  Future<int> runInsert(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    return _run(
      () => _prettyFormat(statement, args),
      () => super.runInsert(executor, statement, args),
    );
  }

  @override
  Future<List<Map<String, Object?>>> runSelect(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    return _run(
      () => _prettyFormat(statement, args),
      () => super.runSelect(executor, statement, args),
    );
  }

  @override
  Future<int> runUpdate(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    return _run(
      () => _prettyFormat(statement, args),
      () => super.runUpdate(executor, statement, args),
    );
  }

  void _log(
    Level logLevel,
    String message, [
    Object? error,
    StackTrace? stack,
  ]) {
    if (!isEnabled) {
      return;
    }

    if (onlyErrors && error == null) {
      return;
    }

    logger.log(
      logLevel,
      message,
      error,
      stack,
    );
  }

  String _prettyBatch(BatchedStatements statements) {
    return statements.statements.mapIndexed(
      (index, statement) {
        final args = statements.arguments
            .firstWhereOrNull((args) => args.statementIndex == index)
            ?.arguments;

        return _prettyFormat(statement, args ?? []);
      },
    ).join(', ');
  }

  String _prettyFormat(String statement, List<Object?> args) {
    var formatted = statement
        // Insert args
        .replaceAllMappedIndexed(
      '?',
      (match, index) {
        final arg = args.elementAtOrNull(index);
        final formattedArg = arg is Uint8List ? '*bytes*' : arg;

        return formattedArg.toString();
      },
    )
        // Normalize spacing
        .replaceAll(RegExp(r'\s+'), ' ');

    for (final keyword in _clauseKeywords) {
      final pattern = RegExp('\\b$keyword\\b', caseSensitive: false);
      formatted = formatted.replaceAllMapped(
        pattern,
        (match) => '\n${match.group(0)}',
      );
    }

    // Line breaks for AND/OR within WHERE and ON
    formatted = formatted.replaceAllMapped(
      RegExp(r'\b(AND|OR)\b', caseSensitive: false),
      (match) => '\n  ${match.group(0)}',
    );

    // New lines after commas outside parentheses (e.g., SELECT, GROUP BY)
    formatted = formatted.replaceAllMapped(
      RegExp(r',(?![^()]*\))'),
      (match) => ',\n  ',
    );

    // Indentation
    final lines = formatted.split('\n');
    final buffer = StringBuffer();

    var indentLevel = 0;

    for (var line in lines) {
      line = line.trim();

      // Adjust indent level based on parentheses
      final openParens = '('.allMatches(line).length;
      final closeParens = ')'.allMatches(line).length;

      if (closeParens > openParens) {
        indentLevel = (indentLevel - (closeParens - openParens)).clamp(0, indentLevel);
      }

      buffer.writeln('${_indent * indentLevel}$line');

      if (openParens > closeParens) {
        indentLevel += (openParens - closeParens);
      }
    }

    return buffer.toString().trim();
  }

  Future<T> _run<T>(
    String Function() description,
    FutureOr<T> Function() operation,
  ) async {
    if (!isEnabled) {
      return operation();
    }

    final nr = _operationNr++;
    final stopwatch = Stopwatch()..start();

    _log(Level.INFO, '[$nr] Running ${description()}');

    try {
      final result = await operation();

      stopwatch.stop();

      _log(
        Level.INFO,
        '[$nr] => succeeded after ${stopwatch.elapsedMilliseconds}ms',
      );

      return result;
    } catch (error, stack) {
      if (error.toString() == _cancellationMessage) {
        _log(Level.FINEST, '[$nr] => was cancelled');
      } else {
        _log(
          Level.WARNING,
          '[$nr] => failed after ${stopwatch.elapsedMilliseconds}ms',
          error,
          stack,
        );
      }

      rethrow;
    }
  }
}
