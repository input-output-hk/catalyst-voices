import 'package:intl/intl.dart';

abstract class AmountFormatter {
  static String decimalFormat(num value) {
    return NumberFormat.decimalPattern().format(value);
  }
}
