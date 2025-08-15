import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/semantics.dart';

void main() async {
  await bootstrapAndRun(AppEnvironment.fromEnv());
  SemanticsBinding.instance.ensureSemantics();
}
