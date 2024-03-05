import 'package:catalyst_voices/pages/remote_widgets/remote_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'remote_page_route.g.dart';

const remotePath = '/remote';

@TypedGoRoute<RemoteWidgetsRoute>(path: remotePath)
final class RemoteWidgetsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RemoteWidgetsPage();
  }
}
