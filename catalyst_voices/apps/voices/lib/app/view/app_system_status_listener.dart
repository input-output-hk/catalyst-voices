import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/notification/catalyst_messenger.dart';
import 'package:catalyst_voices/notification/specialized/banner/system_status_issue_banner.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class SystemStatusListener extends StatefulWidget {
  final Widget child;

  const SystemStatusListener({
    super.key,
    required this.child,
  });

  @override
  State<SystemStatusListener> createState() => _SystemStatusListenerState();
}

class _SystemStatusListenerState extends State<SystemStatusListener>
    with SignalHandlerStateMixin<SystemStatusCubit, SystemStatusSignal, SystemStatusListener> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void handleSignal(SystemStatusSignal signal) {
    switch (signal) {
      case SystemStatusIssueSignal():
        CatalystMessenger.of(context).add(SystemStatusIssueBanner());
      case CancelSystemStatusIssueSignal():
        CatalystMessenger.of(
          context,
        ).cancelWhere((notification) => notification is SystemStatusIssueBanner);
    }
  }
}
