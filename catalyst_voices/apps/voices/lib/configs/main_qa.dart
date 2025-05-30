import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/semantics.dart';

void main() async {
  await bootstrapAndRun(const AppEnvironment.dev());
  SemanticsBinding.instance.ensureSemantics();
}
