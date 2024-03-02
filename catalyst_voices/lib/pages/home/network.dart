// ignore_for_file: discarded_futures

import 'dart:async';
import 'dart:io';

import 'package:catalyst_voices/pages/home/catalyst_core.dart' as core;
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
  static const catalystCore = LibraryName(['catalyst']);
  static const widgets = LibraryName(['widgets']);
  static const material = LibraryName(['material']);
  final dynamicContent = DynamicContent();

  late final Future<void> _initFuture;

  final _runtime = Runtime();
  final _data = DynamicContent();
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return (RemoteWidget(
      runtime: _runtime,
      data: _data,
      widget: const FullyQualifiedWidgetName(remoteName, 'home'),
      onEvent: onEvent,
    ));
  }

  Future<void> fetchWidget() async {
    final res = await http.get(
      Uri.parse(
        'https://github.com/minikin/minikin.github.io/raw/main/assets/home_page.rfw',
      ),
    );

    final client = await (await HttpClient().getUrl(
      Uri.parse(
        'https://github.com/minikin/minikin.github.io/raw/main/assets/home_page.rfw',
      ),
    ))
        .close();

    print('res: ${res.bodyBytes}');

    if (res.statusCode == 200) {
      final value = decodeDataBlob(res.bodyBytes);
      print('value: $value');
      dynamicContent.update('remote', value);
      // _runtime.update(remoteName, value);
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
