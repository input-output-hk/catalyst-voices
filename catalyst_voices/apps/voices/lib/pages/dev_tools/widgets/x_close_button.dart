import 'dart:async';

import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class XCloseButton extends StatelessWidget {
  const XCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return XButton(
      onTap: () => unawaited(Navigator.of(context).maybePop()),
    );
  }
}
