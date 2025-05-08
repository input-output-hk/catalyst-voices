import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

final class DatabaseLoggingInterceptor extends QueryInterceptor {
  final bool isEnabled;
  final bool onlyErrors;
  final Logger logger;

  DatabaseLoggingInterceptor({
    this.isEnabled = true,
    this.onlyErrors = true,
    required String dbName,
  }) : logger = Logger(dbName);

  @override
  Future<void> commitTransaction(TransactionExecutor inner) {
    return _run('commit', () => super.commitTransaction(inner));
  }

  @override
  Future<void> rollbackTransaction(TransactionExecutor inner) {
    return _run('rollback', () => super.rollbackTransaction(inner));
  }

  @override
  Future<void> runBatched(
    QueryExecutor executor,
    BatchedStatements statements,
  ) {
    return _run(
      'batch with ${_formatBatchedStatements(statements)}',
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
      'custom with ${_formatStatementWithArgs(statement, args)}',
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
      'delete with ${_formatStatementWithArgs(statement, args)}',
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
      'insert with ${_formatStatementWithArgs(statement, args)}',
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
      'select with ${_formatStatementWithArgs(statement, args)}',
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
      'update with ${_formatStatementWithArgs(statement, args)}',
      () => super.runUpdate(executor, statement, args),
    );
  }

  String _formatBatchedStatements(BatchedStatements statements) {
    return statements.statements.mapIndexed(
      (index, statement) {
        final args = statements.arguments
            .firstWhereOrNull((args) => args.statementIndex == index)
            ?.arguments;

        return _formatStatementWithArgs(statement, args ?? []);
      },
    ).join(',');
  }

  String _formatStatementWithArgs(String statement, List<Object?> args) {
    final buffer = StringBuffer(statement);

    if (args.isNotEmpty) {
      final readableArgs = args.map(
        (arg) {
          if (arg is Uint8List) {
            return 'Bytes[${arg.length}]';
          }

          return arg;
        },
      ).toString();

      buffer
        ..write(' ')
        ..write(readableArgs);
    }

    return buffer.toString();
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

  Future<T> _run<T>(
    String description,
    FutureOr<T> Function() operation,
  ) async {
    if (!isEnabled) {
      return operation();
    }

    final stopwatch = Stopwatch()..start();

    _log(Level.INFO, 'Running $description');

    try {
      final result = await operation();

      stopwatch.stop();

      _log(
        Level.INFO,
        ' => succeeded after ${stopwatch.elapsedMilliseconds}ms',
      );

      return result;
    } catch (error, stack) {
      _log(
        Level.WARNING,
        ' => failed after ${stopwatch.elapsedMilliseconds}ms',
        error,
        stack,
      );

      rethrow;
    }
  }
}
