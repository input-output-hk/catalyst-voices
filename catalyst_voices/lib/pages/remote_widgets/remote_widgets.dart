// ignore_for_file: discarded_futures, unused_field

import 'dart:async';

import 'package:catalyst_voices/pages/remote_widgets/core/catalyst_core.dart'
    as core;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rfw/rfw.dart';

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

  late final Future<void> _initFuture;

  final _runtime = Runtime();
  final _data = DynamicContent();
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return RemoteWidget(
      runtime: _runtime,
      data: _data,
      widget: const FullyQualifiedWidgetName(remoteName, 'root'),
      onEvent: onEvent,
    );
  }

  Future<void> fetchWidget() async {
    final res = await http.get(
      Uri.parse(
        'https://github.com/minikin/minikin.github.io/raw/main/rfw/home_page.rfw',
      ),
    );

    if (res.statusCode == 200) {
      final remoteWidget = decodeLibraryBlob(res.bodyBytes);
      print('remoteWidget: $remoteWidget');
      _runtime.update(remoteName, remoteWidget);
    }
  }

  @override
  void initState() {
    super.initState();
    _initFuture = _init();
  }

  Future<void> onEvent(String name, DynamicMap arguments) async {
    debugPrint('event $name($arguments)');
  }

  @override
  void reassemble() {
    super.reassemble();
    _initFuture = _init();
  }

  Future<void> _init() async {
    await _update();
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

  Future<void> _update() async {
    _registerWidgets();
    await fetchWidget();
    if (mounted) setState(() => loaded = true);
  }
}
