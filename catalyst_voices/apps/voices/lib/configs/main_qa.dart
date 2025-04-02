import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:flutter/semantics.dart';

void main() async {
  await bootstrapAndRun();
  SemanticsBinding.instance.ensureSemantics();
}
