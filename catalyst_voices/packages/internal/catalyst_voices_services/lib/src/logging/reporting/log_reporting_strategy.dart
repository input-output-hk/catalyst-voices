import 'package:logging/logging.dart';

//ignore: one_member_abstracts
abstract interface class LogReportingStrategy {
  void report(LogRecord log);
}
