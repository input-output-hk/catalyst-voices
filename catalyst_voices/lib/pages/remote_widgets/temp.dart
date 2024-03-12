import 'dart:async';

import 'package:catalyst_voices/pages/remote_widgets/core/catalyst_core.dart'
    as core;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rfw/rfw.dart';

const _remoteWidgetOne =
    'https://github.com/minikin/minikin.github.io/raw/main/rfw/home_page.rfw';

class NetworkExample extends StatefulWidget {
  const NetworkExample({super.key});

  @override
  State<NetworkExample> createState() => _NetworkExampleState();
}

class _NetworkExampleState extends State<NetworkExample> {
  static const remoteName = LibraryName(['remote']);
  static const catalystCore = LibraryName(['core', 'catalyst']);
  static const widgets = LibraryName(['core', 'widgets']);
  static const material = LibraryName(['core', 'material']);

  final _runtime = Runtime();
  final _data = DynamicContent();

  final _remoteWidget = _remoteWidgetOne;
  late final Future<void> _widgetFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _widgetFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return RemoteWidget(
            runtime: _runtime,
            data: _data,
            widget: const FullyQualifiedWidgetName(remoteName, 'root'),
            onEvent: onEvent,
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _configure();
  }

  Future<void> onEvent(String name, DynamicMap arguments) async {
    debugPrint('event $name($arguments)');
  }

  void _configure() {
    _registerWidgets();
    _widgetFuture = _fetchWidget();
  }

  Future<void> _fetchWidget() async {
    final res = await http.get(
      Uri.parse(
        _remoteWidget,
      ),
    );

    if (res.statusCode == 200) {
      final remoteWidget = decodeLibraryBlob(res.bodyBytes);
      _runtime.update(remoteName, remoteWidget);
    }
  }

  void _registerWidgets() {
    _runtime
      ..update(
        widgets,
        createCoreWidgets(),
      )
      ..update(
        material,
        createMaterialWidgets(),
      )
      ..update(
        catalystCore,
        core.createCatalystCoreWidgets(),
      );
  }
}
