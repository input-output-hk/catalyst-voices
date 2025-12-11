import 'dart:convert';
import 'dart:typed_data';

Codec<Object?, Uint8List> jsonb() {
  throw UnsupportedError(
    'jsonb() is not implemented on this platform '
    'because neither `dart:ffi` nor `dart:js_interop` are available.',
  );
}
