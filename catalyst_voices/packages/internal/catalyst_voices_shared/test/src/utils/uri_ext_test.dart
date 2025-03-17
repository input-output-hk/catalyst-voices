import 'package:catalyst_voices_shared/src/utils/uri_ext.dart';
import 'package:test/test.dart';

void main() {
  group('UriExt', () {
    test('removes scheme from http URL', () {
      final uri = Uri.parse('http://example.com/path?query=123');
      expect(uri.toStringWithoutScheme(), 'example.com/path?query=123');
    });

    test('removes scheme from https URL', () {
      final uri = Uri.parse('https://www.example.com/test');
      expect(uri.toStringWithoutScheme(), 'www.example.com/test');
    });

    test('removes scheme from custom scheme URL', () {
      final uri = Uri.parse('custom-scheme://some.domain/app');
      expect(uri.toStringWithoutScheme(), 'some.domain/app');
    });

    test('returns unchanged string if no scheme present', () {
      final uri = Uri.parse('//example.com/path');
      expect(uri.toStringWithoutScheme(), 'example.com/path');
    });

    test('handles root-relative URLs correctly', () {
      final uri = Uri.parse('/relative/path');
      expect(uri.toStringWithoutScheme(), '/relative/path');
    });
  });
}
