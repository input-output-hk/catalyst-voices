import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher containsHeaderKey(String expected) => _HeaderKey(expected);

Matcher containsHeaderValue(String expected) => _HeaderValue(expected);

class _HeaderKey extends Matcher {
  final String value;

  _HeaderKey(this.value);

  @override
  Description describe(Description description) {
    return description.add('contains header key ').addDescriptionOf(value);
  }

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item is! Request) {
      return false;
    }

    return item.headers.containsKey(value);
  }
}

class _HeaderValue extends Matcher {
  final String value;

  _HeaderValue(this.value);

  @override
  Description describe(Description description) {
    return description.add('contains header value ').addDescriptionOf(value);
  }

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item is! Request) {
      return false;
    }

    return item.headers.containsValue(value);
  }
}
