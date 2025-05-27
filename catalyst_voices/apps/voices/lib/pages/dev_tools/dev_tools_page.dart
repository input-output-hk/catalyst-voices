import 'package:catalyst_voices/pages/dev_tools/widgets/app_info_card.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/config_card.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/documents_card.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/gateway_info_card.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/logs_card.dart';
import 'package:catalyst_voices/pages/dev_tools/widgets/x_close_button.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class DevToolsPage extends StatefulWidget {
  const DevToolsPage._();

  @override
  State<DevToolsPage> createState() => _DevToolsPageState();

  static Future<void> show(BuildContext context) {
    final route = PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: const DevToolsPage._(),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      settings: const RouteSettings(name: '/dev-tools'),
    );

    return Navigator.push(context, route);
  }
}

class _DevToolsPageState extends State<DevToolsPage> {
  DevToolsBloc? _bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VoicesAppBar(leading: XCloseButton()),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        children: const [
          AppInfoCard(),
          SizedBox(height: 12),
          GatewayInfoCard(),
          SizedBox(height: 12),
          ConfigCard(),
          SizedBox(height: 12),
          DocumentsCard(),
          SizedBox(height: 12),
          LogsCard(),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _bloc = context.read<DevToolsBloc>();
  }

  @override
  void dispose() {
    _bloc?.add(const StopWatchingSystemInfoEvent());
    _bloc = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _bloc = context.read<DevToolsBloc>()
      ..add(const UpdateAllEvent())
      ..add(const WatchSystemInfoEvent());
  }
}
