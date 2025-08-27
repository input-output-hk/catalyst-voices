import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract interface class ReportingService {
  http.Client buildHttpClient();

  Future<void> init({
    required ReportingServiceConfig config,
    required ValueGetter<FutureOr<void>> appRunner,
  });

  Future<void> reportingAs(Account? account);
}
