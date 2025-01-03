import 'dart:convert';

class IntCodec extends Codec<int, String> {
  const IntCodec();

  @override
  Converter<String, int> get decoder => const IntDecoder();

  @override
  Converter<int, String> get encoder => const IntEncoder();
}

class IntDecoder extends Converter<String, int> {
  const IntDecoder();

  @override
  int convert(String input) => int.parse(input);
}

class IntEncoder extends Converter<int, String> {
  const IntEncoder();

  @override
  String convert(int input) => '$input';
}
