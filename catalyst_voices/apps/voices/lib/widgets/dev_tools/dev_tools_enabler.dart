import 'dart:async';

import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DevToolsEnabler extends StatefulWidget {
  final bool isEnabled;
  final Widget child;

  const DevToolsEnabler({
    super.key,
    this.isEnabled = true,
    required this.child,
  });

  @override
  State<DevToolsEnabler> createState() => _DevToolsEnablerState();
}

class _DevToolsEnablerState extends State<DevToolsEnabler> {
  StreamSubscription<DevToolsEnablerSignal>? _signalSub;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.isEnabled ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.isEnabled ? _handleTap : null,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_signalSub?.cancel());
    _signalSub = null;

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _signalSub = context
        .read<DevToolsBloc>()
        .signalStream
        .where((event) => event is DevToolsEnablerSignal)
        .cast<DevToolsEnablerSignal>()
        .listen(_handleSignal);
  }

  void _handleSignal(DevToolsEnablerSignal signal) {
    switch (signal) {
      case AlreadyEnabledSignal():
        VoicesSnackBar.hideCurrent(context);
        _showAlreadyEnabled();
      case BecameDeveloperSignal():
        VoicesSnackBar.hideCurrent(context);
        _showBecameDeveloper();
      case TapsLeftSignal(:final count):
        VoicesSnackBar.hideCurrent(context);
        _showTapsLeft(count);
    }
  }

  void _handleTap() {
    context.read<DevToolsBloc>().add(const DevToolsEnablerTappedEvent());
  }

  void _showAlreadyEnabled() {
    VoicesSnackBar(
      type: VoicesSnackBarType.info,
      title: context.l10n.devToolsAlreadyDeveloper,
      message: context.l10n.devToolsAlreadyDeveloperMessage,
    ).show(context);
  }

  void _showBecameDeveloper() {
    VoicesSnackBar(
      type: VoicesSnackBarType.success,
      title: context.l10n.devToolsBecameDeveloper,
      message: context.l10n.devToolsBecameDeveloperMessage,
    ).show(context);
  }

  void _showTapsLeft(int count) {
    VoicesSnackBar(
      type: VoicesSnackBarType.info,
      title: context.l10n.devToolsTapsLeftToEnable(count),
      message: context.l10n.devToolsTapsLeftToEnableMessage,
    ).show(context);
  }
}
