import 'dart:convert';

/// A [Codec] that parses [double] from decimal [String].
class DoubleCodec extends Codec<double, String> {
  const DoubleCodec();

  @override
  Converter<String, double> get decoder => const DoubleDecoder();

  @override
  Converter<double, String> get encoder => const DoubleEncoder();
}

class DoubleDecoder extends Converter<String, double> {
  const DoubleDecoder();

  @override
  double convert(String input) => double.parse(input);
}

class DoubleEncoder extends Converter<double, String> {
  const DoubleEncoder();

  @override
  String convert(double input) => input.toString();
}
