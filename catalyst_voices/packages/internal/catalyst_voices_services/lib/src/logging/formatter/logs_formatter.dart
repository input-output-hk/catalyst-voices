import 'package:logging/logging.dart';

// ignore: one_member_abstracts
abstract interface class LogsFormatter {
  String format(Iterable<LogRecord> logs);
}
