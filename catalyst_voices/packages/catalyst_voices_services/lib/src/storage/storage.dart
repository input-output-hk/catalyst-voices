//ignore_for_file: one_member_abstracts

import 'dart:async';

///
abstract interface class Storage {
  FutureOr<String?> readString(String key);
}
