import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:test/test.dart';

void main() {
  group('StringExt', () {
    test('first returns value letter or null', () {
      expect('Hello'.first, 'H');
      expect(''.first, isNull);
    });

    test('isBlank and isNotBlank correctly identify blank strings', () {
      expect('   '.isBlank, isTrue);
      expect('Hello'.isBlank, isFalse);
      expect('   '.isNotBlank, isFalse);
      expect('Hello'.isNotBlank, isTrue);
    });

    test('capitalize converts value letter to uppercase', () {
      expect('hello'.capitalize(), 'Hello');
      expect('HELLO'.capitalize(), 'Hello');
      expect('hELLO'.capitalize(), 'Hello');
      expect(''.capitalize(), '');
    });

    test('starred method adds * correctly', () {
      expect('hello'.starred(), '*hello');
      expect('hello'.starred(leading: false), 'hello*');
      expect('hello'.starred(isEnabled: false), 'hello');
    });

    test('withPrefix adds prefix correctly', () {
      expect('world'.withPrefix('Hello '), 'Hello world');
    });

    test('withSuffix adds suffix correctly', () {
      expect('Hello'.withSuffix(' World'), 'Hello World');
    });

    test('equalsIgnoreCase ignores lower or upper case', () {
      expect('Hello'.equalsIgnoreCase('HELLO'), isTrue);
      expect('HELLO'.equalsIgnoreCase('Hello'), isTrue);
      expect('hello'.equalsIgnoreCase('HELLO'), isTrue);
      expect('123'.equalsIgnoreCase('123'), isTrue);
      expect('!@#'.equalsIgnoreCase('!@#'), isTrue);
      expect('Hello1'.equalsIgnoreCase('Hello2'), isFalse);
    });
  });

  group('UrlParser Tests', () {
    test('getUri correctly parses URLs', () {
      expect('https://example.com'.getUri(), isA<Uri>());
      expect('https://example.com'.getUri().host, 'example.com');
    });
  });
}
