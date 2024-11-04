import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:poc_local_storage/app.dart';
import 'package:poc_local_storage/secure_certificate_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const App());
}

final SecureCertificateRepository certificateRepo =
    SecureCertificateRepository();
