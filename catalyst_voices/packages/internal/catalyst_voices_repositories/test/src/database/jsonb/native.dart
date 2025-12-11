import 'dart:convert';
import 'dart:typed_data';

import 'package:sqlite3/common.dart' as sqlite3 show jsonb;

Codec<Object?, Uint8List> jsonb() => sqlite3.jsonb;
