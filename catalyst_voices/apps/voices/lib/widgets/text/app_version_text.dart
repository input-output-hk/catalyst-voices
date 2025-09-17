import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionText extends StatefulWidget {
  final Color color;

  const AppVersionText({super.key, required this.color});

  @override
  State<AppVersionText> createState() => _AppVersionTextState();
}

class _AppVersionTextState extends State<AppVersionText> {
  PackageInfo? _packageInfo;

  @override
  Widget build(BuildContext context) {
    if (_packageInfo case final packageInfo?) {
      return Text(
        context.l10n.appVersion(packageInfo.version, packageInfo.buildNumber),
        style: context.textTheme.bodyMedium?.copyWith(color: widget.color),
        textAlign: TextAlign.center,
      );
    }
    return const Offstage();
  }

  @override
  void initState() {
    super.initState();
    unawaited(_initPackageInfo());
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
}
