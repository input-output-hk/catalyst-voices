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
      widget: const FullyQualifiedWidgetName(remoteName, 'root'),
      onEvent: onEvent,
    ));
  }

  Future<void> fetchWidget() async {
    final res = await http.get(
      Uri.parse('http://localhost:8080/'),
    );

    if (res.statusCode == 200) {
      _runtime.update(remoteName, decodeLibraryBlob(res.bodyBytes));
    }
  }

  @override
  void initState() {
    super.initState();
    _runtime.update(
      catalystCore,
      core.createCatalystCoreWidgets(),
    );
    _update();
  }

  Future<void> onEvent(String name, DynamicMap arguments) async {
    debugPrint('event $name($arguments)');
  }

  @override
  void reassemble() {
    super.reassemble();
    _update();
  }

  Future<void> _update() async {
    _runtime
      ..update(
        const LibraryName(['widgets']),
        createCoreWidgets(),
      )
      ..update(
        const LibraryName(['material']),
        createMaterialWidgets(),
      )
      ..update(
        catalystCore,
        core.createCatalystCoreWidgets(),
      );
    await fetchWidget();
    if (mounted) setState(() => loaded = true);
  }
}
