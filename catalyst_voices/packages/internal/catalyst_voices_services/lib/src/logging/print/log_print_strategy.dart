import 'package:logging/logging.dart';

//ignore: one_member_abstracts
abstract interface class LogPrintStrategy {
  void print(LogRecord log);
}
